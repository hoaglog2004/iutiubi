package asm.controller;

import java.io.IOException;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import asm.dao.ShareDAO;
import asm.dao.VideoDAO;
import asm.model.Share;
import asm.model.User;
import asm.model.Video;
import asm.utils.EmailUtils; // <-- [THÊM MỚI] Import

@WebServlet("/share")
public class ShareServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// [SỬA LẠI] doGet để hiển thị form
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // (Filter đã kiểm tra đăng nhập)
        String videoId = request.getParameter("videoId");
        if (videoId == null) {
            response.sendRedirect("home");
            return;
        }
        
        request.setAttribute("videoId", videoId);
        request.setAttribute("activePage", "share"); // Đặt 1 page active (nếu bạn muốn)
        
        request.getRequestDispatcher("/views/share.jsp").forward(request, response);
    }

    // [SỬA LẠI] doPost để gửi mail và lưu CSDL
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        request.setCharacterEncoding("UTF-8");
        String videoId = request.getParameter("videoId");
        String toEmail = request.getParameter("email");
        
        try {
            VideoDAO videoDao = new VideoDAO();
            ShareDAO shareDao = new ShareDAO();
            
            Video video = videoDao.findById(videoId);

            // 1. Tạo nội dung Email
            String subject = currentUser.getFullname() + " đã chia sẻ một video với bạn!";
            
            // Tạo link video (lấy đúng context path)
            String videoUrl = "http://localhost:8080" 
                            + request.getContextPath() 
                            + "/detail?videoId=" + videoId;
            
            String body = "<html><body>"
                        + "Xin chào,<br><br>"
                        + currentUser.getFullname() + " nghĩ rằng bạn sẽ thích video này:<br><br>"
                        + "<b>" + video.getTitle() + "</b><br><br>"
                        + "<a href='" + videoUrl + "'>Nhấn vào đây để xem video</a><br><br>"
                        + "Cảm ơn!</body></html>";

            // 2. [MỚI] Gửi email thật
            EmailUtils.sendEmail(toEmail, subject, body);

            // 3. Lưu lịch sử share vào CSDL (như cũ)
            Share share = new Share();
            share.setUser(currentUser);
            share.setVideo(video);
            share.setEmails(toEmail);
            share.setShareDate(new Date());
            shareDao.create(share);
            
            request.setAttribute("message", "Đã chia sẻ video thành công đến " + toEmail);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi gửi email: " + e.getMessage());
        }
        
        request.setAttribute("videoId", videoId); // Gửi lại videoId
        request.getRequestDispatcher("/views/share.jsp").forward(request, response);
    }
}