package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import asm.dao.UserDAO;
import asm.model.User;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

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

			if (dao.findById(username) != null) {
				// Username đã tồn tại
				request.setAttribute("error", "Tên đăng nhập (ID) đã tồn tại!");
				request.setAttribute("view", "register");
				request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
				return;
			}

			// Nếu mọi thứ OK, tạo user
			user.setId(username);
			user.setPassword(password); // Nên mã hóa mật khẩu ở đây
			user.setFullname(fullname);
			user.setEmail(email);
			user.setAdmin(false); // Mặc định là user

			dao.create(user);

			// Đăng ký thành công -> Chuyển sang tab Login
			request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
			request.setAttribute("view", "login"); // [JSP] Chuyển sang tab login
			request.getRequestDispatcher("/views/auth.jsp").forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Lỗi đăng ký: " + e.getMessage());
			request.setAttribute("view", "register");
			request.getRequestDispatcher("/views/auth.jsp").forward(request, response);
		}
	}

}
