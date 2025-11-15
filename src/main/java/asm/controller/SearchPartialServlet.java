package asm.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import asm.dao.VideoDAO;
import asm.model.Video;

@WebServlet("/search-partial") // URL mới chỉ dành cho AJAX
public class SearchPartialServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private VideoDAO videoDAO = new VideoDAO();
            
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8"); // Đảm bảo trả về UTF-8
            
            String keyword = request.getParameter("keyword");
            
            List<Video> resultList;
            if (keyword != null && !keyword.isEmpty()) {
                // 1. Gọi hàm DAO (tìm có dấu/không dấu)
                resultList = videoDAO.findByTitle(keyword);
            } else {
                // 2. Nếu xóa hết chữ, trả về 8 video đầu tiên (hoặc tất cả)
                resultList = videoDAO.findAll(1, 8); // Lấy trang 1
            }
            
            // 3. Gửi danh sách ra file JSP "phụ"
            request.setAttribute("videoList", resultList);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // 4. Forward đến file JSP "phụ"
        request.getRequestDispatcher("/views/_videoGrid.jsp").forward(request, response);
    }
}