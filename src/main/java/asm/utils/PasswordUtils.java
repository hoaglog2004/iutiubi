package asm.utils;

import java.security.SecureRandom;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PasswordUtils {

    private static final Logger logger = LoggerFactory.getLogger(PasswordUtils.class);
    
    private static final String CHARS = 
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    private static final SecureRandom RANDOM = new SecureRandom();
    
    // BCrypt work factor (12 rounds provides good security/performance balance)
    private static final int BCRYPT_ROUNDS = 12;
    
    // Password validation constants
    private static final int MIN_PASSWORD_LENGTH = 8;

    /**
     * Tạo một mật khẩu ngẫu nhiên với độ dài cho trước (ví dụ 8-10 ký tự)
     */
    public static String generateRandomPassword(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARS.charAt(RANDOM.nextInt(CHARS.length())));
        }
        return sb.toString();
    }
    
    /**
     * Hash a password using BCrypt
     * @param plainPassword The plain text password
     * @return The hashed password
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        String hashed = BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
        logger.debug("Password hashed successfully");
        return hashed;
    }
    
    /**
     * Verify a password against a BCrypt hash
     * @param plainPassword The plain text password to check
     * @param hashedPassword The hashed password to check against
     * @return true if password matches, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        
        // Check if this is a BCrypt hash (starts with $2a$, $2b$, or $2y$)
        if (isBCryptHash(hashedPassword)) {
            try {
                boolean matches = BCrypt.checkpw(plainPassword, hashedPassword);
                if (!matches) {
                    logger.debug("Password verification failed");
                }
                return matches;
            } catch (IllegalArgumentException e) {
                logger.warn("Invalid BCrypt hash format");
                return false;
            }
        } else {
            // Legacy plain text password comparison (for migration purposes)
            logger.debug("Using legacy plain text password comparison");
            return plainPassword.equals(hashedPassword);
        }
    }
    
    /**
     * Check if a password hash is a BCrypt hash
     * @param hash The hash to check
     * @return true if it's a BCrypt hash
     */
    public static boolean isBCryptHash(String hash) {
        if (hash == null || hash.length() < 4) {
            return false;
        }
        return hash.startsWith("$2a$") || hash.startsWith("$2b$") || hash.startsWith("$2y$");
    }
    
    /**
     * Check if a password needs to be upgraded from plain text to BCrypt
     * @param hashedPassword The stored password
     * @return true if password needs hashing
     */
    public static boolean needsRehash(String hashedPassword) {
        return hashedPassword != null && !isBCryptHash(hashedPassword);
    }
    
    /**
     * Validate password strength
     * @param password The password to validate
     * @return null if valid, error message if invalid
     */
    public static String validatePasswordStrength(String password) {
        if (password == null || password.isEmpty()) {
            return "Mật khẩu không được để trống!";
        }
        
        if (password.length() < MIN_PASSWORD_LENGTH) {
            return "Mật khẩu phải có ít nhất " + MIN_PASSWORD_LENGTH + " ký tự!";
        }
        
        boolean hasUppercase = false;
        boolean hasLowercase = false;
        boolean hasDigit = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUppercase = true;
            else if (Character.isLowerCase(c)) hasLowercase = true;
            else if (Character.isDigit(c)) hasDigit = true;
        }
        
        if (!hasUppercase) {
            return "Mật khẩu phải chứa ít nhất một chữ cái viết hoa!";
        }
        
        if (!hasLowercase) {
            return "Mật khẩu phải chứa ít nhất một chữ cái viết thường!";
        }
        
        if (!hasDigit) {
            return "Mật khẩu phải chứa ít nhất một chữ số!";
        }
        
        return null; // Password is valid
    }
    
    /**
     * Check if password meets minimum requirements (less strict than validatePasswordStrength)
     * @param password The password to check
     * @return true if password meets minimum requirements
     */
    public static boolean meetsMinimumRequirements(String password) {
        return password != null && password.length() >= 6;
    }
}