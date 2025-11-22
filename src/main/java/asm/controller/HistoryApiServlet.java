package asm.controller;

import java.io.IOException;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import asm.dao.HistoryDAO;
import asm.dao.VideoDAO;
import asm.model.History;
import asm.model.User;
import asm.model.Video;

@WebServlet("/api/history")
public class HistoryApiServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private HistoryDAO historyDAO = new HistoryDAO();
    private VideoDAO videoDAO = new VideoDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Luôn set encoding cho POST request (mặc dù AJAX này chỉ gửi số)
        request.setCharacterEncoding("UTF-8"); 
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Lấy dữ liệu từ AJAX
        String videoId = request.getParameter("videoId");
        String lastTimeParam = request.getParameter("lastTime"); // Lấy giá trị chuỗi
        
        // 1. Kiểm tra bảo mật và dữ liệu cơ bản
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401: Chưa đăng nhập
            return;
        }
        if (videoId == null || videoId.isEmpty() || lastTimeParam == null || lastTimeParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400: Yêu cầu thiếu dữ liệu
            return;
        }

        // 2. [SỬA LỖI] Chuyển đổi lastTime an toàn (thêm try-catch hoặc kiểm tra)
        int lastTime = 0; 
        try {
            lastTime = Integer.parseInt(lastTimeParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400: Gửi chuỗi thay vì số
            return;
        }

        // 3. Xử lý Logic CSDL (Tạo mới hoặc Cập nhật)
        try {
            History history = historyDAO.findByUserAndVideo(currentUser.getId(), videoId);
            
            // Chỉ cần Video đối tượng cho mối quan hệ, không cần videoDAO.findById() nếu không dùng trường nào khác
            Video video = new Video(); 
            video.setId(videoId); // Tạo đối tượng Video tham chiếu
            
            if (history == null) {
                // Nếu chưa có lịch sử, tạo mới
                history = new History();
                history.setUser(currentUser);
                history.setVideo(video); // Chỉ cần ID để lưu khóa ngoại
                history.setLastTime(lastTime);
                history.setViewDate(new Date());
                historyDAO.create(history);
            } else {
                // Nếu đã có, cập nhật thời gian và ngày xem
                history.setLastTime(lastTime);
                history.setViewDate(new Date());
                historyDAO.update(history);
            }

            response.setStatus(HttpServletResponse.SC_OK); // 200: Thành công
        } catch (Exception e) {
            // Lỗi CSDL (ví dụ: videoId không tồn tại)
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500: Lỗi server
        }
    }
    
    // Hàm doGet bị bỏ trống vì đây là endpoint API POST
}