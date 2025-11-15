package asm.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import asm.dao.CategoryDAO;
import asm.dao.VideoDAO;
import asm.model.Category;
import asm.model.Video;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private VideoDAO videoDAO = new VideoDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy danh sách thể loại cho thanh filter
            List<Category> categoryList = categoryDAO.findAll();
            request.setAttribute("categoryList", categoryList);
            
            final int PAGE_SIZE = 8; // Đặt số video mỗi trang là 8
            String pageParam = request.getParameter("page");
            String categoryId = request.getParameter("categoryId");
            
            int page = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);
            
            List<Video> videoList;
            long totalVideos;
            
            if (categoryId != null && !categoryId.isEmpty()) {
                // Nếu có lọc, gọi hàm mới
                totalVideos = videoDAO.countByCategory(categoryId);
                
                // [ĐÃ SỬA] Gọi hàm DAO có 3 tham số
                videoList = videoDAO.findByCategory(categoryId, page, PAGE_SIZE); 
                
                request.setAttribute("activeCategory", categoryId);
            } else {
                // Nếu không lọc, lấy tất cả
                totalVideos = videoDAO.countAll();
                
                // [ĐÃ SỬA] Gọi hàm DAO có 2 tham số
                videoList = videoDAO.findAll(page, PAGE_SIZE); 
                
                request.setAttribute("activeCategory", "all");
            }
            
            // Tính toán tổng số trang
            long totalPages = (long) Math.ceil((double) totalVideos / PAGE_SIZE);
            
            // Gửi dữ liệu ra JSP
            request.setAttribute("videoList", videoList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        
        request.setAttribute("activePage", "home"); // Highlight sidebar
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}