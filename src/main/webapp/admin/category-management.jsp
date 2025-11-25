<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản Lý Thể Loại</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/animations.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/components.css'/>" rel="stylesheet" /> 

    <style>
        .main-content { color: #ffffff; }
        .admin-header { font-size: 24px; font-weight: 600; padding-bottom: 20px; border-bottom: 1px solid #272727; margin-bottom: 24px; }
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
        <h2 class="admin-header">QUẢN LÝ THỂ LOẠI</h2>

        <c:if test="${not empty message}">
            <div class="alert alert-success" style="background-color: #d4edda; color: #155724; margin-bottom: 16px;">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; margin-bottom: 16px;">${error}</div>
        </c:if>

        <div class="admin-layout">
            
            <div class="admin-form-col">
                <div class="admin-form">
                    <c:set var="formAction" value="${empty category.id ? 'create' : 'update'}" />
                    
                    <form action="<c:url value='/admin/categories'/>" method="post">
                        <input type="hidden" name="action" value="${formAction}" />
                        
                        <div class="form-group">
                            <label>CATEGORY ID?</label>
                            <input type="text" class="form-control" name="id" value="${category.id}"
                                ${empty category.id ? '' : 'readonly'}
                                placeholder="Ví dụ: music, game, sport...">
                        </div>
                        <div class="form-group">
                            <label>CATEGORY NAME?</label>
                            <input type="text" class="form-control" name="name" value="${category.name}"
                                placeholder="Ví dụ: Âm nhạc, Game, Thể thao...">
                        </div>
                        
                        <div>
                            <button class="btn btn-admin-primary" ${empty category.id ? '' : 'disabled'}>Create</button>
                            <button class="btn btn-admin-primary" ${empty category.id ? 'disabled' : ''}>Update</button>
                            <button formaction="<c:url value='/admin/categories?action=delete&id=${category.id}'/>"
                                    class="btn btn-admin-primary" style="background-color: #555;" ${empty category.id ? 'disabled' : ''}>Delete</button>
                            <a href="<c:url value='/admin/categories'/>" class="btn btn-admin-secondary">Reset</a>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="admin-table-col">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Category ID</th>
                            <th>Category Name</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cat" items="${categoryList}">
                            <tr>
                                <td>${cat.id}</td>
                                <td>${cat.name}</td>
                                <td>
                                    <a href="<c:url value='/admin/categories?action=edit&id=${cat.id}'/>">Edit</a>
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