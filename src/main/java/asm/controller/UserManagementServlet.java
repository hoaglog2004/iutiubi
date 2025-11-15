package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;

import asm.dao.UserDAO;
import asm.model.User;

/**
 * Servlet implementation class UserManagementServlet
 */
@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Phân biệt GET và POST
        if (request.getMethod().equalsIgnoreCase("POST")) {
            doPostAction(request, response);
        } else {
            doGetAction(request, response);
        }
        
        // Sau khi xử lý, luôn tải lại danh sách user
        loadAllUsers(request);
        
        // Luôn forward về trang JSP
        request.setAttribute("activePage", "users");
        request.getRequestDispatcher("/admin/user-management.jsp").forward(request, response);
    }

    private void doGetAction(HttpServletRequest request, HttpServletResponse response) {
        String action = request.getParameter("action");
        if (action == null) return;

        try {
            UserDAO dao = new UserDAO();
            String userId = request.getParameter("id");
            
            if (action.equals("edit")) {
                User user = dao.findById(userId);
                request.setAttribute("user", user); // Gửi user ra form
            } else if (action.equals("delete")) {
                dao.delete(userId);
                request.setAttribute("message", "Đã xóa user: " + userId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
    }

    private void doPostAction(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
    	request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) return;

        try {
            UserDAO dao = new UserDAO();
            User user = new User();
            
            // Dùng BeanUtils để tự động set form data vào object
            // Lưu ý: BeanUtils sẽ set 'admin' (String "true"/"false") thành Boolean
            BeanUtils.populate(user, request.getParameterMap());
            
            // Nếu là update và password để trống, giữ lại password cũ
            if (action.equals("update") && (user.getPassword() == null || user.getPassword().isEmpty())) {
                User oldUser = dao.findById(user.getId());
                user.setPassword(oldUser.getPassword());
            }

            if (action.equals("create")) {
                dao.create(user);
                request.setAttribute("message", "Đã tạo user thành công!");
            } else if (action.equals("update")) {
                dao.update(user);
                request.setAttribute("message", "Đã cập nhật user thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
    }

    // Hàm này luôn chạy để nạp danh sách vào bảng
    private void loadAllUsers(HttpServletRequest request) {
        try {
            UserDAO dao = new UserDAO();
            List<User> userList = dao.findAll();
            request.setAttribute("userList", userList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
