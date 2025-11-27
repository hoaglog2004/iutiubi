<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản Lý Thể Loại</title>
    
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
    </style>
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    
    <div class="d-flex">
        <jsp:include page="/common/sidebar.jsp"/>

        <div class="flex-grow-1 main-content" id="mainContent">
            
            <!-- Header Section -->
            <div class="page-header">
                <h2 class="page-title"><i class="fas fa-tags me-2"></i>Quản Lý Thể Loại</h2>
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
                        <c:set var="formAction" value="${empty category.id ? 'create' : 'update'}" />
                        
                        <form action="<c:url value='/admin/categories'/>" method="post">
                            <input type="hidden" name="action" value="${formAction}" />
                            
                            <div class="mb-3">
                                <label class="form-label">Category ID</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fas fa-hashtag"></i></span>
                                    <input type="text" class="form-control custom-input" name="id" value="${category.id}"
                                        ${empty category.id ? '' : 'readonly'}
                                        placeholder="Ví dụ: music, game, sport...">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Tên Thể Loại</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fas fa-folder"></i></span>
                                    <input type="text" class="form-control custom-input" name="name" value="${category.name}"
                                        placeholder="Ví dụ: Âm nhạc, Game, Thể thao...">
                                </div>
                            </div>
                            
                            <!-- ACTION BUTTONS -->
                            <div class="action-bar">
                                <c:choose>
                                    <c:when test="${empty category.id}">
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
                                        
                                        <button type="submit" formaction="<c:url value='/admin/categories?action=delete&id=${category.id}'/>" 
                                                class="btn btn-custom btn-delete-custom" onclick="return confirm('Bạn có chắc muốn xóa thể loại này?');">
                                            <i class="fas fa-trash-alt"></i> Xóa
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Nút Reset luôn hiện -->
                                <a href="<c:url value='/admin/categories'/>" class="btn btn-custom btn-outline-custom btn-reset-full">
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
                                    <th width="30%">Category ID</th>
                                    <th>Tên Thể Loại</th>
                                    <th width="15%">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cat" items="${categoryList}">
                                    <tr>
                                        <td class="text-secondary font-monospace">${cat.id}</td>
                                        <td>${cat.name}</td>
                                        <td>
                                            <a href="<c:url value='/admin/categories?action=edit&id=${cat.id}'/>" 
                                               class="btn btn-sm btn-outline-light border-0">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button class="btn btn-sm btn-outline-danger border-0 btn-delete-category" 
                                                    data-id="${cat.id}"
                                                    data-name="${cat.name}">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <!-- Empty State handling -->
                                <c:if test="${empty categoryList}">
                                    <tr>
                                        <td colspan="3" class="text-center py-5 text-muted">
                                            <i class="fas fa-folder-open fa-3x mb-3"></i><br>
                                            Chưa có thể loại nào trong hệ thống.
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
    
    <script>
document.addEventListener('DOMContentLoaded', function() {
    
    // ===== XỬ LÝ FORM SUBMIT BẰNG AJAX =====
    const categoryForm = document.querySelector('form');
    
    categoryForm.addEventListener('submit', function(e) {
        e.preventDefault(); // Ngăn submit bình thường
        
        const formData = new FormData(this);
        const action = formData.get('action');
        
        // Hiển thị loading
        showLoading(true);
        
        fetch('<c:url value="/admin/categories"/>', {
            method: 'POST',
            body: formData
        })
        .then(response => response.text())
        .then(html => {
            showLoading(false);
            
            // Parse HTML response
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            
            // Cập nhật bảng
            const newTableContainer = doc.querySelector('.custom-table-container');
            if (newTableContainer) {
                document.querySelector('.custom-table-container').innerHTML = newTableContainer.innerHTML;
                
                // Re-attach event listeners cho các nút xóa mới
                attachDeleteHandlers();
            }
            
            // Kiểm tra và hiển thị thông báo
            const successMsg = doc.querySelector('.alert-success');
            const errorMsg = doc.querySelector('.alert-danger');
            
            if (successMsg) {
                showAlert('success', successMsg.textContent.trim());
                
                // Reset form nếu là create thành công
                if (action === 'create') {
                    categoryForm.reset();
                }
            }
            
            if (errorMsg) {
                showAlert('danger', errorMsg.textContent.trim());
            }
        })
        .catch(err => {
            showLoading(false);
            showAlert('danger', 'Lỗi kết nối: ' + err.message);
        });
    });
    
    // ===== XỬ LÝ NÚT XÓA BẰNG AJAX =====
    function attachDeleteHandlers() {
        document.querySelectorAll('.btn-delete-category').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                
                const id = this.dataset.id;
                const name = this.dataset.name;
                
                if (!confirm('Bạn có chắc muốn xóa thể loại "' + name + '"?')) {
                    return;
                }
                
                showLoading(true);
                
                const formData = new FormData();
                formData.append('action', 'delete');
                formData.append('id', id);
                
                fetch('<c:url value="/admin/categories"/>', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.text())
                .then(html => {
                    showLoading(false);
                    
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    
                    // Cập nhật bảng
                    const newTableContainer = doc.querySelector('.custom-table-container');
                    if (newTableContainer) {
                        document.querySelector('.custom-table-container').innerHTML = newTableContainer.innerHTML;
                        attachDeleteHandlers();
                    }
                    
                    // Hiển thị thông báo
                    const successMsg = doc.querySelector('.alert-success');
                    const errorMsg = doc.querySelector('.alert-danger');
                    
                    if (successMsg) {
                        showAlert('success', successMsg.textContent.trim());
                    }
                    if (errorMsg) {
                        showAlert('danger', errorMsg.textContent.trim());
                    }
                })
                .catch(err => {
                    showLoading(false);
                    showAlert('danger', 'Lỗi kết nối: ' + err.message);
                });
            });
        });
    }
    
    // Khởi tạo event handlers cho các nút xóa
    attachDeleteHandlers();
    
    // ===== HÀM HIỂN THỊ ALERT =====
    function showAlert(type, message) {
        // Xóa các alert cũ
        document.querySelectorAll('.alert').forEach(alert => alert.remove());
        
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-' + type + ' d-flex align-items-center alert-dismissible fade show';
        alertDiv.setAttribute('role', 'alert');
        alertDiv.innerHTML = 
            '<i class="fas fa-' + (type === 'success' ? 'check' : 'exclamation') + '-circle me-2"></i> ' +
            message +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
        
        const container = document.querySelector('.row.g-4');
        container.insertBefore(alertDiv, container.firstChild);
        
        // Tự động ẩn sau 5 giây
        setTimeout(() => {
            alertDiv.classList.remove('show');
            setTimeout(() => alertDiv.remove(), 150);
        }, 5000);
    }
    
    // ===== HÀM HIỂN THỊ LOADING =====
    function showLoading(show) {
        let loader = document.querySelector('.ajax-loader');
        
        if (show) {
            if (!loader) {
                loader = document.createElement('div');
                loader.className = 'ajax-loader';
                loader.innerHTML = '<div class="spinner-border text-light" role="status"><span class="visually-hidden">Loading...</span></div>';
                document.body.appendChild(loader);
            }
            loader.style.display = 'flex';
        } else {
            if (loader) {
                loader.style.display = 'none';
            }
        }
    }
});
</script>

<style>
/* Loading overlay */
.ajax-loader {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.7);
    display: none;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

/* Alert animation */
.alert {
    animation: slideDown 0.3s ease-out;
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>
</body>
</html>