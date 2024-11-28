import getDatabaseConnection from '../db.js';
import express from 'express';
import path from 'path';
import sharp from 'sharp';
import fs from 'fs';
import { authMiddleware } from '../middleware/authMiddleware.js';
import upload from '../middleware/uploadMiddleware.js';

const router = express.Router();

/**
 * PUT /products/update/:id
 * Edit a product's details.
 *
 * This route allows administrators to update a product's title, price, description, and image.
 * If an image is uploaded, it will be converted to a .jpg format (if necessary) and saved.
 * 
 * @route PUT /products/update/:id
 * @group Products - Operations related to products
 * @security BearerAuth
 * @param {string} id.path.required - The ID of the product to update.
 * @param {string} title.body.required - The title of the product.
 * @param {string} price.body.required - The price of the product.
 * @param {string} description.body.required - The description of the product.
 * @param {string} image_url.body.optional - The image URL (optional, if image is not uploaded).
 * @returns {Object} 200 - Success message indicating the product was successfully updated.
 * @returns {Object} 400 - Error message if required fields are missing.
 * @returns {Object} 403 - Error message if the user is not an admin.
 * @returns {Object} 404 - Error message if the product was not found.
 * @returns {Object} 500 - Error message if there is an issue processing the request.
 */
router.put('/update/:id', authMiddleware, upload.single('image'), async (req, res) => {
  
  // Admin check
  if (!req.user.isAdmin) {
    return res.status(403).json({ error: 'Zugriff verweigert. Nur Administratoren dürfen Produkte bearbeiten.' });
  }

  const { id } = req.params; 
  const { title, price, description, image_url } = req.body; 

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
    conn.release(); 
  }
});

/**
 * DELETE /products/delete/:id
 * Delete a product.
 *
 * This route allows administrators to delete a product by its ID.
 * If the product has an associated image, the image file is also deleted from the server.
 * 
 * @route DELETE /products/delete/:id
 * @group Products - Operations related to products
 * @security BearerAuth
 * @param {string} id.path.required - The ID of the product to delete.
 * @param {string} image_url.body.optional - The image URL to delete the associated image.
 * @returns {Object} 200 - Success message indicating the product was successfully deleted.
 * @returns {Object} 403 - Error message if the user is not an admin.
 * @returns {Object} 404 - Error message if the product was not found.
 * @returns {Object} 500 - Error message if there is an issue processing the request.
 */
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

/**
 * POST /products/insert
 * Add a new product.
 *
 * This route allows administrators to add a new product with a title, price, description, and an optional image.
 * The image is converted to .jpg format if necessary and its URL is stored in the database.
 * 
 * @route POST /products/insert
 * @group Products - Operations related to products
 * @security BearerAuth
 * @param {string} title.body.required - The title of the product.
 * @param {string} price.body.required - The price of the product.
 * @param {string} description.body.required - The description of the product.
 * @param {file} image.body.optional - The image file to upload for the product (optional).
 * @returns {Object} 201 - Success message with the newly created product ID.
 * @returns {Object} 403 - Error message if the user is not an admin.
 * @returns {Object} 500 - Error message if there is an issue processing the request.
 */
router.post('/insert', authMiddleware, upload.single('image'), async (req, res) => {

  // Admin Check
  if (!req.user.isAdmin) {
    return res.status(403).json({ error: 'Zugriff verweigert. Nur Administratoren dürfen Produkte löschen.' });
  }
  
  const { title, price, description } = req.body;

  const conn = await getDatabaseConnection();

  try {
    let updatedImageUrl = null; // Default to null if no image uploaded

    // Insert the new product into the database (id is auto-generated by the DB)
    const result = await conn.query(
      'INSERT INTO product (title, price, description, image_url) VALUES (?, ?, ?, ?)',
      [title, price, description, updatedImageUrl]  // Initially set image_url to null
    );

    // The database generates the new product id (auto-increment)
    const newProductId = result.insertId; 

    // If there's an uploaded file, process it
    if (req.file) {
      const originalFilePath = path.join('public/images/', req.file.filename);
      const ext = path.extname(req.file.originalname).toLowerCase();
      const tempFilePath = path.join('public/images/', `temp-${req.file.filename}`);

      // Generate the final image name using the newly generated product ID
      const finalImageName = `product-image-${newProductId}${ext}`;  // Dynamic image name using the product ID
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

      // After renaming the image, update the database with the correct image URL
      await conn.query(
        'UPDATE product SET image_url = ? WHERE product_id = ?',
        [updatedImageUrl, newProductId]
      );
    }

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
    conn.release(); 
  }
});

export default router;
