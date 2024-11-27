import request from 'supertest';
import express from 'express';
import { authMiddleware } from '../middleware/authMiddleware.js';
import getDatabaseConnection from '../db.js';
import productRouter from '../routes/Products.js';  // Adjust the import path as needed

// Mock the dependencies
jest.mock('../db.js'); // Mocking the database connection
jest.mock('../middleware/authMiddleware.js'); // Mocking the authMiddleware

// Setup the Express app and routes
const app = express();
app.use('/products', productRouter);

describe('GET /products', () => {
  // Mocking authMiddleware to bypass actual authentication checks
  beforeEach(() => {
    authMiddleware.mockImplementation((req, res, next) => next());
  });

  it('should return a list of products on success', async () => {
    // Mocking the database query to return product data
    const mockProducts = [
      { id: 1, name: 'Product A', price: 100 },
      { id: 2, name: 'Product B', price: 150 },
    ];
    const mockConnection = {
      query: jest.fn().mockResolvedValue(mockProducts),
      release: jest.fn(),
    };

    getDatabaseConnection.mockResolvedValue(mockConnection);

    const response = await request(app).get('/products');

    expect(response.status).toBe(200);
    expect(response.body).toEqual(mockProducts);
    expect(mockConnection.query).toHaveBeenCalledWith('SELECT * FROM product');
    expect(mockConnection.release).toHaveBeenCalled();
  });

  it('should return a 500 if there is a database error', async () => {
    // Mocking the database query to throw an error
    const mockConnection = {
      query: jest.fn().mockRejectedValue(new Error('Database error')),
      release: jest.fn(),
    };
  
    getDatabaseConnection.mockResolvedValue(mockConnection);
  
    const response = await request(app).get('/products');
  
    expect(response.status).toBe(500);
    // Adjusting to check for the error message in the response body
    expect(response.body).toEqual({ message: 'Datenbankfehler', error: {} });
    expect(mockConnection.query).toHaveBeenCalledWith('SELECT * FROM product');
    expect(mockConnection.release).toHaveBeenCalled();
  });
});
