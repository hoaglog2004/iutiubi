package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import asm.dao.VideoDAO;
import asm.model.User;
import asm.model.Video;

/**
 * Servlet implementation class MyFavoritesServlet
 */
@WebServlet("/my-favorites")
public class MyFavoritesServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Yêu cầu đăng nhập (dù Filter sẽ lo việc này, cẩn thận không thừa)
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            VideoDAO videoDao = new VideoDAO();
            // Gọi hàm DAO đặc biệt để lấy video yêu thích
            List<Video> favoriteList = videoDao.findFavoriteVideosByUserId(currentUser.getId());
            
            request.setAttribute("favoriteList", favoriteList);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        request.setAttribute("activePage", "favorites");
        request.getRequestDispatcher("/views/my-favorites.jsp").forward(request, response);
    }

}
