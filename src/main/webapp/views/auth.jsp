<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng Nhập & Đăng Ký - Iutiubi</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link href="<c:url value='/assets/css/auth.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/animations.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/components.css'/>" rel="stylesheet" />
  </head>
  <body>
    <div class="auth-container">
      <div class="form-section active" id="loginSection">
        <h2>Đăng Nhập</h2>
        <p>Chào mừng quay lại!</p>

        <c:if test="${view == 'login' && not empty message}">
          <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> ${message}
          </div>
        </c:if>
        <c:if test="${view == 'login' && not empty error}">
          <div class="alert alert-danger">${error}</div>
        </c:if>

        <form id="loginForm" action="login" method="post">
          <div class="form-group">
            <label for="loginUsername">Tên đăng nhập (ID)</label> <input
            type="text" class="form-control" id="loginUsername" name="username"
            <%-- Thêm 'name' --%> placeholder="Nhập tên đăng nhập" required
            value="${param.username}" <%-- Giữ lại giá trị khi lỗi --%> />
          </div>

          <div class="form-group">
            <label for="loginPassword">Mật khẩu</label> <input type="password"
            class="form-control" id="loginPassword" name="password" <%-- Thêm
            'name' --%> placeholder="Nhập mật khẩu" required />
          </div>

          <div class="form-check">
            <input
              type="checkbox"
              id="rememberMe"
              name="rememberMe"
              value="true"
              class="form-check-input"
            />
            <label for="rememberMe" class="form-check-label">Ghi nhớ tôi</label>
          </div>

          <button type="submit" class="btn-primary">Đăng Nhập</button>
        </form>

        <!-- Social Login Section -->
        <div class="social-login-divider" style="display: flex; align-items: center; margin: 20px 0;">
          <span style="flex: 1; border-bottom: 1px solid #ddd;"></span>
          <span style="padding: 0 15px; color: #888; font-size: 14px;">hoặc đăng nhập với</span>
          <span style="flex: 1; border-bottom: 1px solid #ddd;"></span>
        </div>
        
        <div class="social-login-buttons" style="display: flex; flex-direction: column; gap: 10px; margin-bottom: 20px;">
          <a href="<c:url value='/oauth2/google'/>" class="btn" style="display: flex; align-items: center; justify-content: center; padding: 12px 20px; border-radius: 8px; background-color: #fff; color: #757575; border: 1px solid #ddd; text-decoration: none; font-weight: 500; transition: all 0.3s ease;">
            <i class="fab fa-google" style="margin-right: 10px; font-size: 18px;"></i> Google
          </a>
          <a href="<c:url value='/oauth2/facebook'/>" class="btn" style="display: flex; align-items: center; justify-content: center; padding: 12px 20px; border-radius: 8px; background-color: #1877f2; color: white; text-decoration: none; font-weight: 500; transition: all 0.3s ease;">
            <i class="fab fa-facebook-f" style="margin-right: 10px; font-size: 18px;"></i> Facebook
          </a>
          <a href="<c:url value='/oauth2/github'/>" class="btn" style="display: flex; align-items: center; justify-content: center; padding: 12px 20px; border-radius: 8px; background-color: #24292e; color: white; text-decoration: none; font-weight: 500; transition: all 0.3s ease;">
            <i class="fab fa-github" style="margin-right: 10px; font-size: 18px;"></i> GitHub
          </a>
        </div>

        <div class="toggle-section">
          Chưa có tài khoản? <a onclick="switchForm('register')">Đăng ký</a>
          <br />
          <a onclick="switchForm('forgot')">Quên mật khẩu?</a>
        </div>
      </div>

      <div class="form-section" id="registerSection">
        <h2>Đăng Ký</h2>
        <p>Tạo tài khoản mới</p>

        <c:if test="${view == 'register' && not empty message}">
          <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> ${message}
          </div>
        </c:if>
        <c:if test="${view == 'register' && not empty error}">
          <div class="alert alert-danger">${error}</div>
        </c:if>

        <form id="registerForm" action="register" method="post">
          <div class="form-group">
            <label for="registerUsername">Tên đăng nhập (ID)</label> <input
            type="text" class="form-control" id="registerUsername"
            name="username" <%-- Thêm 'name' --%> placeholder="Nhập tên đăng
            nhập (ví dụ: teonv)" required value="${param.username}" <%-- Giữ lại
            giá trị khi lỗi --%> />
          </div>

          <div class="form-group">
            <label for="registerName">Họ và Tên</label> <input type="text"
            class="form-control" id="registerName" name="fullname" <%-- Sửa
            'name' --%> placeholder="Nhập tên" required
            value="${param.fullname}" <%-- Giữ lại giá trị khi lỗi --%> />
          </div>

          <div class="form-group">
            <label for="registerEmail">Email</label> <input type="email"
            class="form-control" id="registerEmail" name="email" <%-- Thêm
            'name' --%> placeholder="Nhập email" required value="${param.email}"
            <%-- Giữ lại giá trị khi lỗi --%> />
          </div>

          <div class="form-group">
            <label for="registerPassword">Mật khẩu</label> <input
            type="password" class="form-control" id="registerPassword"
            name="password" <%-- Thêm 'name' --%> placeholder="Nhập mật khẩu
            (tối thiểu 6 ký tự)" required />
            
          </div>

          <div class="form-group">
            <label for="registerConfirm">Xác nhận mật khẩu</label> <input
            type="password" class="form-control" id="registerConfirm"
            name="confirmPassword" <%-- Sửa 'name' --%> placeholder="Nhập lại
            mật khẩu" required />
          </div>

          <!-- 	<div class="form-check">
					<input type="checkbox" id="agreeTerms" name="agreeTerms" required />
					<label for="agreeTerms">Tôi đồng ý với điều khoản sử dụng</label>
				</div> -->

          <button type="submit" class="btn-primary">Đăng Ký</button>
        </form>

        <div class="toggle-section">
          Đã có tài khoản? <a onclick="switchForm('login')">Đăng nhập</a>
        </div>
      </div>

      <div class="form-section" id="forgotSection">
        <h2>Quên Mật Khẩu</h2>
        <p>Nhập email hoặc tên đăng nhập để đặt lại mật khẩu</p>

        <c:if test="${view == 'forgot' && not empty message}">
          <div class="alert alert-success">
            <i class="fas fa-check-circle"></i> ${message}
          </div>
        </c:if>
        <c:if test="${view == 'forgot' && not empty error}">
          <div class="alert alert-danger">${error}</div>
        </c:if>

        <form id="forgotForm" action="forgot-password" method="post">
          <div class="form-group">
            <label for="forgotEmail">Email hoặc Tên đăng nhập</label>
            <input
              type="text"
              class="form-control"
              id="forgotEmail"
              name="emailOrUsername"
              placeholder="Nhập email hoặc tên đăng nhập"
              required
              value="${param.emailOrUsername}"
            />
          </div>

          <button type="submit" class="btn-primary">
            Gửi Hướng Dẫn Đặt Lại
          </button>
        </form>

        <div class="toggle-section">
          <a onclick="switchForm('login')">Quay lại Đăng Nhập</a>
          <br />
          Chưa có tài khoản? <a onclick="switchForm('register')">Đăng ký</a>
        </div>
      </div>
    </div>

    <script>
 // [SỬA LẠI] Hàm này giờ sẽ xử lý 3 form
    window.switchForm = function(form) {
        document.getElementById("loginSection").classList.remove("active");
        document.getElementById("registerSection").classList.remove("active");
        document.getElementById("forgotSection").classList.remove("active"); // <-- Thêm mới

        if (form === "login") {
            document.getElementById("loginSection").classList.add("active");
        } else if (form === "register") {
            document.getElementById("registerSection").classList.add("active");
        } else if (form === "forgot") { // <-- Thêm mới
            document.getElementById("forgotSection").classList.add("active");
        }
    };

    // [SỬA LẠI] Script này sẽ tự động active đúng form
    // khi Servlet forward về
    document.addEventListener("DOMContentLoaded", function() {
        
        // 1. Kiểm tra sự tồn tại của các form (ĐÂY LÀ KHỐI CHẨN ĐOÁN)
        const login = document.getElementById("loginSection");
        const register = document.getElementById("registerSection");
        const forgot = document.getElementById("forgotSection");

        if (!login || !register || !forgot) {
            console.error("LỖI CẤU TRÚC HTML: Một trong các ID (loginSection, registerSection, forgotSection) KHÔNG TỒN TẠI trong auth.jsp.");
            console.error("VUI LÒNG KIỂM TRA LẠI CHÍNH TẢ ID CỦA CÁC DIV FORM!");
            return; // Dừng lại để không chạy tiếp
        }
        
        // 2. Nếu mọi thứ tồn tại, chạy switchForm
        const viewToShow = "${view}" || "login"; 
        window.switchForm(viewToShow);
    });</script>
  </body>
</html>
