/**
 * @module Registration
 * 
 */




import getDatabaseConnection from '../db.js';
import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { isValidEmail, isValidPassword } from '../utils/validation.js';

const router = express.Router();

/**
 * POST /register
 * Handles user registration by validating input, hashing the password, 
 * inserting the new user into the database, and generating a JWT token.
 * @function Register
 * @route {POST} /register
 * @group Register - Operations related to user registration
 * @param {string} email.body.required - The user's email address
 * @param {string} password.body.required - The user's password
 * @returns {Object} 201 - Registration successful with the JWT token
 * @returns {Object} 400 - Invalid email or password or duplicate email
 * @returns {Object} 500 - Internal server error when something goes wrong
 */
router.post('/', async (req, res) => {
    const { email, password } = req.body;

    // Validate email
    if (!isValidEmail(email)) {
        return res.status(400).json({ error: 'Ungültige E-Mail-Adresse. Bitte verwenden Sie eine gültige Adresse mit der Domain @hardware-gmbh.de.' });
    }

    // Validate password
    if (!isValidPassword(password)) {
        return res.status(400).json({ error: 'Das Passwort muss mindestens 8 Zeichen lang sein und einen Großbuchstaben, eine Zahl und ein Sonderzeichen enthalten.' });
    }

    try {
        const connection = await getDatabaseConnection();
      
        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10); 

        // Insert the user into the database
        await connection.query('INSERT INTO user (email, password_hash) VALUES (?, ?)', [email, hashedPassword]);

        // Generate JWT token
        const token = jwt.sign({ email }, process.env.JWT_SECRET, { expiresIn: '1h' });

        // Respond with success
        res.status(201).json({ message: 'Registrierung erfolgreich!', token });

        connection.release(); 
    
    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ error: 'Diese E-Mail-Adresse ist bereits registriert!' });
        }

        console.error('Fehler bei der Registrierung:', error);
        res.status(500).json({ error: 'Fehler bei der Registrierung. Versuchen Sie es erneut.' });
         
    } 
});

export default router;