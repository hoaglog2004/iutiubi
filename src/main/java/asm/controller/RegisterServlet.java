package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import asm.dao.UserDAO;
import asm.model.User;
import asm.utils.PasswordUtils;
import asm.utils.RateLimiterUtil;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(RegisterServlet.class);

	// Hiển thị trang auth.jsp (với tab register được active)
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// [JSP] Báo cho auth.jsp biết là phải hiển thị form 'register'
		request.setAttribute("view", "register");
		request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
	}

	// Xử lý form đăng ký
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String clientIp = RateLimiterUtil.getClientIp(request);
		
		// Check rate limit
		if (!RateLimiterUtil.isAllowed(clientIp)) {
			logger.warn("Rate limit exceeded for registration from IP: {}", clientIp);
			request.setAttribute("error", "Bạn đang gửi yêu cầu quá nhanh. Vui lòng chờ một chút.");
			request.setAttribute("view", "register");
			request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
			return;
		}

		UserDAO dao = new UserDAO();
		User user = new User();

		try {
			// Lấy thông tin từ form
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String confirmPassword = request.getParameter("confirmPassword");
			String fullname = request.getParameter("fullname");
			String email = request.getParameter("email");

			// Validate
			if (!password.equals(confirmPassword)) {
				// Mật khẩu không khớp
				request.setAttribute("error", "Xác nhận mật khẩu không khớp!");
				request.setAttribute("view", "register"); // [JSP] Quay lại tab register
				request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
				return;
			}

			// Validate password strength
			String passwordError = PasswordUtils.validatePasswordStrength(password);
			if (passwordError != null) {
				request.setAttribute("error", passwordError);
				request.setAttribute("view", "register");
				request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
				return;
			}

			if (dao.findById(username) != null) {
				// Username đã tồn tại
				request.setAttribute("error", "Tên đăng nhập (ID) đã tồn tại!");
				request.setAttribute("view", "register");
				request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
				return;
			}

			// Nếu mọi thứ OK, tạo user với hashed password
			user.setId(username);
			user.setPassword(PasswordUtils.hashPassword(password)); // Hash password với BCrypt
			user.setFullname(fullname);
			user.setEmail(email);
			user.setAdmin(false); // Mặc định là user

			dao.create(user);
			
			logger.info("New user registered: {} from IP: {}", username, clientIp);

			// Đăng ký thành công -> Chuyển sang tab Login
			request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
			request.setAttribute("view", "login"); // [JSP] Chuyển sang tab login
			request.getRequestDispatcher("/views/auth.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error("Error during registration", e);
			request.setAttribute("error", "Lỗi đăng ký: " + e.getMessage());
			request.setAttribute("view", "register");
			request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
		}
	}

}
