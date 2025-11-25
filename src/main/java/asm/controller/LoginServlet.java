package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import asm.dao.UserDAO;
import asm.model.User;
import asm.utils.RateLimiterUtil;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);

	// Hiển thị trang auth.jsp (với tab login được active)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // [JSP] Báo cho auth.jsp biết là phải hiển thị form 'login'
        request.setAttribute("view", "login"); 
        
        // Kiểm tra cookie "rememberMe"
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("username")) {
                    request.setAttribute("rememberedUser", cookie.getValue());
                }
            }
        }
        
        request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
    }

    // Xử lý form đăng nhập
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String clientIp = RateLimiterUtil.getClientIp(request);
        
        // Check if IP is locked out
        if (RateLimiterUtil.isLockedOut(clientIp)) {
            logger.warn("Login attempt from locked out IP: {}", clientIp);
            request.setAttribute("error", "Tài khoản đã bị tạm khóa do đăng nhập sai quá nhiều lần. Vui lòng thử lại sau 15 phút.");
            request.setAttribute("view", "login");
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
            return;
        }
        
        // Check rate limit
        if (!RateLimiterUtil.isAllowed(clientIp)) {
            logger.warn("Rate limit exceeded for IP: {}", clientIp);
            request.setAttribute("error", "Bạn đang gửi yêu cầu quá nhanh. Vui lòng chờ một chút.");
            request.setAttribute("view", "login");
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
            return;
        }
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean rememberMe = (request.getParameter("rememberMe") != null);
        
        try {
            UserDAO dao = new UserDAO();
            User user = dao.checkLogin(username, password); // Dùng hàm checkLogin với BCrypt
            
            if (user == null) {
                // Đăng nhập thất bại - record failed attempt
                boolean lockedOut = RateLimiterUtil.recordFailedAttempt(clientIp);
                int remaining = RateLimiterUtil.getRemainingAttempts(clientIp);
                
                logger.info("Failed login attempt for user: {} from IP: {}", username, clientIp);
                
                String errorMessage = "Username hoặc password không đúng!";
                if (lockedOut) {
                    errorMessage = "Tài khoản đã bị tạm khóa do đăng nhập sai quá nhiều lần. Vui lòng thử lại sau 15 phút.";
                } else if (remaining <= 3) {
                    errorMessage += " Còn " + remaining + " lần thử.";
                }
                
                request.setAttribute("error", errorMessage);
                request.setAttribute("view", "login"); // [JSP] Quay lại tab login
                request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
            } else {
                // Đăng nhập thành công - clear failed attempts
                RateLimiterUtil.clearFailedAttempts(clientIp);
                logger.info("Successful login for user: {} from IP: {}", username, clientIp);
                
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user); // Lưu user vào session
                
                // Xử lý "Remember Me"
                if (rememberMe) {
                    Cookie cookie = new Cookie("username", user.getId());
                    cookie.setMaxAge(60 * 60 * 24 * 30); // 30 ngày
                    cookie.setHttpOnly(true); // Security: prevent XSS access
                    response.addCookie(cookie);
                } else {
                    // Nếu bỏ check, xóa cookie
                    Cookie cookie = new Cookie("username", "");
                    cookie.setMaxAge(0); // Xóa
                    cookie.setHttpOnly(true);
                    response.addCookie(cookie);
                }
                
                // Chuyển hướng về trang chủ
                response.sendRedirect("home");
            }
            
        } catch (Exception e) {
            logger.error("Error during login for user: {}", username, e);
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.setAttribute("view", "login");
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
        }
    }

}
