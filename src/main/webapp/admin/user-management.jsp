<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản Lý User</title>
    
    <!-- Bootstrap 5 & Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <!-- Custom CSS Path -->
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/animations.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/components.css'/>" rel="stylesheet" /> 

    <style>
        :root {
            --bg-dark: #121212;
            --bg-card: #1e1e1e;
            --text-primary: #e0e0e0;
            --text-secondary: #a0a0a0;
            --accent-color: #ff4757;
            --accent-hover: #ff6b81;
            --border-color: #333;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Roboto, sans-serif;
        }

        .main-content {
            padding: 2rem;
        }

        /* Header Styling */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: #fff;
            margin: 0;
        }

        /* Card Styling */
        .glass-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.2);
            padding: 1.5rem;
            height: 100%;
            transition: transform 0.2s;
        }

        /* Form Styling */
        .form-label {
            color: var(--text-secondary);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .custom-input {
            background-color: #2c2c2c;
            border: 1px solid var(--border-color);
            color: #fff;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .custom-input:focus {
            background-color: #333;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 4px rgba(255, 71, 87, 0.15);
            color: #fff;
        }
        
        .custom-input:disabled,
        .custom-input[readonly] {
            background-color: #252525;
            color: #666;
        }

        /* Button Styling - UX Improved */
        .action-bar {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-top: 2rem;
        }

        .btn-custom {
            padding: 0.75rem;
            border-radius: 8px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s;
            border: none;
        }

        .btn-primary-custom {
            background: linear-gradient(45deg, var(--accent-color), #ff6b81);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 71, 87, 0.3);
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(255, 71, 87, 0.4);
            color: white;
        }

        .btn-outline-custom {
            background: transparent;
            border: 1px solid #555;
            color: var(--text-secondary);
        }

        .btn-outline-custom:hover {
            background: #333;
            color: #fff;
            border-color: #fff;
        }

        .btn-delete-custom {
            background: #2c2c2c;
            color: #ff4757;
            border: 1px solid rgba(255, 71, 87, 0.2);
        }

        .btn-delete-custom:hover {
            background: rgba(255, 71, 87, 0.1);
            border-color: var(--accent-color);
        }
        
        .btn-reset-full {
            grid-column: span 2;
            margin-top: 5px;
        }

        /* Table Styling */
        .custom-table-container {
            overflow-x: auto;
        }
        
        .custom-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px;
        }

        .custom-table th {
            color: var(--text-secondary);
            font-weight: 600;
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .custom-table td {
            background-color: #252525;
            padding: 1rem;
            vertical-align: middle;
            color: #fff;
            border-top: 1px solid transparent;
            border-bottom: 1px solid transparent;
        }

        .custom-table td:first-child { border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
        .custom-table td:last-child { border-top-right-radius: 8px; border-bottom-right-radius: 8px; }

        .custom-table tr:hover td {
            background-color: #2a2a2a;
            transform: scale(1.005);
            transition: transform 0.2s;
        }

        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .status-admin { background-color: rgba(255, 71, 87, 0.15); color: #ff4757; }
        .status-user { background-color: rgba(46, 213, 115, 0.15); color: #2ed573; }
    </style>
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    
    <div class="d-flex">
        <jsp:include page="/common/sidebar.jsp"/>

        <div class="flex-grow-1 main-content" id="mainContent">
            
            <!-- Header Section -->
            <div class="page-header">
                <h2 class="page-title"><i class="fas fa-users me-2"></i>Quản Lý User</h2>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty message}">
                <div class="alert alert-success d-flex align-items-center" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${message}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i> ${error}
                </div>
            </c:if>

            <div class="row g-4">
                <!-- FORM COLUMN (Left) -->
                <div class="col-lg-4 col-md-12">
                    <div class="glass-card sticky-top" style="top: 20px; z-index: 1;">
                        <c:set var="formAction" value="${empty user.id ? 'create' : 'update'}" />
                        
                        <form action="<c:url value='/admin/users?action=${formAction}'/>" method="post">
                            
                            <div class="mb-3">
                                <label class="form-label">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control custom-input" name="id" value="${user.id}"
                                        ${empty user.id ? '' : 'readonly'}
                                        placeholder="Nhập username...">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Họ và Tên</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fas fa-id-card"></i></span>
                                    <input type="text" class="form-control custom-input" name="fullname" value="${user.fullname}"
                                        placeholder="Nhập họ và tên...">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fas fa-envelope"></i></span>
                                    <input type="email" class="form-control custom-input" name="email" value="${user.email}" readonly
                                        placeholder="Nhập email...">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Mật khẩu</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control custom-input" name="password" 
                                           placeholder="${empty user.id ? 'Nhập mật khẩu mới' : 'Để trống nếu không đổi'}">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label d-block">Vai trò</label>
                                <div class="btn-group w-100" role="group">
                                    <input type="radio" class="btn-check" name="admin" id="admin" value="true" ${user.admin ? 'checked' : ''} autocomplete="off">
                                    <label class="btn btn-outline-danger" for="admin"><i class="fas fa-crown me-1"></i>Admin</label>

                                    <input type="radio" class="btn-check" name="admin" id="user" value="false" ${user.admin ? '' : 'checked'} autocomplete="off">
                                    <label class="btn btn-outline-success" for="user"><i class="fas fa-user me-1"></i>User</label>
                                </div>
                            </div>
                            
                            <!-- ACTION BUTTONS -->
                            <div class="action-bar">
                                <c:choose>
                                    <c:when test="${empty user.id}">
                                        <!-- Trạng thái: Tạo mới (Chỉ hiện nút Create và Reset) -->
                                        <button type="submit" class="btn btn-custom btn-primary-custom" style="grid-column: span 2;">
                                            <i class="fas fa-plus-circle"></i> Thêm Mới
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Trạng thái: Chỉnh sửa (Hiện Update và Delete) -->
                                        <button type="submit" class="btn btn-custom btn-primary-custom">
                                            <i class="fas fa-save"></i> Lưu
                                        </button>
                                        
                                        <button type="submit" formaction="<c:url value='/admin/users?action=delete&id=${user.id}'/>" 
                                                class="btn btn-custom btn-delete-custom" onclick="return confirm('Bạn có chắc muốn xóa user này?');">
                                            <i class="fas fa-trash-alt"></i> Xóa
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Nút Reset luôn hiện -->
                                <a href="<c:url value='/admin/users'/>" class="btn btn-custom btn-outline-custom btn-reset-full">
                                    <i class="fas fa-sync-alt"></i> Làm mới
                                </a>
                            </div>

                        </form>
                    </div>
                </div>

                <!-- TABLE COLUMN (Right) -->
                <div class="col-lg-8 col-md-12">
                    <div class="custom-table-container">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th width="15%">Username</th>
                                    <th>Họ và Tên</th>
                                    <th>Email</th>
                                    <th width="12%">Vai trò</th>
                                    <th width="10%">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${userList}">
                                    <tr>
                                        <td class="text-secondary font-monospace">${u.id}</td>
                                        <td>${u.fullname}</td>
                                        <td>${u.email}</td>
                                        <td>
                                            <span class="status-badge ${u.admin ? 'status-admin' : 'status-user'}">
                                                ${u.admin ? 'Admin' : 'User'}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="<c:url value='/admin/users?action=edit&id=${u.id}'/>" 
                                               class="btn btn-sm btn-outline-light border-0">
                                                <i class="fas fa-pen text-info"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <!-- Empty State handling -->
                                <c:if test="${empty userList}">
                                    <tr>
                                        <td colspan="5" class="text-center py-5 text-muted">
                                            <i class="fas fa-users fa-3x mb-3"></i><br>
                                            Chưa có user nào trong hệ thống.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/assets/js/app.js'/>"></script>
</body>
</html>