/**
 * Validates an email for registration
 * - Domain needs to be @hardware-gmbh
 * - Allows dots, numbers, underscores and non-consecutive hyphens before the @ 
 *
 * @param {string} email - The email address to validate.
 * @returns {boolean} - Returns `true` if the email is valid, `false` otherwise.
 */
export function isValidEmail(email) {
    
    const emailPattern = /^[a-zA-Z0-9._]+(?:-[a-zA-Z0-9._]+)*@hardware-gmbh\.de$/;
  
    return emailPattern.test(email);
}


/**
 * Validates a password for registration:
 * - Minimum 8 characters long.
 * - At least one uppercase letter, number and special character (!@$%?)
 * 
 * @param {string} password - The password to validate.
 * @returns {boolean} - Returns true if the password is valid, false otherwise.
 */
export function isValidPassword(password) {
    const passwordPattern = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@$%?])[A-Za-z\d!@$%?]{8,}$/;
  
    return passwordPattern.test(password);
  }








