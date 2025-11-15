package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import asm.dao.FavoriteDAO;
import asm.dao.ShareDAO;
import asm.dao.VideoDAO;
import asm.model.Favorite;
import asm.model.ReportFavorite;
import asm.model.Share;
import asm.model.Video;

/**
 * Servlet implementation class ReportServlet
 */
@WebServlet("/admin/reports")
public class ReportServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        VideoDAO videoDao = new VideoDAO();
        FavoriteDAO favoriteDao = new FavoriteDAO();
        ShareDAO shareDao = new ShareDAO();
        
        try {
            // ----- Dữ liệu CHUNG -----
            // Luôn tải danh sách video cho các dropdown
            List<Video> videoList = videoDao.findAll();
            request.setAttribute("videoList", videoList);

            // ----- LOGIC TAB 1: FAVORITES -----
            // (Luôn tải tab này)
            // (Đảm bảo bạn đã có hàm getReportFavorites() trong FavoriteDAO)
            List<ReportFavorite> reportFavorites = favoriteDao.getReportFavorites();
            request.setAttribute("reportFavorites", reportFavorites);

            // ----- LOGIC TAB 2: FAVORITE USERS -----
            String videoId_Tab2 = request.getParameter("videoId");
            if (videoId_Tab2 != null && !videoId_Tab2.isEmpty()) {
                // Nếu người dùng đã chọn 1 video, lấy danh sách người like
                // (Đảm bảo bạn đã có hàm findUsersWhoLikedVideo() trong FavoriteDAO)
                List<Favorite> usersWhoLiked = favoriteDao.findUsersWhoLikedVideo(videoId_Tab2);
                request.setAttribute("usersWhoLiked", usersWhoLiked);
            }

            // ----- LOGIC TAB 3: SHARED FRIENDS -----
            String videoId_Tab3 = request.getParameter("sharedVideoId");
            if (videoId_Tab3 != null && !videoId_Tab3.isEmpty()) {
                // Nếu người dùng đã chọn 1 video, lấy lịch sử share
                // (Đảm bảo bạn đã có hàm findSharesByVideo() trong ShareDAO)
                List<Share> sharesOfVideo = shareDao.findSharesByVideo(videoId_Tab3);
                request.setAttribute("sharesOfVideo", sharesOfVideo);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải báo cáo: " + e.getMessage());
        }
        
        // Luôn set "activePage" để sidebar highlight đúng
        request.setAttribute("activePage", "reports"); 
        
        // Forward về trang JSP
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }

}
