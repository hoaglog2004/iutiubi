package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import asm.dao.UserDAO;
import asm.model.User;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

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
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        boolean rememberMe = (request.getParameter("rememberMe") != null);
        
        try {
            UserDAO dao = new UserDAO();
            User user = dao.checkLogin(username, password); // Dùng hàm checkLogin của DAO
            
            if (user == null) {
                // Đăng nhập thất bại
                request.setAttribute("error", "Username hoặc password không đúng!");
                request.setAttribute("view", "login"); // [JSP] Quay lại tab login
                request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
            } else {
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user); // Lưu user vào session
                
                // Xử lý "Remember Me"
                if (rememberMe) {
                    Cookie cookie = new Cookie("username", user.getId());
                    cookie.setMaxAge(60 * 60 * 24 * 30); // 30 ngày
                    response.addCookie(cookie);
                } else {
                    // Nếu bỏ check, xóa cookie
                    Cookie cookie = new Cookie("username", "");
                    cookie.setMaxAge(0); // Xóa
                    response.addCookie(cookie);
                }
                
                // Chuyển hướng về trang chủ
                response.sendRedirect("home");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.setAttribute("view", "login");
            request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
        }
    }

}
