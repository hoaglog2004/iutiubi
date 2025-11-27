package asm.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import asm.dao.UserDAO;
import asm.model.User;
import asm.utils.FileUploadUtil;
import asm.utils.PasswordUtils;

@WebServlet("/edit-profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 5,        // 5MB (reduced from 10MB)
    maxRequestSize = 1024 * 1024 * 10     // 10MB (reduced from 50MB)
)
public class EditProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(EditProfileServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setAttribute("activePage", "settings");
        request.getRequestDispatcher("/views/edit-profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Phân biệt action: updateProfile hoặc changePassword
        String action = request.getParameter("action");
        
        if ("changePassword".equals(action)) {
            handleChangePassword(request, response);
        } else {
            handleUpdateProfile(request, response);
        }
    }

    /**
     * Xử lý cập nhật thông tin cá nhân
     */
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            // 1. Cập nhật Fullname
            String fullname = request.getParameter("fullname");
            if (fullname != null && !fullname.trim().isEmpty()) {
                currentUser.setFullname(fullname.trim());
            }
            
            // 2. Xử lý File Upload Avatar với FileUploadUtil
            String uploadDir = "uploads/avatars/";
            String realUploadPath = request.getServletContext().getRealPath(uploadDir);
            Path uploadPath = Paths.get(realUploadPath);
            
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            Part filePart = request.getPart("avatarFile");
            
            if (filePart != null && filePart.getSize() > 0) {
                // Use FileUploadUtil for validation and saving
                FileUploadUtil.UploadResult result = FileUploadUtil.saveImage(filePart, uploadPath);
                
                if (!result.isSuccess()) {
                    throw new Exception(result.getErrorMessage());
                }
                
                // Xóa avatar cũ nếu có
                if (currentUser.getAvatar() != null && !currentUser.getAvatar().isEmpty()) {
                    FileUploadUtil.deleteFile(uploadPath, currentUser.getAvatar());
                }
                
                currentUser.setAvatar(result.getFileName());
                logger.info("Avatar updated for user: {}", currentUser.getId());
            }

            // 3. Cập nhật vào Database
            UserDAO dao = new UserDAO();
            dao.update(currentUser);
            
            // 4. Cập nhật session
            session.setAttribute("currentUser", currentUser);
            
            request.setAttribute("message", "Cập nhật thông tin thành công!");
            request.setAttribute("activeTab", "profile-info");
            
        } catch (Exception e) {
            logger.error("Error updating profile for user: {}", currentUser.getId(), e);
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.setAttribute("activeTab", "profile-info");
        }
        
        request.setAttribute("activePage", "settings");
        request.getRequestDispatcher("/views/edit-profile.jsp").forward(request, response);
    }

    /**
     * Xử lý đổi mật khẩu với BCrypt
     */
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            // Validate: Kiểm tra mật khẩu hiện tại
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                throw new Exception("Vui lòng nhập mật khẩu hiện tại!");
            }
            
            // Use BCrypt to verify current password
            if (!PasswordUtils.checkPassword(currentPassword, currentUser.getPassword())) {
                throw new Exception("Mật khẩu hiện tại không đúng!");
            }
            
            // Validate: Kiểm tra mật khẩu mới
            if (newPassword == null || newPassword.trim().isEmpty()) {
                throw new Exception("Vui lòng nhập mật khẩu mới!");
            }
            
            // Validate password strength
            String passwordError = PasswordUtils.validatePasswordStrength(newPassword);
            if (passwordError != null) {
                throw new Exception(passwordError);
            }
            
            // Validate: Xác nhận mật khẩu khớp
            if (!newPassword.equals(confirmPassword)) {
                throw new Exception("Xác nhận mật khẩu mới không khớp!");
            }
            
            // Validate: Mật khẩu mới không được trùng cũ
            if (PasswordUtils.checkPassword(newPassword, currentUser.getPassword())) {
                throw new Exception("Mật khẩu mới không được trùng với mật khẩu cũ!");
            }

            // Cập nhật mật khẩu mới với BCrypt hash
            UserDAO dao = new UserDAO();
            currentUser.setPassword(PasswordUtils.hashPassword(newPassword));
            dao.update(currentUser);
            
            // Cập nhật session
            session.setAttribute("currentUser", currentUser);
            
            logger.info("Password changed for user: {}", currentUser.getId());
            request.setAttribute("message", "Đổi mật khẩu thành công!");
            request.setAttribute("activeTab", "security");
            
        } catch (Exception e) {
            logger.error("Error changing password for user: {}", currentUser.getId(), e);
            request.setAttribute("error", e.getMessage());
            request.setAttribute("activeTab", "security");
        }
        
        request.setAttribute("activePage", "settings");
        request.getRequestDispatcher("/views/edit-profile.jsp").forward(request, response);
    }
}