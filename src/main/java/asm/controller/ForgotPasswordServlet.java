package asm.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import asm.dao.UserDAO;
import asm.model.User;
import asm.utils.EmailUtils;
import asm.utils.PasswordUtils;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setAttribute("view", "forgot"); 
        request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        // [SỬA LỖI 1] Đọc đúng tên tham số từ form
        String identifier = request.getParameter("emailOrUsername"); 
        
        try {
            // [SỬA LỖI 2] Gọi hàm tìm kiếm mới
            User user = userDAO.findByEmailOrUsername(identifier);
            
            if (user == null) {
                // Email/Username không tồn tại
                request.setAttribute("error", "Email hoặc Tên đăng nhập không tồn tại trong hệ thống!");
                request.setAttribute("view", "forgot");
                request.setAttribute("emailOrUsername", identifier); // Giữ lại giá trị
            } else {
                // Email/Username tồn tại -> Thực hiện reset
                
                String newPassword = PasswordUtils.generateRandomPassword(8);
                
                // Gửi email
                String subject = "Khôi phục mật khẩu Iutiubi";
                String body = "<html><body>Xin chào " + user.getFullname() + ",<br><br>"
                            + "Mật khẩu tạm thời của bạn là: <b>" + newPassword + "</b><br><br>"
                            + "Bạn sẽ bị buộc phải đổi mật khẩu này ngay sau khi đăng nhập.</body></html>";
                
                EmailUtils.sendEmail(user.getEmail(), subject, body); // Dùng email từ DB để gửi
                
                // Cập nhật user trong CSDL
                user.setPassword(newPassword); 
                user.setMustChangePassword(true); 
                userDAO.update(user);
                
                request.setAttribute("message", "Mật khẩu tạm thời đã được gửi đến email của bạn.");
                request.setAttribute("view", "login"); // Chuyển về tab Login
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi gửi mail: " + e.getMessage());
            request.setAttribute("view", "forgot");
            request.setAttribute("emailOrUsername", identifier);
        }
        
        request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
    }
}