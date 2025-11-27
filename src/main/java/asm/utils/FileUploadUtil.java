package asm.utils;

import jakarta.servlet.http.Part;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

/**
 * Utility class for handling file uploads with validation.
 * Provides size limits, file type validation, and secure filename generation.
 */
public class FileUploadUtil {
    
    private static final Logger logger = LoggerFactory.getLogger(FileUploadUtil.class);
    
    // Maximum file size: 5MB
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;
    
    // Allowed image MIME types
    private static final Set<String> ALLOWED_IMAGE_TYPES = new HashSet<>(Arrays.asList(
            "image/jpeg",
            "image/jpg",
            "image/png",
            "image/gif",
            "image/webp"
    ));
    
    // Allowed image extensions
    private static final Set<String> ALLOWED_IMAGE_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".jpg", ".jpeg", ".png", ".gif", ".webp"
    ));
    
    /**
     * Result class for file upload operations
     */
    public static class UploadResult {
        private boolean success;
        private String fileName;
        private String errorMessage;
        
        public UploadResult(boolean success, String fileName, String errorMessage) {
            this.success = success;
            this.fileName = fileName;
            this.errorMessage = errorMessage;
        }
        
        public boolean isSuccess() {
            return success;
        }
        
        public String getFileName() {
            return fileName;
        }
        
        public String getErrorMessage() {
            return errorMessage;
        }
        
        public static UploadResult success(String fileName) {
            return new UploadResult(true, fileName, null);
        }
        
        public static UploadResult error(String message) {
            return new UploadResult(false, null, message);
        }
    }
    
    /**
     * Validate and save an uploaded image file
     * @param filePart The file part from multipart request
     * @param uploadDir The directory to save the file
     * @return UploadResult containing success/failure and filename or error message
     */
    public static UploadResult saveImage(Part filePart, Path uploadDir) {
        if (filePart == null || filePart.getSize() == 0) {
            return UploadResult.error("Không có file được chọn");
        }
        
        // Validate file size
        String sizeError = validateFileSize(filePart);
        if (sizeError != null) {
            return UploadResult.error(sizeError);
        }
        
        // Validate file type
        String typeError = validateImageType(filePart);
        if (typeError != null) {
            return UploadResult.error(typeError);
        }
        
        try {
            // Create upload directory if it doesn't exist
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
                logger.debug("Created upload directory: {}", uploadDir);
            }
            
            // Generate unique filename
            String originalFileName = getFileName(filePart);
            String extension = getFileExtension(originalFileName);
            String newFileName = generateUniqueFileName(extension);
            
            // Save file
            Path filePath = uploadDir.resolve(newFileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
            }
            
            logger.info("File uploaded successfully: {}", newFileName);
            return UploadResult.success(newFileName);
            
        } catch (IOException e) {
            logger.error("Error saving uploaded file", e);
            return UploadResult.error("Lỗi khi lưu file: " + e.getMessage());
        }
    }
    
    /**
     * Validate file size
     * @param filePart The file part to validate
     * @return Error message if invalid, null if valid
     */
    public static String validateFileSize(Part filePart) {
        if (filePart == null) {
            return "File không hợp lệ";
        }
        
        if (filePart.getSize() > MAX_FILE_SIZE) {
            long maxSizeMB = MAX_FILE_SIZE / (1024 * 1024);
            logger.warn("File size exceeds maximum allowed size of {}MB", maxSizeMB);
            return "Kích thước file không được vượt quá " + maxSizeMB + "MB";
        }
        
        return null;
    }
    
    /**
     * Validate that file is an image
     * @param filePart The file part to validate
     * @return Error message if invalid, null if valid
     */
    public static String validateImageType(Part filePart) {
        if (filePart == null) {
            return "File không hợp lệ";
        }
        
        // Check MIME type
        String contentType = filePart.getContentType();
        if (contentType == null || !ALLOWED_IMAGE_TYPES.contains(contentType.toLowerCase())) {
            logger.warn("Invalid file type: {}", contentType);
            return "Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WebP)";
        }
        
        // Also check file extension
        String fileName = getFileName(filePart);
        String extension = getFileExtension(fileName).toLowerCase();
        if (!ALLOWED_IMAGE_EXTENSIONS.contains(extension)) {
            logger.warn("Invalid file extension: {}", extension);
            return "Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WebP)";
        }
        
        return null;
    }
    
    /**
     * Generate a unique filename using UUID
     * @param extension The file extension (including dot)
     * @return Unique filename
     */
    public static String generateUniqueFileName(String extension) {
        return UUID.randomUUID().toString() + extension;
    }
    
    /**
     * Generate a unique filename with a prefix
     * @param prefix Prefix for the filename (e.g., user ID)
     * @param extension The file extension (including dot)
     * @return Unique filename with prefix
     */
    public static String generateUniqueFileName(String prefix, String extension) {
        String uuid = UUID.randomUUID().toString().substring(0, 8);
        long timestamp = System.currentTimeMillis();
        return prefix + "_" + timestamp + "_" + uuid + extension;
    }
    
    /**
     * Get the file extension from a filename
     * @param fileName The filename
     * @return The file extension (including dot), or empty string if none
     */
    public static String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex == -1 || lastDotIndex == fileName.length() - 1) {
            return "";
        }
        
        return fileName.substring(lastDotIndex);
    }
    
    /**
     * Get the filename from a Part
     * @param part The file part
     * @return The filename
     */
    public static String getFileName(Part part) {
        if (part == null) {
            return "";
        }
        
        String submittedFileName = part.getSubmittedFileName();
        if (submittedFileName != null && !submittedFileName.isEmpty()) {
            return Paths.get(submittedFileName).getFileName().toString();
        }
        
        return "";
    }
    
    /**
     * Delete a file
     * @param filePath Path to the file
     * @return true if deleted successfully, false otherwise
     */
    public static boolean deleteFile(Path filePath) {
        try {
            if (Files.exists(filePath)) {
                Files.delete(filePath);
                logger.debug("File deleted: {}", filePath);
                return true;
            }
            return false;
        } catch (IOException e) {
            logger.error("Error deleting file: {}", filePath, e);
            return false;
        }
    }
    
    /**
     * Delete a file by name in a directory
     * @param directory The directory path
     * @param fileName The filename to delete
     * @return true if deleted successfully, false otherwise
     */
    public static boolean deleteFile(Path directory, String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }
        return deleteFile(directory.resolve(fileName));
    }
    
    /**
     * Get maximum allowed file size in bytes
     * @return Maximum file size
     */
    public static long getMaxFileSize() {
        return MAX_FILE_SIZE;
    }
    
    /**
     * Get maximum allowed file size in MB
     * @return Maximum file size in MB
     */
    public static long getMaxFileSizeMB() {
        return MAX_FILE_SIZE / (1024 * 1024);
    }
}
