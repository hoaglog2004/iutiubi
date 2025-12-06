<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Iutiubi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="<c:url value='/assets/css/auth.css'/>" rel="stylesheet">
    <style>
        .social-login-section {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }
        .social-login-section h5 {
            color: #666;
            margin-bottom: 20px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .social-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 12px 20px;
            margin-bottom: 10px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }
        .social-btn i {
            margin-right: 10px;
            font-size: 20px;
        }
        .btn-google {
            background-color: #fff;
            color: #757575;
            border: 1px solid #ddd;
        }
        .btn-google:hover {
            background-color: #f8f9fa;
            color: #333;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .btn-facebook {
            background-color: #1877f2;
            color: white;
        }
        .btn-facebook:hover {
            background-color: #166fe5;
            box-shadow: 0 2px 8px rgba(24,119,242,0.3);
        }
        .btn-github {
            background-color: #24292e;
            color: white;
        }
        .btn-github:hover {
            background-color: #1a1e22;
            box-shadow: 0 2px 8px rgba(36,41,46,0.3);
        }
        .divider {
            display: flex;
            align-items: center;
            margin: 20px 0;
        }
        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px solid #ddd;
        }
        .divider span {
            padding: 0 15px;
            color: #888;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="form-section active">
            <h2>Đăng Nhập</h2>
            <p>Chào mừng quay lại Iutiubi!</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${message}
                </div>
            </c:if>

            <!-- Social Login Buttons -->
            <div class="social-login-section">
                <h5 class="text-center">Đăng nhập với mạng xã hội</h5>
                
                <a href="<c:url value='/oauth2/google'/>" class="social-btn btn-google">
                    <i class="fab fa-google"></i> Tiếp tục với Google
                </a>
                
                <a href="<c:url value='/oauth2/facebook'/>" class="social-btn btn-facebook">
                    <i class="fab fa-facebook-f"></i> Tiếp tục với Facebook
                </a>
                
                <a href="<c:url value='/oauth2/github'/>" class="social-btn btn-github">
                    <i class="fab fa-github"></i> Tiếp tục với GitHub
                </a>
            </div>

            <div class="divider">
                <span>hoặc</span>
            </div>

            <!-- Traditional Login Form -->
            <form id="loginForm" action="<c:url value='/login'/>" method="post">
                <div class="form-group">
                    <label for="loginUsername">Tên đăng nhập hoặc Email</label>
                    <input type="text" class="form-control" id="loginUsername" 
                           name="username" placeholder="Nhập tên đăng nhập hoặc email" required
                           value="${param.username}">
                </div>

                <div class="form-group">
                    <label for="loginPassword">Mật khẩu</label>
                    <input type="password" class="form-control" id="loginPassword" 
                           name="password" placeholder="Nhập mật khẩu" required>
                </div>

                <div class="form-check">
                    <input type="checkbox" id="rememberMe" name="rememberMe" 
                           value="true" class="form-check-input">
                    <label for="rememberMe" class="form-check-label">Ghi nhớ tôi</label>
                </div>

                <button type="submit" class="btn-primary">Đăng Nhập</button>
            </form>

            <div class="toggle-section">
                Chưa có tài khoản? <a href="<c:url value='/register'/>">Đăng ký</a>
                <br>
                <a href="<c:url value='/forgot-password'/>">Quên mật khẩu?</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
