package asm.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import asm.dao.UserDAO;
import asm.model.User;

@WebServlet("/edit-profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class EditProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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
            
            // 2. Xử lý File Upload Avatar
            String uploadDir = "uploads/avatars/";
            String realUploadPath = request.getServletContext().getRealPath(uploadDir);
            Path uploadPath = Paths.get(realUploadPath);
            
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            Part filePart = request.getPart("avatarFile");
            
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();
                
                // Validate file type
                String contentType = filePart.getContentType();
                if (!contentType.startsWith("image/")) {
                    throw new Exception("Chỉ chấp nhận file ảnh (JPG, PNG)");
                }
                
                // Lấy extension
                String extension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                
                // Tạo tên file mới (username + timestamp để tránh cache)
                String newFileName = currentUser.getId() + "_" + System.currentTimeMillis() + extension;
                
                Path filePath = uploadPath.resolve(newFileName);
                
                // Xóa avatar cũ nếu có (optional)
                if (currentUser.getAvatar() != null && !currentUser.getAvatar().isEmpty()) {
                    Path oldFile = uploadPath.resolve(currentUser.getAvatar());
                    Files.deleteIfExists(oldFile);
                }
                
                // Lưu file mới
                Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                
                currentUser.setAvatar(newFileName);
            }

            // 3. Cập nhật vào Database
            UserDAO dao = new UserDAO();
            dao.update(currentUser);
            
            // 4. Cập nhật session
            session.setAttribute("currentUser", currentUser);
            
            request.setAttribute("message", "Cập nhật thông tin thành công!");
            request.setAttribute("activeTab", "profile-info");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.setAttribute("activeTab", "profile-info");
        }
        
        request.setAttribute("activePage", "settings");
        request.getRequestDispatcher("/views/edit-profile.jsp").forward(request, response);
    }

    /**
     * Xử lý đổi mật khẩu
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
            
            if (!currentUser.getPassword().equals(currentPassword)) {
                throw new Exception("Mật khẩu hiện tại không đúng!");
            }
            
            // Validate: Kiểm tra mật khẩu mới
            if (newPassword == null || newPassword.trim().isEmpty()) {
                throw new Exception("Vui lòng nhập mật khẩu mới!");
            }
            
            if (newPassword.length() < 6) {
                throw new Exception("Mật khẩu mới phải có ít nhất 6 ký tự!");
            }
            
            // Validate: Xác nhận mật khẩu khớp
            if (!newPassword.equals(confirmPassword)) {
                throw new Exception("Xác nhận mật khẩu mới không khớp!");
            }
            
            // Validate: Mật khẩu mới không được trùng cũ
            if (newPassword.equals(currentPassword)) {
                throw new Exception("Mật khẩu mới không được trùng với mật khẩu cũ!");
            }

            // Cập nhật mật khẩu mới
            UserDAO dao = new UserDAO();
            currentUser.setPassword(newPassword); // TODO: Nên mã hóa bằng BCrypt
            dao.update(currentUser);
            
            // Cập nhật session
            session.setAttribute("currentUser", currentUser);
            
            request.setAttribute("message", "Đổi mật khẩu thành công!");
            request.setAttribute("activeTab", "security");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.setAttribute("activeTab", "security");
        }
        
        request.setAttribute("activePage", "settings");
        request.getRequestDispatcher("/views/edit-profile.jsp").forward(request, response);
    }
}