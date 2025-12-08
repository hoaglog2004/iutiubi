package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import asm.dao.HistoryDAO;
import asm.dao.VideoDAO;
import asm.model.History;
import asm.model.User;
import asm.model.Video;

@WebServlet("/detail")
public class DetailServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
    
	// [ĐÃ SỬA] Khai báo DAO chuẩn
	private VideoDAO videoDAO = new VideoDAO();
	private HistoryDAO historyDAO = new HistoryDAO();

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
            String videoId = request.getParameter("videoId");
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            
            // 1. Tăng lượt xem và tìm video
            if (videoId != null && !videoId.isEmpty()) {
                videoDAO.incrementViewCount(videoId);
            }
            Video video = videoDAO.findById(videoId);
            
            // 2. [LOGIC LỊCH SỬ] Lấy thời điểm dừng xem của User
            if (currentUser != null) {
                History history = historyDAO.findByUserAndVideo(currentUser.getId(), videoId);
                // Gửi đối tượng History ra JSP (Nếu không tìm thấy sẽ là null)
                request.setAttribute("history", history); 
            }
            
            // 3. Lấy danh sách video liên quan (cùng thể loại)
            List<Video> relatedVideos = null;
            if (video != null && video.getCategory() != null) {
                relatedVideos = videoDAO.findRelatedVideos(video.getCategory().getId(), videoId, 8);
            }
            // Nếu không có video liên quan cùng thể loại, lấy video ngẫu nhiên
            if (relatedVideos == null || relatedVideos.isEmpty()) {
                relatedVideos = videoDAO.findAll(1, 8);
            }
            
            // 4. Đẩy dữ liệu ra JSP
            request.setAttribute("video", video);
            request.setAttribute("videoList", relatedVideos); 
            request.setAttribute("relatedVideos", relatedVideos);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        
        request.setAttribute("activePage", "detail");
        request.getRequestDispatcher("/views/detail.jsp").forward(request, response);
	}
}