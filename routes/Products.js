import getDatabaseConnection from '../db.js';
import express from 'express';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

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