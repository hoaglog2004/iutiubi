<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập Thành Công - Iutiubi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .success-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            text-align: center;
        }
        .avatar-container {
            margin-bottom: 25px;
        }
        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #667eea;
            box-shadow: 0 5px 15px rgba(102,126,234,0.3);
        }
        .avatar-placeholder {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
        }
        .avatar-placeholder i {
            font-size: 50px;
            color: white;
        }
        .welcome-text {
            color: #333;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .user-name {
            color: #667eea;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 20px;
        }
        .user-info {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            text-align: left;
        }
        .info-row {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }
        .info-icon i {
            color: white;
            font-size: 18px;
        }
        .info-icon.email {
            background: #ea4335;
        }
        .info-icon.provider {
            background: #34a853;
        }
        .info-icon.id {
            background: #4285f4;
        }
        .info-label {
            color: #888;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .info-value {
            color: #333;
            font-size: 14px;
            font-weight: 500;
            word-break: break-all;
        }
        .provider-badge {
            display: inline-flex;
            align-items: center;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 20px;
        }
        .provider-badge i {
            margin-right: 8px;
            font-size: 16px;
        }
        .provider-google {
            background: #fff5f5;
            color: #ea4335;
            border: 1px solid #ea4335;
        }
        .provider-facebook {
            background: #f0f7ff;
            color: #1877f2;
            border: 1px solid #1877f2;
        }
        .provider-github {
            background: #f6f8fa;
            color: #24292e;
            border: 1px solid #24292e;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-home:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
            color: white;
        }
        .btn-logout {
            background: #f8f9fa;
            color: #666;
            padding: 12px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 1px solid #ddd;
        }
        .btn-logout:hover {
            background: #e9ecef;
            color: #333;
        }
        .success-icon {
            background: linear-gradient(135deg, #00c853 0%, #00e676 100%);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        .success-icon i {
            color: white;
            font-size: 30px;
        }
    </style>
</head>
<body>
    <div class="success-card">
        <c:choose>
            <c:when test="${not empty sessionScope.socialUser}">
                <div class="success-icon">
                    <i class="fas fa-check"></i>
                </div>
                
                <div class="avatar-container">
                    <c:choose>
                        <c:when test="${not empty sessionScope.socialUser.avatarUrl}">
                            <img src="${sessionScope.socialUser.avatarUrl}" alt="Avatar" class="avatar">
                        </c:when>
                        <c:otherwise>
                            <div class="avatar-placeholder">
                                <i class="fas fa-user"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <p class="welcome-text">Chào mừng bạn đến với Iutiubi!</p>
                <h2 class="user-name">${sessionScope.socialUser.name}</h2>
                
                <!-- Provider Badge -->
                <c:choose>
                    <c:when test="${sessionScope.socialUser.provider == 'google'}">
                        <span class="provider-badge provider-google">
                            <i class="fab fa-google"></i> Google Account
                        </span>
                    </c:when>
                    <c:when test="${sessionScope.socialUser.provider == 'facebook'}">
                        <span class="provider-badge provider-facebook">
                            <i class="fab fa-facebook-f"></i> Facebook Account
                        </span>
                    </c:when>
                    <c:when test="${sessionScope.socialUser.provider == 'github'}">
                        <span class="provider-badge provider-github">
                            <i class="fab fa-github"></i> GitHub Account
                        </span>
                    </c:when>
                </c:choose>
                
                <div class="user-info">
                    <div class="info-row">
                        <div class="info-icon email">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div>
                            <div class="info-label">Email</div>
                            <div class="info-value">
                                ${not empty sessionScope.socialUser.email ? sessionScope.socialUser.email : 'Không có'}
                            </div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-icon provider">
                            <i class="fas fa-link"></i>
                        </div>
                        <div>
                            <div class="info-label">Provider</div>
                            <div class="info-value">${sessionScope.socialUser.provider}</div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-icon id">
                            <i class="fas fa-fingerprint"></i>
                        </div>
                        <div>
                            <div class="info-label">User ID</div>
                            <div class="info-value">${sessionScope.socialUser.id}</div>
                        </div>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <a href="<c:url value='/home'/>" class="btn-home">
                        <i class="fas fa-home"></i> Trang chủ
                    </a>
                    <a href="<c:url value='/oauth2/logout'/>" class="btn-logout">
                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="avatar-placeholder" style="margin-bottom: 25px;">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h2 class="welcome-text">Chưa đăng nhập</h2>
                <p style="color: #666; margin-bottom: 25px;">
                    Bạn chưa đăng nhập hoặc phiên đăng nhập đã hết hạn.
                </p>
                <a href="<c:url value='/login.jsp'/>" class="btn-home">
                    <i class="fas fa-sign-in-alt"></i> Đăng nhập ngay
                </a>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
