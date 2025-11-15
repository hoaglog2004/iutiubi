package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import asm.dao.FavoriteDAO;
import asm.model.Favorite;
import asm.model.User;

/**
 * Servlet implementation class UnlikeServlet
 */
@WebServlet("/unlike")
public class UnlikeServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -2091731044151128951L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String videoId = request.getParameter("videoId");
        if (videoId == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            FavoriteDAO favoriteDao = new FavoriteDAO();
            Favorite favorite = favoriteDao.findByUserIdAndVideoId(currentUser.getId(), videoId);
            
            if (favorite != null) {
                // Nếu tìm thấy, xóa nó đi
                favoriteDao.delete(favorite.getId());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Quay lại trang Yêu thích
        response.sendRedirect("my-favorites");
    }

}
