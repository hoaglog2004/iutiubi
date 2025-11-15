package asm.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig; // <-- [MỚI] Bắt buộc
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part; // <-- [MỚI] Bắt buộc

import asm.dao.UserDAO;
import asm.model.User;

@WebServlet("/edit-profile")
@MultipartConfig // [MỚI] Thêm annotation này để xử lý file
public class EditProfileServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setAttribute("activePage", "settings"); // Highlight sidebar
        request.getRequestDispatcher("/views/edit-profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        try {
            // 1. Cập nhật Fullname (trường duy nhất có thể sửa)
            String fullname = request.getParameter("fullname");
            currentUser.setFullname(fullname);
            
            // 2. [MỚI] Xử lý File Upload
            // Tạo thư mục lưu trữ nếu chưa có
            String uploadDir = "/uploads/avatars/";
            // Lấy đường dẫn vật lý trên server
            String realUploadPath = request.getServletContext().getRealPath(uploadDir);
            Path uploadPath = Paths.get(realUploadPath);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Lấy file từ form (name="avatarFile")
            Part filePart = request.getPart("avatarFile");
            
            // Kiểm tra xem người dùng có tải file lên không
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();
                
                // Lấy đuôi file (ví dụ: .jpg, .png)
                String extension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                
                // Tạo tên file mới duy nhất (ví dụ: gnol.jpg)
                String newFileName = currentUser.getId() + extension;
                
                // Đường dẫn file đầy đủ trên server
                Path filePath = uploadPath.resolve(newFileName);
                
                // Lưu file (ghi đè file cũ nếu có)
                Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                
                // 3. Cập nhật tên file avatar vào đối tượng User
                currentUser.setAvatar(newFileName);
            }
            // (Nếu người dùng không tải file, trường 'avatar' cũ sẽ được giữ nguyên)

            // 4. Cập nhật User vào CSDL
            UserDAO dao = new UserDAO();
            dao.update(currentUser);
            
            // 5. Cập nhật lại session
            session.setAttribute("currentUser", currentUser);
            
            request.setAttribute("message", "Cập nhật tài khoản thành công!");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
        }
        
        request.setAttribute("activePage", "settings");
        request.getRequestDispatcher("/views/edit-profile.jsp").forward(request, response);
    }
}