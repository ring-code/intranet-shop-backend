import express from 'express';
import getDatabaseConnection from '../db.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// Place a new order
router.post('/', authMiddleware, async (req, res) => {
    const { cart, totalAmount } = req.body;
    const userId = req.user.id;

    if (!cart || cart.length === 0) {
        return res.status(400).json({ error: 'Der Warenkorb ist leer.' });
    }

    const conn = await getDatabaseConnection();
    try {
        // Start transaction
        await conn.query('START TRANSACTION');

        // Insert into order table
        const orderResult = await conn.query(
            'INSERT INTO `order` (user_id, total_amount) VALUES (?, ?)',
            [userId, totalAmount]
        );

        // Convert BigInt insertId to number
        const orderId = Number(orderResult.insertId);

        if (!orderId) {
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
        console.error(err);
        res.status(500).json({ error: 'Fehler beim Aufgeben der Bestellung.' });
    } finally {
        conn.release();
    }
});


// Get orders for the logged-in user
router.get('/', authMiddleware, async (req, res) => {
    const userId = req.user.id;

    console.log('Fetching orders for user ID:', userId);
    console.log('User ID:', userId, 'Type:', typeof userId);

    const conn = await getDatabaseConnection();
    try {
        const rows = await conn.query(
            'SELECT o.order_id, o.order_date, o.total_amount, oi.product_id, oi.quantity, oi.price, p.title, p.image_url ' +
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
            const { order_id, order_date, total_amount, product_id, quantity, price, title, image_url } = item;
            
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
            acc[order_id].items.push({ product_id, quantity, price, title, image_url });

            return acc;
        }, {});

        // Convert the grouped orders into an array of values
        console.log('Grouped Orders:', Object.values(groupedOrders));
        res.status(200).json(Object.values(groupedOrders));
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Fehler beim Abrufen der Bestellungen.' });
    } finally {
        conn.release();
    }
});

export default router;
