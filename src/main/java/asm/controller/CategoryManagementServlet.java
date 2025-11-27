package asm.controller;

import java.io.IOException;
import java.util.List;
import org.apache.commons.beanutils.BeanUtils;
import asm.dao.CategoryDAO;
import asm.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/categories") // URL cho trang quản lý thể loại
public class CategoryManagementServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private CategoryDAO categoryDAO = new CategoryDAO();

    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // Phân biệt GET (để edit) và POST (để create/update/delete)
        if (request.getMethod().equalsIgnoreCase("POST")) {
            if (action.equals("create")) {
                doCreate(request, response);
            } else if (action.equals("update")) {
                doUpdate(request, response);
            } else if (action.equals("delete")) {
                handleDelete(request, response);
            }
        } else { // Xử lý GET
            if (action != null && action.equals("edit")) {
                doEdit(request, response);
            }
        }

        // Luôn tải danh sách thể loại để hiển thị bảng
        loadAllCategories(request);
        
        request.setAttribute("activePage", "categories"); // Giữ highlight sidebar
        request.getRequestDispatcher("/admin/category-management.jsp").forward(request, response);
    }

    private void loadAllCategories(HttpServletRequest request) {
        try {
            List<Category> categoryList = categoryDAO.findAll();
            request.setAttribute("categoryList", categoryList);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải danh sách thể loại: " + e.getMessage());
        }
    }

    private void doEdit(HttpServletRequest request, HttpServletResponse response) {
        try {
            String id = request.getParameter("id");
            Category category = categoryDAO.findById(id);
            request.setAttribute("category", category); // Gửi thể loại ra form
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
    }
    
    private void doCreate(HttpServletRequest request, HttpServletResponse response) {
        try {
            Category category = new Category();
            BeanUtils.populate(category, request.getParameterMap());
            
            // Kiểm tra ID đã tồn tại
            Category existing = categoryDAO.findById(category.getId());
            if (existing != null) {
                request.setAttribute("error", "Lỗi: Thể loại với ID '" + category.getId() + "' đã tồn tại! Vui lòng chọn ID khác.");
                request.setAttribute("category", category);
                return;
            }
            
            categoryDAO.create(category);
            categoryDAO.invalidateCache();
            request.setAttribute("message", "Đã tạo thể loại thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tạo thể loại: " + e.getMessage());
        }
    }
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) {
        try {
            String id = request.getParameter("id");
            categoryDAO.delete(id);
            categoryDAO.invalidateCache();
            request.setAttribute("message", "Đã xóa thể loại thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xóa thể loại: " + e.getMessage());
        }
    }
    private void doUpdate(HttpServletRequest request, HttpServletResponse response) {
        try {
            Category category = new Category();
            BeanUtils.populate(category, request.getParameterMap());
            categoryDAO.update(category);
            categoryDAO.invalidateCache();
            request.setAttribute("message", "Đã cập nhật thể loại thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cập nhật thể loại: " + e.getMessage());
        }
    }
    
}