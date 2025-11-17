<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Đổi Mật Khẩu Bắt Buộc</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link href="<c:url value='/assets/css/auth.css'/>" rel="stylesheet" />
</head>
<body>
	<div class="auth-container">
		<div class="form-section active" id="changePassSection">
			<h2>Tạo Mật khẩu mới</h2>
			<p>Vì lý do bảo mật, bạn phải tạo mật khẩu mới.</p>

			<c:if test="${not empty error}">
				<div class="alert alert-danger">${error}</div>
			</c:if>

			<form id="changePassForm" action="force-change-password" method="post">
				<div class="form-group">
					<label>Mật khẩu hiện tại (Nhận từ email)</label> 
					<input type="password" class="form-control" name="currentPassword" required />
				</div>
				<div class="form-group">
					<label>Mật khẩu mới</label> 
					<input type="password" class.form-control" name="newPassword" required />
				</div>
				<div class="form-group">
					<label>Xác nhận mật khẩu mới</label> 
					<input type="password" class="form-control" name="confirmNewPassword" required />
				</div>
				<button type="submit" class="btn-primary">Lưu mật khẩu mới</button>
			</form>
            
            <div class="toggle-section">
                <a href="<c:url value='/logout'/>">Đăng xuất</a>
            </div>
		</div>
	</div>
</body>
</html>