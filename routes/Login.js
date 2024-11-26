import getDatabaseConnection from '../db.js';
import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { isValidEmail } from '../middleware/validation.js';

const router = express.Router();

router.post('/', async (req, res) => {
    
    const { email, password } = req.body;

    // if (!isValidEmail(email)) {
    //     return res.status(400).json({ error: 'Ungültige E-Mail-Adresse. Bitte verwenden Sie eine gültige Adresse mit der Domain @hardware-gmbh.de.' });
    // }

    const conn = await getDatabaseConnection();
    
    let user;
    
    try {
        [user] = await conn.query('SELECT * FROM user WHERE email = ?', [email]);
    } catch (error) {
        console.log(error);
    } finally {
        conn.release();
    }
    if (!user) return res.status(400).json({ error: 'Benutzer mit dieser Email nicht gefunden' });

    const passwordMatch = await bcrypt.compare(password, user.password_hash);
    if (!passwordMatch) return res.status(400).json({ error: 'Falsches Passwort' });

    const token = jwt.sign({ id: user.user_id, email: user.email }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ token, userId: user.user_id, userEmail: user.email });

});

export default router;