import getDatabaseConnection from '../db.js';
import express from 'express';
import multer from 'multer';
import path from 'path';
import sharp from 'sharp';
import fs from 'fs';
import { authMiddleware } from '../middleware/authMiddleware.js';
import upload from '../middleware/uploadMiddleware.js';

const router = express.Router();

// PUT route for editing a product
router.put('/update/:id', authMiddleware, upload.single('image'), async (req, res) => {
  
  // Admin check
  if (!req.user.isAdmin) {
    return res.status(403).json({ error: 'Zugriff verweigert. Nur Administratoren dürfen Produkte bearbeiten.' });
  }

  const { id } = req.params; // Extract product_id from URL parameters
  const { title, price, description, image_url } = req.body; // Extract product data from request body

  // Check if all required fields are provided
  if (!title || !price || !description) {
    return res.status(400).json({ error: 'Alle Felder sind erforderlich.' });
  }

  const conn = await getDatabaseConnection();

  try {
    let updatedImageUrl = image_url; // Keep the existing image_url by default

    if (req.file) {
      // If a new image is uploaded, handle it
      const originalFilePath = path.join('public/images/', req.file.filename);
      const ext = path.extname(req.file.originalname).toLowerCase(); // Get file extension
      const tempFilePath = path.join('public/images/', `temp-${req.file.filename}`); // Temporary file path for conversion

      if (ext !== '.jpg') {
        // Only convert if the file is not a .jpg
        try {
          // Use Sharp to convert the uploaded image to .jpg format (even if it’s a different format)
          await sharp(originalFilePath)
            .jpeg({ quality: 80 }) // Convert to JPG format with 80% quality
            .toFile(tempFilePath); // Save the processed image to a temporary path

          const finalFilePath = path.join('public/images/', `product-image-${id}.jpg`); // Define the final image path
          fs.renameSync(tempFilePath, finalFilePath); // Move the temp file to the final path

          // Optionally delete the original file (e.g., .png)
          fs.unlinkSync(originalFilePath); // This deletes the original uploaded file (e.g., .png)

          updatedImageUrl = `images/product-image-${id}.jpg`; // Set the updated image URL to the converted image
        } catch (error) {
          // If image conversion fails, delete the uploaded file and return an error
          fs.unlinkSync(originalFilePath); // Delete the uploaded file
          console.error('Error converting image:', error);
          return res.status(500).json({ error: 'Fehler beim Verarbeiten des Bildes.' });
        }
      } else {
        // If it's already a .jpg, we just move it to the final location without conversion
        const finalFilePath = path.join('public/images/', `product-image-${id}.jpg`);
        fs.renameSync(originalFilePath, finalFilePath); // Move the file to the final path
        updatedImageUrl = `images/product-image-${id}.jpg`; // Set the updated image URL to the .jpg
      }
    }

    // Query to update the product based on the product_id
    const result = await conn.query(
      'UPDATE product SET title = ?, price = ?, description = ?, image_url = ? WHERE product_id = ?',
      [title, price, description, updatedImageUrl, id]
    );

    // If no rows were affected, the product was not found
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Produkt nicht gefunden' });
    }

    // If the update was successful, send a success response
    res.status(200).json({ message: 'Produkt erfolgreich aktualisiert' });
  } catch (error) {
    console.error('Error updating product:', error);
    res.status(500).json({ error: 'Fehler beim Aktualisieren des Produkts' });
  } finally {
    conn.release(); // Release the database connection back to the pool
  }
});

// DELETE route for removing a product
router.delete('/delete/:id', authMiddleware, async (req, res) => {
  
  // Admin Check
  if (!req.user.isAdmin) {
    return res.status(403).json({ error: 'Zugriff verweigert. Nur Administratoren dürfen Produkte löschen.' });
  }

  const { id } = req.params; // Extract product_id from URL parameters
  const { image_url } = req.body; // The product image URL is passed from the frontend

  try {
    // If the product has an image, delete the image file
    if (image_url) {
      const imageFilePath = path.join('public', image_url); // Resolve the full file path
      if (fs.existsSync(imageFilePath)) {
        fs.unlinkSync(imageFilePath); // Delete the image file
        console.log(`Image deleted: ${imageFilePath}`);
      }
    }

    const conn = await getDatabaseConnection();

    // Delete the product from the database
    const result = await conn.query('DELETE FROM product WHERE product_id = ?', [id]);

    // If no rows were affected, the product was not found
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Produkt nicht gefunden' });
    }

    // If the deletion was successful, send a success response
    res.status(200).json({ message: 'Produkt erfolgreich gelöscht' });
  } catch (error) {
    console.error('Error deleting product:', error);
    res.status(500).json({ error: 'Fehler beim Löschen des Produkts' });
  }
});


// INSERT ROUTE
router.post('/insert', authMiddleware, upload.single('image'), async (req, res) => {
  const { title, price, description } = req.body;

  const conn = await getDatabaseConnection();

  try {
    let updatedImageUrl = null; // Default to null if no image uploaded

    if (req.file) {
      const originalFilePath = path.join('public/images/', req.file.filename);
      const ext = path.extname(req.file.originalname).toLowerCase();
      const tempFilePath = path.join('public/images/', `temp-${req.file.filename}`);

      // Generate final image name after the product is added and id is auto-generated
      const finalImageName = `product-image-temp.jpg`; // Temp image name
      const finalFilePath = path.join('public/images/', finalImageName);

      if (ext !== '.jpg') {
        try {
          // Convert the image to .jpg format (if it's not already a .jpg)
          await sharp(originalFilePath)
            .jpeg({ quality: 80 })
            .toFile(tempFilePath); // Write the temp converted image

          // Rename and delete original file after conversion
          fs.renameSync(tempFilePath, finalFilePath);
          fs.unlinkSync(originalFilePath); // Remove original file if not .jpg

          updatedImageUrl = `images/${finalImageName}`; // URL to be saved in DB
        } catch (error) {
          // If there is any error during image conversion, remove the uploaded file
          fs.unlinkSync(originalFilePath);
          console.error('Error converting image:', error);
          return res.status(500).json({ error: 'Fehler beim Verarbeiten des Bildes.' });
        }
      } else {
        // If the file is already a .jpg, just rename it
        fs.renameSync(originalFilePath, finalFilePath);
        updatedImageUrl = `images/${finalImageName}`; // URL to be saved in DB
      }
    }

    // Insert the new product into the database (id is auto-generated by the DB)
    const result = await conn.query(
      'INSERT INTO product (title, price, description, image_url) VALUES (?, ?, ?, ?)',
      [title, price, description, updatedImageUrl]
    );

    // The database generates the new product id (auto-increment)
    const newProductId = result.insertId;

    // Convert the BigInt to a string before sending it in the response
    const responseBody = {
      message: 'Produkt erfolgreich hinzugefügt',
      productId: newProductId.toString()  // Ensure the productId is a string
    };

    // Send a response with the newly created product id and success message
    res.status(201).json(responseBody);
  } catch (error) {
    console.error('Error adding product:', error);
    res.status(500).json({ error: 'Fehler beim Hinzufügen des Produkts' });
  } finally {
    conn.release(); // Release the database connection back to the pool
  }
});






export default router;
