import request from 'supertest';
import express from 'express';
import { authMiddleware } from '../middleware/authMiddleware.js';
import getDatabaseConnection from '../db.js';
import orderRouter from '../routes/Orders.js'; 

// Mocking dependencies
jest.mock('../db.js');
jest.mock('../middleware/authMiddleware.js');

// Setup Express app with the /orders route
const app = express();
app.use(express.json());
app.use('/orders', orderRouter);

// Mock the authMiddleware to bypass authentication
beforeEach(() => {
  authMiddleware.mockImplementation((req, res, next) => {
    req.user = { id: 1 }; 
    next();
  });
});


describe('GET /orders', () => {
  it('should return a 200 and a list of orders', async () => {
    // Mock the returned orders data
    const mockOrders = [
      { order_id: 1, order_date: '2024-11-27', total_amount: 250, product_id: 1, quantity: 2, price: 100, title: 'Product A', description: 'Description A', image_url: 'image-url-1' },
      { order_id: 1, order_date: '2024-11-27', total_amount: 250, product_id: 2, quantity: 1, price: 50, title: 'Product B', description: 'Description B', image_url: 'image-url-2' }
    ];

    const mockConnection = {
      query: jest.fn().mockResolvedValue(mockOrders),
      release: jest.fn(),
    };

    getDatabaseConnection.mockResolvedValue(mockConnection);

    const response = await request(app)
      .get('/orders')
      .set('Authorization', 'Bearer fake-token');  

    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
    expect(response.body[0].order_id).toBe(1); 
    expect(mockConnection.query).toHaveBeenCalledWith(
      'SELECT o.order_id, o.order_date, o.total_amount, oi.product_id, oi.quantity, oi.price, p.title, p.description, p.image_url ' +
      'FROM `order` o ' +
      'JOIN order_item oi ON o.order_id = oi.order_id ' +
      'JOIN product p ON oi.product_id = p.product_id ' +
      'WHERE o.user_id = ? ' +
      'ORDER BY o.order_date DESC',
      [1] 
    );
    expect(mockConnection.release).toHaveBeenCalled();
  });

  it('should return a 404 if no orders are found', async () => {
    const mockConnection = {
      query: jest.fn().mockResolvedValue([]),
      release: jest.fn(),
    };

    getDatabaseConnection.mockResolvedValue(mockConnection);

    const response = await request(app)
      .get('/orders')
      .set('Authorization', 'Bearer fake-token');

    expect(response.status).toBe(404);
    expect(response.body).toEqual({ error: 'Keine Bestellungen gefunden.' });
    expect(mockConnection.release).toHaveBeenCalled();
  });

  it('should return a 500 if there is a database error while fetching orders', async () => {
    const mockConnection = {
      query: jest.fn().mockRejectedValue(new Error('Database error')),
      release: jest.fn(),
    };

    getDatabaseConnection.mockResolvedValue(mockConnection);

    const response = await request(app)
      .get('/orders')
      .set('Authorization', 'Bearer fake-token');

    expect(response.status).toBe(500);
    expect(response.body).toEqual({ error: 'Fehler beim Abrufen der Bestellungen.' });
    expect(mockConnection.release).toHaveBeenCalled();
  });
});
