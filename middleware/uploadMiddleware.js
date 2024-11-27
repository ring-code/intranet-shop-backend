import multer from 'multer';
import path from 'path';
import fs from 'fs';

// Set up multer storage configuration
const storage = multer.diskStorage({
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

  filename: (req, file, cb) => {
    const productId = req.params.id;  // Assuming product ID is in the URL params
    const ext = path.extname(file.originalname);  // Get file extension
    console.log(`Saving file as: product-image-${productId}${ext}`);
    cb(null, `product-image-${productId}${ext}`);
  }
});

// Set up file upload middleware
const upload = multer({ 
  storage: storage,
  limits: { fileSize: 10 * 1024 * 1024 } // File size limit (10 MB)
});

export default upload;