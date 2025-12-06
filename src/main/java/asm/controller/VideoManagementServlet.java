package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;

import asm.dao.CategoryDAO;
import asm.dao.VideoDAO;
import asm.model.Category;
import asm.model.Video;

/**
 * Servlet implementation class VideoManagementServlet
 */
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024 * 2,   // 2MB
	    maxFileSize = 1024 * 1024 * 50,        // 50MB
	    maxRequestSize = 1024 * 1024 * 100     // 100MB
	)
@WebServlet("/admin/videos")
public class VideoManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private CategoryDAO categoryDAO = new CategoryDAO();
	protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
        // Phân biệt GET và POST
        if (request.getMethod().equalsIgnoreCase("POST")) {
            doPostAction(request, response);
        } else {
            doGetAction(request, response);
        }
        
        // Sau khi xử lý action, luôn tải lại danh sách
        loadAllVideos(request);
        loadAllCategories(request);
        // Luôn forward về trang JSP
        request.setAttribute("activePage", "admin");
        request.getRequestDispatcher("/admin/video-management.jsp").forward(request, response);
    }

    private void doGetAction(HttpServletRequest request, HttpServletResponse response) {
        String action = request.getParameter("action");
        if (action == null) return; // Không làm gì nếu không có action

        try {
            VideoDAO dao = new VideoDAO();
            String videoId = request.getParameter("id");
            
            if (action.equals("edit")) {
                Video video = dao.findById(videoId);
                request.setAttribute("video", video); // Gửi video ra form
                       }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
    }

    private void doPostAction(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
    	try {
            request.setCharacterEncoding("UTF-8"); // Đã thêm ở Bước 1
            String action = request.getParameter("action");
            if (action == null) return;
            VideoDAO dao = new VideoDAO();
            Video video = new Video();
            
            // 1. Lấy dữ liệu từ form
            BeanUtils.populate(video, request.getParameterMap());
            String categoryId = request.getParameter("categoryId");
            if (categoryId != null && !categoryId.isEmpty()) {
                // Lấy đối tượng Category từ CSDL
                Category category = categoryDAO.findById(categoryId); 
                video.setCategory(category); // Set đối tượng vào video
            }
            // 2. [THÊM MỚI] Tự động tạo Poster URL nếu chưa có
            String videoId = video.getId();
            String posterInput = request.getParameter("poster");
            
            // Nếu user không nhập poster URL, tự động tạo từ YouTube
            if ((posterInput == null || posterInput.trim().isEmpty()) && videoId != null && !videoId.isEmpty()) {
                String posterUrl = "https://img.youtube.com/vi/" + videoId + "/hqdefault.jpg";
                video.setPoster(posterUrl);
            } else if (posterInput != null && !posterInput.trim().isEmpty()) {
                // Nếu user nhập poster URL, sử dụng URL đó
                video.setPoster(posterInput.trim());
            }
            
            // 3. Xử lý action
            
            if (action.equals("create")) {
                dao.create(video); // Bây giờ video đã có poster
                request.setAttribute("message", "Đã tạo video thành công!");
            } else if (action.equals("update")) {
                dao.update(video); // Cập nhật cả poster
                request.setAttribute("message", "Đã cập nhật video thành công!");
            }
            else if (action.equals("delete")) {
                dao.delete(videoId);
                request.setAttribute("message", "Đã xóa video: " + videoId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // [CẢI TIẾN] Hiển thị lỗi gốc (ví dụ: lỗi trùng ID)
            request.setAttribute("error", "Lỗi: " + e.getCause().getMessage());
        }
    }
    private void loadAllCategories(HttpServletRequest request) {
        try {
            List<Category> categoryList = categoryDAO.findAll();
            request.setAttribute("categoryList", categoryList);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải thể loại: " + e.getMessage());
        }
    }
    // Hàm này luôn chạy để nạp danh sách vào bảng
    private void loadAllVideos(HttpServletRequest request) {
        try {
            VideoDAO dao = new VideoDAO();
            List<Video> videoList = dao.findAll();
            request.setAttribute("videoList", videoList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
