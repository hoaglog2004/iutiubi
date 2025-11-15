package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;

import asm.dao.FavoriteDAO;
import asm.dao.VideoDAO;
import asm.model.Favorite;
import asm.model.User;

/**
 * Servlet implementation class LikeServlet
 */
@WebServlet("/like")
public class LikeServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Yêu cầu đăng nhập
        if (currentUser == null) {
            response.sendRedirect("login"); // Đưa về trang đăng nhập
            return;
        }

        String videoId = request.getParameter("videoId");
        
        // Tránh lỗi, dù GET hay POST cũng nên redirect
        if (videoId == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            FavoriteDAO favoriteDao = new FavoriteDAO();
            
            // Kiểm tra xem user đã like video này chưa
            Favorite existingFavorite = favoriteDao.findByUserIdAndVideoId(currentUser.getId(), videoId);
            
            if (existingFavorite == null) {
                // Nếu chưa like -> Tạo mới
                VideoDAO videoDao = new VideoDAO();
                
                Favorite newFavorite = new Favorite();
                newFavorite.setUser(currentUser);
                newFavorite.setVideo(videoDao.findById(videoId)); // Cần VideoDAO để lấy đối tượng Video
                newFavorite.setLikeDate(new Date());
                
                favoriteDao.create(newFavorite);
            }
            // Nếu đã like rồi thì không làm gì cả
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Quay lại trang chi tiết video
        response.sendRedirect("detail?videoId=" + videoId);
    }

}
