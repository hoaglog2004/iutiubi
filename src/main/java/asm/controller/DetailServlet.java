package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import asm.dao.VideoDAO;
import asm.model.Video;

/**
 * Servlet implementation class DetailServlet
 */
@WebServlet("/detail")
public class DetailServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@SuppressWarnings("unused")
	private VideoDAO dao = new VideoDAO();

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
            // Lấy videoId từ URL (ví dụ: ?videoId=abc123)
            String videoId = request.getParameter("videoId");
            if (videoId != null && !videoId.isEmpty()) {
                dao.incrementViewCount(videoId);
            }
            VideoDAO dao = new VideoDAO();
            
            // 1. Lấy video chính
            Video video = dao.findById(videoId);
            
            // 2. Lấy danh sách video xem thêm (ví dụ: tất cả video)
            List<Video> relatedList = dao.findAll();
            
            // "Đẩy" cả 2 ra JSP
            request.setAttribute("video", video);
            request.setAttribute("videoList", relatedList); // Cho cột "Xem thêm"
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/views/detail.jsp").forward(request, response);
	}

}
