<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản Lý User</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" /> 

    <style>
        .main-content { color: #ffffff; }
        .admin-header {
            font-size: 24px; font-weight: 600; padding-bottom: 20px;
            border-bottom: 1px solid #272727; margin-bottom: 24px;
        }
        .admin-layout { display: flex; gap: 24px; }
        .admin-form-col { flex: 1; max-width: 450px; }
        .admin-table-col { flex: 2; }
        .admin-form { background-color: #1a1a1a; padding: 24px; border-radius: 12px; }
        .admin-form .form-group { margin-bottom: 16px; }
        .admin-form label { display: block; color: #aaaaaa; font-size: 14px; font-weight: 500; margin-bottom: 8px; }
        .admin-form .form-control {
            background-color: #272727; border: 1px solid #404040; color: #ffffff;
            border-radius: 8px; width: 100%; padding: 10px 14px; font-size: 14px;
        }
        .admin-form .form-control:focus { outline: none; border-color: #ff0000; box-shadow: 0 0 0 3px rgba(255, 0, 0, 0.2); }
        .admin-form .form-control[readonly] { background-color: #222; color: #777; }
        .admin-form .form-check-label { color: #ffffff; margin-left: 8px; }
        .admin-form .btn {
            border: none; padding: 10px 16px; border-radius: 20px; font-weight: 600;
            font-size: 14px; margin-right: 8px; cursor: pointer; transition: all 0.2s;
        }
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
        @media (max-width: 992px) {
            .admin-layout { flex-direction: column; }
            .admin-form-col { max-width: 100%; }
        }
    </style>
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="main-content" id="mainContent">
        <h2 class="admin-header">QUẢN LÝ USER</h2>

        <c:if test="${not empty message}">
            <div class="alert alert-success" style="background-color: #d4edda; color: #155724; margin-bottom: 16px;">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; margin-bottom: 16px;">${error}</div>
        </c:if>

        <div class="admin-layout">
            
            <div class="admin-form-col">
                <div class="admin-form">
                    <c:set var="formAction" value="${empty user.id ? 'create' : 'update'}" />
                    
                    <form action="<c:url value='/admin/users?action=${formAction}'/>" method="post">
                        <div class="form-group">
                            <label>USERNAME?</label>
                            <input type="text" class="form-control" name="id" value="${user.id}"
                                ${empty user.id ? '' : 'readonly'}>
                        </div>
                        <div class="form-group">
                            <label>FULLNAME?</label>
                            <input type="text" class="form-control" name="fullname" value="${user.fullname}">
                        </div>
                        <div class="form-group">
                            <label>EMAIL?</label>
                            <input type="email" class="form-control" name="email" value="${user.email}">
                        </div>
                        <div class="form-group">
                            <label>PASSWORD?</label>
                            <input type="password" class="form-control" name="password" 
                                   placeholder="${empty user.id ? 'Nhập mật khẩu mới' : 'Để trống nếu không đổi'}">
                        </div>
                        <div class="form-group">
                            <label>ROLE?</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="admin" id="admin" value="true" ${user.admin ? 'checked' : ''}>
                                <label class="form-check-label" for="admin">Admin</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="admin" id="user" value="false" ${user.admin ? '' : 'checked'}>
                                <label class="form-check-label" for="user">User</label>
                            </div>
                        </div>
                        
                        <div class="admin-button-group" style="margin-top: 20px;">
                            <button type="submit" class="btn btn-admin-primary" ${empty user.id ? '' : 'disabled'}>
                                <i class="fas fa-plus"></i> Create
                            </button>
                            
                            <button type="submit" class="btn btn-admin-primary" ${empty user.id ? 'disabled' : ''}>
                                <i class="fas fa-save"></i> Update
                            </button>
                            
                            <button type="submit" formaction="<c:url value='/admin/users?action=delete&id=${user.id}'/>"
                                    class="btn btn-admin-primary" style="background-color: #555;" ${empty user.id ? 'disabled' : ''}>
                                <i class="fas fa-trash"></i> Delete
                            </button>
                            
                            <a href="<c:url value='/admin/users'/>" class="btn btn-admin-secondary">
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
                            <th>Username</th>
                            <th>Fullname</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${userList}">
                            <tr>
                                <td>${u.id}</td>
                                <td>${u.fullname}</td>
                                <td>${u.email}</td>
                                <td>${u.admin ? 'Admin' : 'User'}</td>
                                <td>
                                    <a href="<c:url value='/admin/users?action=edit&id=${u.id}'/>">Edit</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>