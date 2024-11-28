import express from 'express';
import getDatabaseConnection from '../db.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

/**
 * POST /orders
 * Place a new order for the logged-in user.
 * 
 * This route requires authentication (handled by `authMiddleware`), and the order details 
 * (cart and total amount) should be provided in the request body. The order is inserted into
 * the `order` and `order_item` tables using a database transaction.
 * @name orders_backend
 * @route POST /orders
 * @group Orders - Operations related to user orders
 * @security BearerAuth
 * @param {Array} cart - Array of cart items. Each item should contain product_id, quantity, and price.
 * @param {number} totalAmount - The total amount of the order.
 * @returns {Object} 201 - Success message with orderId if order is successfully placed.
 * @returns {Object} 500 - Error message if there is an error during order creation.
 */
router.post('/', authMiddleware, async (req, res) => {
    const { cart, totalAmount } = req.body;
    const userId = req.user.id;
  
    const conn = await getDatabaseConnection();
    try {
      // Start transaction
      await conn.query('START TRANSACTION');
  
      // Insert into order table
      const orderResult = await conn.query(
        'INSERT INTO `order` (user_id, total_amount) VALUES (?, ?)',
        [userId, totalAmount]
      );
  
      const orderId = Number(orderResult.insertId);
  
      if (!orderId) {
        console.error('Order creation failed: insertId is invalid.');
        return res.status(500).json({ error: 'Fehler beim Erstellen der Bestellung.' });
      }
  
      // Insert into order_item table
      for (const item of cart) {
        await conn.query(
          'INSERT INTO order_item (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)',
          [orderId, item.product_id, item.quantity, item.price]
        );
      }
  
      // Commit transaction
      await conn.query('COMMIT');
      res.status(201).json({ message: 'Bestellung erfolgreich aufgegeben!', orderId });
    } catch (err) {
      // Rollback transaction on error
      await conn.query('ROLLBACK');
      console.error('Error during order creation:', err);
      res.status(500).json({ error: 'Fehler beim Aufgeben der Bestellung.' });
    } finally {
      conn.release();
    }
  });


/**
 * GET /orders
 * Retrieves the orders for the logged-in user.
 *
 * This route requires authentication (handled by `authMiddleware`). It fetches the user's orders 
 * from the `order` and `order_item` tables and returns them grouped by order_id.
 *
 * @route GET /orders
 * @group Orders - Operations related to user orders
 * @security BearerAuth
 * @returns {Array} 200 - An array of orders with each order containing items (product details, quantity, and price).
 * @returns {Object} 404 - Error message if no orders are found for the logged-in user.
 * @returns {Object} 500 - Error message if there is an error during the database query.
 */
router.get('/', authMiddleware, async (req, res) => {
    const userId = req.user.id;

    const conn = await getDatabaseConnection();
    try {
        const rows = await conn.query(
            'SELECT o.order_id, o.order_date, o.total_amount, oi.product_id, oi.quantity, oi.price, p.title, p.description, p.image_url ' +
            'FROM `order` o ' +
            'JOIN order_item oi ON o.order_id = oi.order_id ' +
            'JOIN product p ON oi.product_id = p.product_id ' +
            'WHERE o.user_id = ? ' +
            'ORDER BY o.order_date DESC',
            [userId]
        );

        // Ensure orders is an array
        const ordersArray = Array.isArray(rows) ? rows : [rows];

        if (!ordersArray || ordersArray.length === 0 || !ordersArray[0].order_id) {
            return res.status(404).json({ error: 'Keine Bestellungen gefunden.' });
        }

        // Group the orders by order_id and merge items for each order
        const groupedOrders = ordersArray.reduce((acc, item) => {
            const { order_id, order_date, total_amount, product_id, quantity, price, title, description, image_url } = item;
            
            // Initialize the order if it does not exist
            if (!acc[order_id]) {
                acc[order_id] = {
                    order_id,
                    order_date,
                    total_amount,
                    items: [],
                };
            }
            
            // Push the item to the order's items list
            acc[order_id].items.push({ product_id, quantity, price, title, description,  image_url });

            return acc;
        }, {});

       
        res.status(200).json(Object.values(groupedOrders));
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Fehler beim Abrufen der Bestellungen.' });
    } finally {
        conn.release();
    }
});

export default router;
