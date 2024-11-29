/**
 * @module uploadMiddleware
 * 
 */


import multer from 'multer';
import path from 'path';
import fs from 'fs';

/**
 * Set up the storage configuration for multer to handle file uploads.
 * It defines where the uploaded files will be stored and how their names will be generated.
 * 
 * @type {multer.StorageEngine}
 */
const storage = multer.diskStorage({
  
  /**
   * Determines the destination directory for uploaded files.
   * If the directory doesn't exist, it will be created.
   * @function findDestination
   * @param {Object} req - The request object.
   * @param {Object} file - The file being uploaded.
   * @param {Function} cb - Callback function to indicate the directory choice.
   */
  destination: (req, file, cb) => {
    const dir = path.resolve('public', 'images');
    console.log(`Checking directory: ${dir}`);

    // Check if the directory exists, if not, create it
    if (!fs.existsSync(dir)) {
      console.log(`Directory does not exist, creating it: ${dir}`);
      fs.mkdirSync(dir, { recursive: true });
    }

    cb(null, dir);
  },

  /**
   * Defines how the file name will be set once uploaded.
   * The filename will include the product ID and the file extension based on the original file.
   * @function nameFile
   * @param {Object} req - The request object.
   * @param {Object} file - The file being uploaded.
   * @param {Function} cb - Callback function to specify the file name.
   */
  filename: (req, file, cb) => {
    const productId = req.params.id;  // Assuming product ID is in the URL params
    const ext = path.extname(file.originalname);  // Get file extension
    console.log(`Saving file as: product-image-${productId}${ext}`);
    cb(null, `product-image-${productId}${ext}`);
  }
});

/**
 * Set up the multer upload middleware, including storage configuration and file size limits.
 * @function upload
 * @type {multer.Instance}
 */
const upload = multer({ 
  storage: storage,  // Define where and how files should be stored
  limits: { 
    fileSize: 10 * 1024 * 1024 // Set the file size limit to 10 MB
  }
});

export default upload;
