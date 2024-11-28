import getDatabaseConnection from '../db.js';
import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { isValidEmail } from '../utils/validation.js';

const router = express.Router();

/**
 * POST /login
 * Handles user login by validating the email, comparing the password with the stored hash,
 * and generating a JWT token upon successful authentication.
 * @name login_backend
 * @param {string} req.body.email - The user's email address
 * @param {string} req.body.password - The user's password
 * @returns {Object} 200 - Success, with a JWT token and user information
 * @returns {Object} 400 - Invalid email or password, or user not found
 * @returns {Object} 500 - Internal server error during database interaction
 */
router.post('/', async (req, res) => {
    
    const { email, password } = req.body;

    if (!isValidEmail(email)) {
        return res.status(400).json({ error: 'Ungültige E-Mail-Adresse. Bitte verwenden Sie eine gültige Adresse mit der Domain @hardware-gmbh.de.' });
    }

    const conn = await getDatabaseConnection();
    
    let user;
    
    try {
        [user] = await conn.query('SELECT * FROM user WHERE email = ?', [email]);
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Fehler bei der Anmeldung', error: error });
    } finally {
        conn.release();
    }
    if (!user) return res.status(400).json({ error: 'Benutzer mit dieser Email nicht gefunden' });

    const passwordMatch = await bcrypt.compare(password, user.password_hash);
    if (!passwordMatch) return res.status(400).json({ error: 'Falsches Passwort' });

    const token = jwt.sign({ id: user.user_id, email: user.email , isAdmin: user.isadmin},  process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({ token, userId: user.user_id, userEmail: user.email, isAdmin: user.isadmin });

});

export default router;