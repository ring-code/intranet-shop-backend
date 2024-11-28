import request from 'supertest';
import express from 'express';
import { authMiddleware } from '../middleware/authMiddleware';
import upload from '../middleware/uploadMiddleware';
import getDatabaseConnection from '../db'; 
import bodyParser from 'body-parser';

// Mocks
jest.mock('../db'); // Mock database connection
jest.mock('../middleware/authMiddleware', () => ({
  authMiddleware: jest.fn((req, res, next) => {
    req.user = { isAdmin: true }; // Simulate an admin user by default
    next();
  }),
}));
jest.mock('../middleware/uploadMiddleware', () => ({
  single: () => (req, res, next) => {
    req.file = { filename: 'test.jpg', originalname: 'test.png' }; 
    next();
  },
}));

// Create the Express app for testing
const app = express();

// Middleware and routes
app.use(bodyParser.json());
app.put('/update/:id', authMiddleware, upload.single('image'), async (req, res) => {
  const { id } = req.params;
  const { title, price, description, image_url } = req.body;

  if (!title || !price || !description) {
    return res.status(400).json({ error: 'Alle Felder sind erforderlich.' });
  }

  try {
    const db = await getDatabaseConnection();
    const query = 'UPDATE product SET title = ?, price = ?, description = ?, image_url = ? WHERE product_id = ?';
    const result = await db.query(query, [title, price, description, image_url || req.file.filename, id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Produkt nicht gefunden' });
    }

    res.status(200).json({ message: 'Produkt erfolgreich aktualisiert' });
  } catch (error) {
    res.status(500).json({ error: 'Fehler beim Aktualisieren des Produkts' });
  }
});

// Test suite for the PUT /update/:id route
describe('PUT /update/:id', () => {
  afterEach(() => {
    jest.clearAllMocks(); // Reset mocks after each test
  });

  it('should update product details successfully', async () => {
    const mockQuery = jest.fn().mockResolvedValue({ affectedRows: 1 });
    getDatabaseConnection.mockResolvedValue({ query: mockQuery, release: jest.fn() });

    const response = await request(app)
      .put('/update/1')
      .set('Authorization', 'Bearer token') // Simulate auth token
      .send({ title: 'New Product', price: 99.99, description: 'Updated description', image_url: 'images/old.jpg' });

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ message: 'Produkt erfolgreich aktualisiert' });
    expect(mockQuery).toHaveBeenCalledWith(
      'UPDATE product SET title = ?, price = ?, description = ?, image_url = ? WHERE product_id = ?',
      ['New Product', 99.99, 'Updated description', 'images/old.jpg', '1']
    );
  });

  it('should return 400 if required fields are missing', async () => {
    const response = await request(app)
      .put('/update/1')
      .send({ title: '', price: null, description: '' });

    expect(response.status).toBe(400);
    expect(response.body).toEqual({ error: 'Alle Felder sind erforderlich.' });
  });

  it('should return 404 if the product does not exist', async () => {
    const mockQuery = jest.fn().mockResolvedValue({ affectedRows: 0 });
    getDatabaseConnection.mockResolvedValue({ query: mockQuery, release: jest.fn() });

    const response = await request(app)
      .put('/update/999') // Simulate a non-existing product
      .send({ title: 'Non-existent Product', price: 99.99, description: 'No product here' });

    expect(response.status).toBe(404);
    expect(response.body).toEqual({ error: 'Produkt nicht gefunden' });
  });

  it('should return 500 on database error', async () => {
    const mockQuery = jest.fn().mockRejectedValue(new Error('Database error'));
    getDatabaseConnection.mockResolvedValue({ query: mockQuery, release: jest.fn() });

    const response = await request(app)
      .put('/update/1')
      .send({ title: 'New Product', price: 99.99, description: 'Updated description' });

    expect(response.status).toBe(500);
    expect(response.body).toEqual({ error: 'Fehler beim Aktualisieren des Produkts' });
  });
});
