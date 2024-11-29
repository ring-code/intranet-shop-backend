/**
 * @module authMiddleware
 * 
 */
import jwt from 'jsonwebtoken';


/**
 * Middleware to check if the user is authenticated by verifying the JWT token.
 * The token should be passed in the Authorization header as 'Bearer <token>'.
 * 
 * @param {Object} req - The Express request object.
 * @param {Object} res - The Express response object.
 * @param {Function} next - The next middleware function to call.
 *
 * @throws {Error} - Throws an error if the token is invalid or missing.
 */
const authMiddleware = async (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'Nicht autorisiert' });

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;

        // admin check
        if (req.user && req.user.isAdmin) {
            req.isAdmin = true; 
        } else {
            req.isAdmin = false; 
        }
        
        next();
    } catch (error) {
        console.log(error);
        res.status(403).json({ error: 'Token ungültig' });
    }
};

export { authMiddleware };