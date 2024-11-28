import request from 'supertest';
import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import getDatabaseConnection from '../db.js';
import registerRouter from '../routes/Register.js';

// Mock dependencies
jest.mock('../db.js');
jest.mock('bcrypt');
jest.mock('jsonwebtoken');

// Setup Express app and route
const app = express();
app.use(express.json());
app.use('/register', registerRouter);



describe('POST /register', () => {
    let mockConnection;

    beforeEach(() => {
        mockConnection = {
            query: jest.fn(),
            release: jest.fn(),
        };
        getDatabaseConnection.mockResolvedValue(mockConnection);
        jest.clearAllMocks();
    });

    it('should register a new user successfully', async () => {
        // Mock bcrypt hash and JWT sign
        bcrypt.hash.mockResolvedValue('hashed_password');
        jwt.sign.mockReturnValue('mock_token');

        // Simulate a successful database insert
        mockConnection.query.mockResolvedValue({});

        // Simulate a valid registration request
        const response = await request(app)
            .post('/register')
            .send({ email: 'test@hardware-gmbh.de', password: 'Valid@1234' });

        // Assertions
        expect(response.status).toBe(201);
        expect(response.body).toEqual({
            message: 'Registrierung erfolgreich!',
            token: 'mock_token',
        });
        expect(bcrypt.hash).toHaveBeenCalledWith('Valid@1234', 10);
        expect(jwt.sign).toHaveBeenCalledWith(
            { email: 'test@hardware-gmbh.de' },
            process.env.JWT_SECRET,
            { expiresIn: '1h' }
        );
        expect(mockConnection.query).toHaveBeenCalledWith(
            'INSERT INTO user (email, password_hash) VALUES (?, ?)',
            ['test@hardware-gmbh.de', 'hashed_password']
        );
        expect(mockConnection.release).toHaveBeenCalled();
    });

    it('should return 400 for invalid email', async () => {
        const response = await request(app)
            .post('/register')
            .send({ email: 'invalid-email', password: 'Valid@1234' });

        expect(response.status).toBe(400);
        expect(response.body).toEqual({
            error: 'Ungültige E-Mail-Adresse. Bitte verwenden Sie eine gültige Adresse mit der Domain @hardware-gmbh.de.',
        });
    });

    it('should return 400 for invalid password', async () => {
        const response = await request(app)
            .post('/register')
            .send({ email: 'test@hardware-gmbh.de', password: 'short' });

        expect(response.status).toBe(400);
        expect(response.body).toEqual({
            error: 'Das Passwort muss mindestens 8 Zeichen lang sein und einen Großbuchstaben, eine Zahl und ein Sonderzeichen enthalten.',
        });
    });

    it('should return 400 for duplicate email', async () => {
        // Simulate a duplicate email error
        mockConnection.query.mockRejectedValue({ code: 'ER_DUP_ENTRY' });

        const response = await request(app)
            .post('/register')
            .send({ email: 'test@hardware-gmbh.de', password: 'Valid@1234' });

        expect(response.status).toBe(400);
        expect(response.body).toEqual({
            error: 'Diese E-Mail-Adresse ist bereits registriert!',
        });
    });

    it('should return 500 for database errors', async () => {
        // Mock the database connection to throw an error
        mockConnection.query.mockRejectedValue(new Error('Database error'));
    
        const response = await request(app)
            .post('/register')
            .send({ email: 'test@hardware-gmbh.de', password: 'Valid@1234' });
    
        // Assertions
        expect(response.status).toBe(500);
        expect(response.body).toEqual({
            error: 'Fehler bei der Registrierung. Versuchen Sie es erneut.',
        });
    
        
    });
});
