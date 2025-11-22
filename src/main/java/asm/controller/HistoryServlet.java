package asm.controller;

import java.io.IOException;
import java.util.List;

import asm.dao.HistoryDAO;
import asm.model.History;
import asm.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/history") // URL mới
public class HistoryServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private HistoryDAO historyDAO = new HistoryDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // AuthFilter đã chặn người dùng chưa đăng nhập, nhưng vẫn check lại cho an toàn
        if (currentUser == null) {
            response.sendRedirect("login"); 
            return;
        }

        try {
            // 1. Lấy danh sách lịch sử xem
            List<History> historyList = historyDAO.findHistoryByUserId(currentUser.getId());
            
            // 2. Gửi danh sách lịch sử ra JSP
            request.setAttribute("historyList", historyList);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải lịch sử xem: " + e.getMessage());
        }

        // 3. Set Active Page và forward
        request.setAttribute("activePage", "history");
        request.getRequestDispatcher("/views/history.jsp").forward(request, response);
    }
}