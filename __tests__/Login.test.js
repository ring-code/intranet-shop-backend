import request from 'supertest';
import express from 'express';
import { authMiddleware } from '../middleware/authMiddleware.js';
import getDatabaseConnection from '../db.js';
import loginRouter from '../routes/Login.js'; 
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';


jest.mock('../db.js'); 
jest.mock('bcrypt'); 
jest.mock('jsonwebtoken'); 
jest.mock('../middleware/authMiddleware.js');


const app = express();
app.use(express.json());
app.use('/login', loginRouter);

describe('POST /login', () => {
  
  beforeEach(() => {
    authMiddleware.mockImplementation((req, res, next) => next());
  });

  it('should return a 200 status with token and user details for valid credentials', async () => {
    
    const mockUser = {
      user_id: 1,
      email: 'user@hardware-gmbh.de',
      password_hash: 'hashedPassword',
      isadmin: false,
    };

    
    bcrypt.compare.mockResolvedValue(true);

    
    jwt.sign.mockReturnValue('fake-jwt-token');

    const mockConnection = {
      query: jest.fn().mockResolvedValue([mockUser]),
      release: jest.fn(),
    };

    getDatabaseConnection.mockResolvedValue(mockConnection);

    const response = await request(app)
      .post('/login')
      .send({ email: 'user@hardware-gmbh.de', password: 'password123' });

    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('token', 'fake-jwt-token');
    expect(response.body).toHaveProperty('userId', mockUser.user_id);
    expect(response.body).toHaveProperty('userEmail', mockUser.email);
    expect(response.body).toHaveProperty('isAdmin', mockUser.isadmin);
    expect(mockConnection.query).toHaveBeenCalledWith('SELECT * FROM user WHERE email = ?', ['user@hardware-gmbh.de']);
    expect(mockConnection.release).toHaveBeenCalled();
  });

  it('should return a 400 status if the email format is invalid', async () => {
    const response = await request(app)
      .post('/login')
      .send({ email: 'invalidemail.com', password: 'password123' });

    expect(response.status).toBe(400);
    expect(response.body).toEqual({ error: 'Ungültige E-Mail-Adresse. Bitte verwenden Sie eine gültige Adresse mit der Domain @hardware-gmbh.de.' });
  });

  it('should return a 400 status if the user is not found', async () => {
    const mockConnection = {
      query: jest.fn().mockResolvedValue([]), 
      release: jest.fn(),
    };

    getDatabaseConnection.mockResolvedValue(mockConnection);

    const response = await request(app)
      .post('/login')
      .send({ email: 'user@hardware-gmbh.de', password: 'password123' });

    expect(response.status).toBe(400);
    expect(response.body).toEqual({ error: 'Benutzer mit dieser Email nicht gefunden' });
    expect(mockConnection.query).toHaveBeenCalledWith('SELECT * FROM user WHERE email = ?', ['user@hardware-gmbh.de']);
    expect(mockConnection.release).toHaveBeenCalled();
  });

  it('should return a 400 status if the password is incorrect', async () => {
    const mockUser = {
      user_id: 1,
      email: 'user@hardware-gmbh.de',
      password_hash: 'hashedPassword',
      isadmin: false,
    };

    bcrypt.compare.mockResolvedValue(false); 

    const mockConnection = {
      query: jest.fn().mockResolvedValue([mockUser]),
      release: jest.fn(),
    };

    getDatabaseConnection.mockResolvedValue(mockConnection);

    const response = await request(app)
      .post('/login')
      .send({ email: 'user@hardware-gmbh.de', password: 'wrongPassword' });

    expect(response.status).toBe(400);
    expect(response.body).toEqual({ error: 'Falsches Passwort' });
    expect(mockConnection.query).toHaveBeenCalledWith('SELECT * FROM user WHERE email = ?', ['user@hardware-gmbh.de']);
    expect(mockConnection.release).toHaveBeenCalled();
  });


});
