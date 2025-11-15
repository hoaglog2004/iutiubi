<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đổi Mật Khẩu</title>
    
    <style>
        .main-content { color: #ffffff; }
        .admin-header {
            font-size: 24px;
            font-weight: 600;
            padding-bottom: 20px;
            border-bottom: 1px solid #272727;
            margin-bottom: 24px;
        }
        .admin-form-wrapper {
            max-width: 600px;
            margin: 0 auto;
        }
        .admin-form { background-color: #1a1a1a; padding: 24px; border-radius: 12px; }
        .admin-form .form-group { margin-bottom: 16px; }
        .admin-form label { display: block; color: #aaaaaa; font-size: 14px; font-weight: 500; margin-bottom: 8px; }
        .admin-form .form-control {
            background-color: #272727; border: 1px solid #404040; color: #ffffff;
            border-radius: 8px; width: 100%; padding: 10px 14px; font-size: 14px;
        }
        .admin-form .form-control:focus { outline: none; border-color: #ff0000; box-shadow: 0 0 0 3px rgba(255, 0, 0, 0.2); }
        .admin-form .form-control[readonly] { background-color: #222; color: #777; }
        .admin-form .btn-admin-primary {
            background-color: #ff0000; color: #ffffff; border: none; padding: 10px 16px;
            border-radius: 20px; font-weight: 600; font-size: 14px; cursor: pointer;
            transition: all 0.2s; width: 100%;
        }
        .admin-form .btn-admin-primary:hover { background-color: #cc0000; }
    </style>
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="main-content" id="mainContent">
        <h2 class="admin-header">ĐỔI MẬT KHẨU</h2>
        
        <div class="admin-form-wrapper">
            <div class="admin-form">
                
                <c:if test="${not empty message}">
                    <div class="alert alert-success" style="background-color: #d4edda; color: #155724; margin-bottom: 16px;">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; margin-bottom: 16px;">${error}</div>
                </c:if>

                <form action="change-password" method="post">
                    <div class="form-group">
                        <label>USERNAME?</label>
                        <input type="text" class="form-control" name="username"
                               value="${sessionScope.currentUser.id}" readonly>
                    </div>
                    <div class="form-group">
                        <label>CURRENT PASSWORD?</label>
                        <input type="password" class="form-control" name="currentPassword" required>
                    </div>
                    <div class="form-group">
                        <label>NEW PASSWORD?</label>
                        <input type="password" class="form-control" name="newPassword" required>
                    </div>
                    <div class="form-group">
                        <label>CONFIRM NEW PASSWORD?</label>
                        <input type="password" class="form-control" name="confirmNewPassword" required>
                    </div>
                    <button type="submit" class="btn btn-admin-primary">Change</button>
                </form>
            </div>
        </div>

    </div>
    
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>