/**
 * @module Products
 * 
 */


import getDatabaseConnection from '../db.js';
import express from 'express';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

/**
 * 
 * Fetches a list of all products from the database. Requires authentication via the `authMiddleware`.
 * @function getOrders
 * @route {GET} /products
 *  
 * 
 * @security BearerAuth
 * @returns {Array} 200 - An array of product objects
 * @returns {Object} 500 - Database error with error details
 */
router.get('/', authMiddleware,  async (req, res) => {
       
    const conn = await getDatabaseConnection();
    try {
        const rows = await conn.query("SELECT * FROM product"); 
        res.status(200).json(rows);
    } catch (err) {
        res.status(500).json({ message: 'Datenbankfehler', error: err });
    } finally {
        conn.release(); 
    }
});

export default router;