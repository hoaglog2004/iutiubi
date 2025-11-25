package asm.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import asm.dao.UserDAO;
import asm.model.User;
import asm.utils.EmailUtils;
import asm.utils.PasswordUtils;
import asm.utils.RateLimiterUtil;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(ForgotPasswordServlet.class);
	private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setAttribute("view", "forgot"); 
        request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String clientIp = RateLimiterUtil.getClientIp(request);
        
        // Check rate limit for forgot password (prevent enumeration attacks)
        if (!RateLimiterUtil.isAllowed(clientIp)) {
            logger.warn("Rate limit exceeded for forgot password from IP: {}", clientIp);
            request.setAttribute("error", "Bạn đang gửi yêu cầu quá nhanh. Vui lòng chờ một chút.");
            request.setAttribute("view", "forgot");
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
            return;
        }
        
        // [SỬA LỖI 1] Đọc đúng tên tham số từ form
        String identifier = request.getParameter("emailOrUsername"); 
        
        try {
            // [SỬA LỖI 2] Gọi hàm tìm kiếm mới
            User user = userDAO.findByEmailOrUsername(identifier);
            
            if (user == null) {
                // Email/Username không tồn tại
                logger.info("Password reset requested for non-existent user: {} from IP: {}", identifier, clientIp);
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
                
                // Cập nhật user trong CSDL với hashed password
                user.setPassword(PasswordUtils.hashPassword(newPassword)); 
                user.setMustChangePassword(true); 
                userDAO.update(user);
                
                logger.info("Password reset for user: {} from IP: {}", identifier, clientIp);
                request.setAttribute("message", "Mật khẩu tạm thời đã được gửi đến email của bạn.");
                request.setAttribute("view", "login"); // Chuyển về tab Login
            }
            
        } catch (Exception e) {
            logger.error("Error during password reset for: {}", identifier, e);
            request.setAttribute("error", "Lỗi gửi mail: " + e.getMessage());
            request.setAttribute("view", "forgot");
            request.setAttribute("emailOrUsername", identifier);
        }
        
        request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
    }
}