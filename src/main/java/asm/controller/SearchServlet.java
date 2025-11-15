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

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private VideoDAO videoDAO = new VideoDAO();
            
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            request.setCharacterEncoding("UTF-8"); // Xử lý Tiếng Việt
            String keyword = request.getParameter("keyword");
            
            if (keyword != null && !keyword.isEmpty()) {
                // 1. Gọi hàm DAO mới
                List<Video> resultList = videoDAO.findByTitle(keyword);
                
                // 2. Gửi danh sách kết quả ra JSP
                request.setAttribute("videoList", resultList);
                // 3. Gửi lại từ khóa để hiển thị trên tiêu đề
                request.setAttribute("searchKeyword", keyword); 
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tìm kiếm: " + e.getMessage());
        }
        
        // 4. Set activePage rỗng (không highlight mục nào)
        request.setAttribute("activePage", "search"); 
        
        // 5. Forward đến trang kết quả
        request.getRequestDispatcher("/views/search-results.jsp").forward(request, response);
    }
}