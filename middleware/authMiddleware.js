import jwt from 'jsonwebtoken';

/**
 * Middleware to check if the user is authenticated by verifying the JWT token.
 * The token should be passed in the Authorization header as 'Bearer <token>'.
 *
 * @param {Object} req - The request object.
 * @param {Object} res - The response object.
 * @param {Function} next - The next middleware function to call if the token is valid.
 * @returns {void} - Calls the next middleware if the token is valid, or returns a response with an error if invalid or missing.
 */
export const authMiddleware = async (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'Nicht autorisiert' });

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        next();
    } catch (error) {
        console.log(error);
        res.status(403).json({ error: 'Token ungültig' });
    }
};