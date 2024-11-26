import express from 'express';
import cors from 'cors';

import orderRoutes from './routes/Orders.js';
import productRoutes from './routes/Products.js';
import registerRoutes from './routes/Register.js';
import loginRoutes from './routes/Login.js';

export const app = express();

app.use(express.urlencoded({ extended: true}));

app.use(express.json());

app.use(cors({
    origin: process.env.HOST1,
    credentials: true
}));

app.use(express.static('public'));

app.use('/register', registerRoutes);

app.use('/login', loginRoutes);

app.use('/orders', orderRoutes);

app.use('/products', productRoutes);



