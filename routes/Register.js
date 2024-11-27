import getDatabaseConnection from '../db.js';
import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { isValidEmail, isValidPassword } from '../utils/validation.js';

const router = express.Router();

router.post('/', async (req, res) => {
    const { email, password } = req.body;

    // Validate email
    // if (!isValidEmail(email)) {
    //     return res.status(400).json({ error: 'Ungültige E-Mail-Adresse. Bitte verwenden Sie eine gültige Adresse mit der Domain @hardware-gmbh.de.' });
    // }

    // Validate password
    // if (!isValidPassword(password)) {
    //     return res.status(400).json({ error: 'Das Passwort muss mindestens 8 Zeichen lang sein und einen Großbuchstaben, eine Zahl und ein Sonderzeichen enthalten.' });
    // }

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