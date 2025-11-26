package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import asm.dao.UserDAO;
import asm.model.User;
import asm.utils.PasswordUtils;

/**
 * Servlet implementation class ChangePasswordServlet
 */
@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(ChangePasswordServlet.class);

	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        String currentPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmNewPassword");

        try {
            // Validate using BCrypt
            if (!PasswordUtils.checkPassword(currentPass, currentUser.getPassword())) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            } else if (!newPass.equals(confirmPass)) {
                request.setAttribute("error", "Xác nhận mật khẩu mới không khớp!");
            } else {
                // Validate password strength
                String passwordError = PasswordUtils.validatePasswordStrength(newPass);
                if (passwordError != null) {
                    request.setAttribute("error", passwordError);
                } else {
                    // Cập nhật thành công với BCrypt hash
                    UserDAO dao = new UserDAO();
                    currentUser.setPassword(PasswordUtils.hashPassword(newPass));
                    dao.update(currentUser);
                    
                    session.setAttribute("currentUser", currentUser); // Cập nhật session
                    logger.info("Password changed for user: {}", currentUser.getId());
                    request.setAttribute("message", "Đổi mật khẩu thành công!");
                }
            }
        } catch (Exception e) {
            logger.error("Error changing password for user: {}", currentUser.getId(), e);
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }

}
