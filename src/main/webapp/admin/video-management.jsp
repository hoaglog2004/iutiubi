<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Quản Lý Video</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" /> 

<style>
/* (Giữ nguyên toàn bộ CSS của bạn) */
.main-content { color: #ffffff; }
.admin-header { font-size: 24px; font-weight: 600; padding-bottom: 20px; border-bottom: 1px solid #272727; margin-bottom: 24px; }
.admin-layout { display: flex; gap: 24px; }
.admin-form-col { flex: 1; max-width: 450px; }
.admin-table-col { flex: 2; }
.admin-form { background-color: #1a1a1a; padding: 24px; border-radius: 12px; }
.admin-form .form-group { margin-bottom: 16px; }
.admin-form label { display: block; color: #aaaaaa; font-size: 14px; font-weight: 500; margin-bottom: 8px; }
.admin-form .form-control { background-color: #272727; border: 1px solid #404040; color: #ffffff; border-radius: 8px; width: 100%; padding: 10px 14px; font-size: 14px; }
.admin-form .form-control:focus { outline: none; border-color: #ff0000; box-shadow: 0 0 0 3px rgba(255, 0, 0, 0.2); }
.admin-form .form-check-label { color: #ffffff; margin-left: 8px; }
.admin-form .btn { border: none; padding: 10px 16px; border-radius: 20px; font-weight: 600; font-size: 14px; margin-right: 8px; cursor: pointer; transition: all 0.2s; }
.btn-admin-primary { background-color: #ff0000; color: #ffffff; }
.btn-admin-primary:hover { background-color: #cc0000; }
.btn-admin-secondary { background-color: #272727; color: #ffffff; }
.btn-admin-secondary:hover { background-color: #3a3a3a; }
.btn:disabled { opacity: 0.5; cursor: not-allowed; }
.admin-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.admin-table th, .admin-table td { padding: 12px 10px; text-align: left; border-bottom: 1px solid #272727; }
.admin-table th { color: #aaaaaa; font-weight: 600; }
.admin-table td { color: #ffffff; }
.admin-table a { color: #ff0000; text-decoration: none; font-weight: 600; }
.admin-table a:hover { text-decoration: underline; }
@media ( max-width : 992px) {
    .admin-layout { flex-direction: column; }
    .admin-form-col { max-width: 100%; }
}
</style>
</head>
<body>

	<jsp:include page="/common/header.jsp" />
	<jsp:include page="/common/sidebar.jsp" />

	<div class="main-content" id="mainContent">
		<h2 class="admin-header">QUẢN LÝ VIDEO</h2>
        
        <c:if test="${not empty message}">
            <div class="alert alert-success" style="background-color: #d4edda; color: #155724; margin-bottom: 16px;">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; margin-bottom: 16px;">${error}</div>
        </c:if>

		<div class="admin-layout">
			<div class="admin-form-col">
				<div class="admin-form">
					<c:set var="formAction"
						value="${empty video.id ? 'create' : 'update'}" />
					<form action="<c:url value='/admin/videos?action=${formAction}'/>"
						method="post">
						<div class="form-group">
							<label>YOUTUBE ID?</label> <input type="text"
								class="form-control" name="id" value="${video.id}"
								${empty video.id ? '' : 'readonly'}>
						</div>
						<div class="form-group">
							<label>VIDEO TITLE?</label> <input type="text"
								class="form-control" name="title" value="${video.title}">
						</div>
						<div class="form-group">
							<label>VIEW COUNT?</label> <input type="number"
								class="form-control" name="views" value="${video.views}">
						</div>
						
						<div class="form-group">
							<label>DESCRIPTION?</label>
							<textarea class="form-control" name="description" rows="3">${video.description}</textarea>
						</div>
						<div class="form-group">
							<label>STATUS?</label>
							<div class="form-check form-check-inline">
								<input class="form-check-input" type="radio" name="active"
									id="active" value="true" ${video.active ? 'checked' : ''}>
								<label class="form-check-label" for="active">Active</label>
							</div>
							<div class="form-check form-check-inline">
								<input class="form-check-input" type="radio" name="active"
									id="inactive" value="false" ${video.active ? '' : 'checked'}>
								<label class="form-check-label" for="inactive">Inactive</label>
							</div>
						</div>
						<div class="form-group">
                            <label>CATEGORY?</label>
                            <select name="categoryId" class="form-control">
                                <option value="">-- Chọn thể loại --</option>
                                <c:forEach var="cat" items="${categoryList}">
                                    <option value="${cat.id}" 
                                        ${video.category.id == cat.id ? 'selected' : ''}>
                                        ${cat.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
						
						<div class="admin-button-group" style="margin-top: 20px;">
						    
						    <button type="submit" class="btn btn-admin-primary" ${empty video.id ? '' : 'disabled'}>
							    <i class="fas fa-plus"></i> Create
							</button>
							
							<button type="submit" class="btn btn-admin-primary" ${empty video.id ? 'disabled' : ''}>
	                            <i class="fas fa-save"></i> Update
	                        </button>
	                        
	                        <button type="submit" formaction="<c:url value='/admin/videos?action=delete&id=${video.id}'/>"
	                                class="btn btn-admin-primary" style="background-color: #555;" ${empty video.id ? 'disabled' : ''}>
	                             <i class="fas fa-trash"></i> Delete
	                        </button>
	                        
	                        <a href="<c:url value='/admin/videos'/>" class="btn btn-admin-secondary">
	                             <i class="fas fa-undo"></i> Reset
	                        </a>
						</div>
					</form>
				</div>
			</div>

			<div class="admin-table-col">
				<table class="admin-table">
					<thead>
                        <tr>
                            <th>Youtube ID</th>
                            <th>Title</th>
                            <th>Views</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="v" items="${videoList}">
                            <tr>
                                <td>${v.id}</td>
                                <td>${v.title}</td>
                                <td>${v.views}</td>
                                <td>${v.active ? 'Active' : 'Inactive'}</td>
                                <td>
                                    <a href="<c:url value='/admin/videos?action=edit&id=${v.id}'/>">Edit</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
				</table>
			</div>
		</div>
	</div>

	<script src="<c:url value='/assets/js/app.js'/>"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>