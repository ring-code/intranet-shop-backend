import express from 'express';
import getDatabaseConnection from './db.js';
import cors from 'cors';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

import orderRoutes from './routes/Orders.js';

import { authMiddleware } from './middleware/authMiddleware.js';


export const app = express();


app.use(express.urlencoded({ extended: true}));
app.use(express.json());

app.use(cors({
    origin: process.env.HOST1,
    credentials: true
}));

app.use(express.static('public'));

app.use('/orders', orderRoutes);







app.post('/register', async (req, res) => {
    const { email, password, pwcheck } = req.body;

    try {
        const connection = await getDatabaseConnection();

       
        const hashedPassword = await bcrypt.hash(password, 10); 

        await connection.query('INSERT INTO user (email, password_hash) VALUES (?, ?)', [email, hashedPassword]);

        const token = jwt.sign({ email }, process.env.JWT_SECRET, { expiresIn: '1h' });

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

app.post('/login', async (req, res) => {
    const { email, password } = req.body;

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

app.get('/products', authMiddleware,  async (req, res) => {
    
    
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







