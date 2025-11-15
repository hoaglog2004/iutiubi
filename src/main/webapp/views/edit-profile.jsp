<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cập Nhật Tài Khoản</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" /> 

</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="main-content" id="mainContent">
        <h2 class="admin-header">CẬP NHẬT TÀI KHOẢN</h2>
        
        <div class="profile-form-wrapper">
            <div class="admin-form">
                
                <c:if test="${not empty message}">...</c:if>
                <c:if test="${not empty error}">...</c:if>

                <form action="edit-profile" method="post" enctype="multipart/form-data">
                    
                    <div class="avatar-upload-wrapper">
                        <c:set var="avatarUrl" value="${pageContext.request.contextPath}/uploads/avatars/${sessionScope.currentUser.avatar}" />
                        
                        <img id="avatarPreviewImg" 
                             src="${not empty sessionScope.currentUser.avatar ? avatarUrl : 'https://via.placeholder.com/150/0f0f0f/777777?text=' += sessionScope.currentUser.id.substring(0, 1).toUpperCase()}" 
                             alt="Avatar" class="profile-avatar-preview">
                             
                        <div class="avatar-overlay" id="avatarOverlay">
                            <i class="fas fa-camera"></i>
                            <span>Tải ảnh lên</span>
                        </div>
                    </div>
                    
                    <input type="file" id="avatarFileInput" name="avatarFile" class="file-input-hidden" accept="image/png, image/jpeg">
                    
                    <hr style="border-color: #404040;">

                    <div class="form-group">
                        <label>USERNAME?</label>
                        <input type="text" class="form-control" name="username"
                               value="${sessionScope.currentUser.id}" readonly>
                    </div>
                    <div class="form-group">
                        <label>PASSWORD?</label>
                        <input type="password" class="form-control"
                               value="********" readonly>
                    </div>
                    <div class="form-group">
                        <label>EMAIL ADDRESS?</label>
                        <input type="email" class="form-control" name="email"
                               value="${sessionScope.currentUser.email}" readonly>
                    </div>

                    <div class="form-group">
                        <label>FULLNAME?</label>
                        <input type="text" class="form-control" name="fullname"
                               value="${sessionScope.currentUser.fullname}" required>
                    </div>
                    
                    <button type="submit" class="btn-update">UPDATE PROFILE</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>