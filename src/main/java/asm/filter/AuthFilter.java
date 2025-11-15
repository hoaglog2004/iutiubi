package asm.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import asm.model.User;

/**
 * Servlet Filter implementation class AuthFilter
 */
@SuppressWarnings("unused")
@WebFilter("/*")
public class AuthFilter extends HttpFilter implements Filter {
       
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		HttpSession session = httpRequest.getSession();

		String uri = httpRequest.getRequestURI();
		User user = (User) session.getAttribute("currentUser");
		// --- [THÊM LOGIC MỚI] ---
        // 1. Kiểm tra xem user có bị "đánh dấu" không
        if (user != null && user.getMustChangePassword()) {
            
            // Nếu bị "đánh dấu", chỉ cho phép họ truy cập 3 trang:
            // 1. Trang Bắt buộc đổi MK
            // 2. Servlet xử lý đổi MK
            // 3. Trang Logout
            if (uri.endsWith("/force-change-password") || 
                uri.endsWith("/logout") || 
                uri.endsWith("/assets/css/auth.css") ) { // Cho phép CSS
                
                chain.doFilter(request, response); // Cho qua
                return;
            } else {
                // Chặn tất cả các trang khác (kể cả /home, /admin)
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/force-change-password");
                return;
            }
        }
		if (uri.startsWith(httpRequest.getContextPath() + "/assets/")) {
	        chain.doFilter(request, response); // Cho qua, không kiểm tra
	        return; // Dừng lại
	    }

		if (uri.startsWith(httpRequest.getContextPath() + "/admin/")) {
			// Đây là trang Admin
			if (user == null) {
				// Chưa đăng nhập
				httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
			} else if (!user.getAdmin()) {
				// Đăng nhập nhưng không phải Admin
				httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
			} else {
				// Là Admin, cho qua
				chain.doFilter(request, response);
			}
		} else if (uri.startsWith(httpRequest.getContextPath() + "/my-favorites")
				|| uri.startsWith(httpRequest.getContextPath() + "/like")
				|| uri.startsWith(httpRequest.getContextPath() + "/unlike")
				|| uri.startsWith(httpRequest.getContextPath() + "/share")
				|| uri.startsWith(httpRequest.getContextPath() + "/edit-profile")
				|| uri.startsWith(httpRequest.getContextPath() + "/change-password")) {

			// Đây là trang yêu cầu đăng nhập
			if (user == null) {
				// Chưa đăng nhập, bắt về trang login
				httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
			} else {
				// Đã đăng nhập, cho qua
				chain.doFilter(request, response);
			}
		} else {
			// Đây là trang công khai (home, detail, login, assets...)
			// Cho qua
			chain.doFilter(request, response);
		}
	}

}
