package asm.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import asm.dao.UserDAO;
import asm.model.User;

@WebServlet("/force-change-password")
public class ForceChangePasswordServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO = new UserDAO();

    // Hiển thị form bắt buộc đổi MK
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // (AuthFilter đã kiểm tra đăng nhập)
        request.getRequestDispatcher("/views/force-change-password.jsp").forward(request, response);
    }

    // Xử lý đổi MK
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        String currentPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmNewPassword");

        try {
            // Validate
            if (!currentUser.getPassword().equals(currentPass)) {
                request.setAttribute("error", "Mật khẩu hiện tại (đã nhận qua email) không đúng!");
            } else if (!newPass.equals(confirmPass)) {
                request.setAttribute("error", "Xác nhận mật khẩu mới không khớp!");
            } else {
                // Cập nhật thành công
                currentUser.setPassword(newPass); // (Nếu mã hóa, hãy mã hóa ở đây)
                currentUser.setMustChangePassword(false); // [QUAN TRỌNG] Bỏ "đánh dấu"
                
                userDAO.update(currentUser);
                
                session.setAttribute("currentUser", currentUser); // Cập nhật session
                
                // Đổi MK thành công, chuyển về trang chủ
                response.sendRedirect("home");
                return; // Dừng lại để không chạy forward bên dưới
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/views/force-change-password.jsp").forward(request, response);
    }
}