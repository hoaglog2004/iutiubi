<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản Lý Video</title>
    
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
            --accent-color: #ff4757; /* Màu đỏ hiện đại hơn */
            --accent-hover: #ff6b81;
            --accent-primary: #667eea; /* Màu primary gradient */
            --border-color: #333;
            
            /* Layout dimensions */
            --navbar-height: 70px;
            --sidebar-width: 240px;
            --sidebar-collapsed-width: 80px;
            --sidebar-mobile-width: 60px;
            --page-header-height: 60px;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Roboto, sans-serif;
        }

        .main-content {
            padding: 2rem;
            /* Space for fixed header: navbar + page header + some margin */
            padding-top: calc(var(--page-header-height) + 20px);
        }

        /* Header Styling - Fixed position synchronized with sidebar */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding: 1rem 2rem;
            border-bottom: 1px solid var(--border-color);
            background-color: var(--bg-dark);
            position: fixed;
            top: var(--navbar-height); /* Below the main navbar */
            left: var(--sidebar-width); /* After the sidebar */
            right: 0;
            z-index: 90;
            height: var(--page-header-height);
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
        
        .custom-input:disabled {
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
            grid-column: span 2; /* Nút reset nằm ngang full */
            margin-top: 5px;
        }

        /* Table Styling */
        .custom-table-container {
            overflow-x: auto;
        }
        
        .custom-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px; /* Khoảng cách giữa các hàng */
        }

        .custom-table th {
            color: var(--text-secondary);
            font-weight: 600;
            padding: 1rem 1.5rem; /* Increased horizontal padding */
            border-bottom: 1px solid var(--border-color);
            white-space: nowrap; /* Prevent text wrapping in headers */
        }

        .custom-table td {
            background-color: #252525;
            padding: 1rem 1.5rem; /* Increased horizontal padding */
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
            white-space: nowrap; /* Prevent text wrapping */
            display: inline-block; /* Ensure proper alignment */
        }
        .status-active { background-color: rgba(46, 213, 115, 0.15); color: #2ed573; }
        .status-inactive { background-color: rgba(255, 71, 87, 0.15); color: #ff4757; }
        
        .video-title-cell {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* --- Video Manager layout tweaks (new) --- */
        .video-manager-container {
          display: flex;
          gap: 1rem;
          align-items: flex-start;
        }

        /* Panel common */
        .vm-panel {
          background: var(--bg-card);
          border: 1px solid var(--border-color);
          border-radius: 8px;
          padding: 0.75rem;
          box-shadow: 0 6px 18px rgba(0,0,0,0.35);
          height: 100%;
        }

        /* inner panel with limited height and internal scroll */
        .vm-panel-inner {
          max-height: calc(100vh - 220px); /* adjust if header/footer heights differ */
          overflow-y: auto;
          padding-right: 0.5rem;
        }

        /* Column sizing */
        .vm-left { flex: 0 0 36%; max-width: 36%; }
        .vm-right { flex: 1 1 64%; }

        .vm-table-wrapper {
          max-height: calc(100vh - 300px);
          overflow-y: auto;
        }

        /* Compact table */
        .table.vm-table thead th,
        .table.vm-table tbody td {
          padding: 0.45rem 0.6rem;
          vertical-align: middle;
          font-size: 0.9rem;
        }

        .vm-form .mb-3 { margin-bottom: 0.6rem; }

        @media (max-width: 991.98px) {
          .video-manager-container { flex-direction: column; }
          .vm-left, .vm-right { max-width: 100%; flex: 1 1 100%; }
          .vm-panel-inner { max-height: none; overflow: visible; }
          .page-header { left: var(--sidebar-collapsed-width); } /* Adjust for collapsed sidebar */
        }
        
        @media (max-width: 768px) {
          .page-header { left: var(--sidebar-mobile-width); } /* Adjust for mobile sidebar */
        }
    </style>
</head>
<body>

    <jsp:include page="/common/header.jsp" />
    
    <div class="d-flex">
        <jsp:include page="/common/sidebar.jsp" />

        <div class="flex-grow-1 main-content" id="mainContent">
            
            <!-- Header Section -->
            <div class="page-header">
                <h2 class="page-title"><i class="fas fa-video me-2"></i>Quản Lý Video</h2>
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

            <!-- New layout: left form + right list as two panels with independent scrolling -->
            <div class="video-manager-container">

                <!-- FORM COLUMN (Left) -->
                <div class="vm-left">
                    <div class="vm-panel">
                        <div class="vm-panel-inner vm-form">
                            <c:set var="formAction" value="${empty video.id ? 'create' : 'update'}" />
                            
                            <form action="<c:url value='/admin/videos?action=${formAction}'/>" method="post" enctype="multipart/form-data">
                                
                                <div class="mb-3">
                                    <label class="form-label">Youtube ID</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fab fa-youtube"></i></span>
                                        <input type="text" class="form-control custom-input" name="id" 
                                               value="${video.id}" placeholder="Ví dụ: AJDEu1-nSTI"
                                               ${empty video.id ? '' : 'readonly'}>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Tiêu đề Video</label>
                                    <input type="text" class="form-control custom-input" name="title" 
                                           value="${video.title}" placeholder="Nhập tiêu đề video...">
                                </div>
                                
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <label class="form-label">Lượt xem</label>
                                        <input type="number" class="form-control custom-input" name="views" 
                                               value="${video.views}" min="0">
                                    </div>
                                    <div class="col-6 mb-3">
                                        <label class="form-label">Danh mục</label>
                                        <select name="categoryId" class="form-select custom-input">
                                            <option value="">-- Chọn --</option>
                                            <c:forEach var="cat" items="${categoryList}">
                                                <option value="${cat.id}" ${video.category.id == cat.id ? 'selected' : ''}>
                                                    ${cat.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Mô tả</label>
                                    <textarea class="form-control custom-input" name="description" 
                                              rows="3" placeholder="Mô tả nội dung video...">${video.description}</textarea>
                                </div>

                            <div class="mb-3">
                                <label class="form-label">Thumbnail URL</label>
                                <input type="text" class="form-control custom-input" name="poster" id="posterInput"
                                       value="${video.poster}" placeholder="URL hình ảnh thumbnail (tự động tạo nếu để trống)">
                                <small class="text-muted d-block mb-2">Để trống để tự động sử dụng thumbnail từ YouTube</small>
                                
                                <!-- Thumbnail Preview -->
                                <c:choose>
                                    <c:when test="${not empty video.poster}">
                                        <div class="mt-2 position-relative" style="max-width: 200px;">
                                            <img src="${video.poster}" alt="Current thumbnail" class="thumbnail-preview"
                                                 style="width: 100%; border-radius: 8px; border: 2px solid var(--accent-primary); cursor: pointer;"
                                                 onclick="document.getElementById('posterInput').focus()"
                                                 title="Click vào URL phía trên để thay đổi thumbnail">
                                            <small class="text-info d-block mt-1"><i class="fas fa-info-circle"></i> Nhập URL mới bên trên để thay đổi</small>
                                        </div>
                                    </c:when>
                                    <c:when test="${not empty video.id}">
                                        <div class="mt-2 position-relative" style="max-width: 200px;">
                                            <img src="https://img.youtube.com/vi/<c:out value='${video.id}'/>/hqdefault.jpg" alt="Auto-generated thumbnail" class="thumbnail-preview"
                                                 style="width: 100%; border-radius: 8px; border: 2px solid #555; cursor: pointer;"
                                                 onclick="document.getElementById('posterInput').focus()"
                                                 title="Thumbnail tự động từ YouTube. Nhập URL để thay đổi">
                                            <small class="text-muted d-block mt-1"><i class="fas fa-youtube"></i> Thumbnail tự động từ YouTube</small>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </div>

                            <div class="mb-3">
                                <label class="form-label d-block">Trạng thái</label>
                                <div class="btn-group w-100" role="group">
                                    <input type="radio" class="btn-check" name="active" id="active" value="true" ${video.active ? 'checked' : ''} autocomplete="off">
                                    <label class="btn btn-outline-success" for="active">Active</label>

                                        <input type="radio" class="btn-check" name="active" id="inactive" value="false" ${video.active ? '' : 'checked'} autocomplete="off">
                                        <label class="btn btn-outline-danger" for="inactive">Inactive</label>
                                    </div>
                                </div>
                                
                                <!-- ACTION BUTTONS -->
                                <div class="action-bar">
                                    <c:choose>
                                        <c:when test="${empty video.id}">
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
                                            
                                            <button type="submit" formaction="<c:url value='/admin/videos?action=delete&id=${video.id}'/>" 
                                                    class="btn btn-custom btn-delete-custom" onclick="return confirm('Bạn có chắc muốn xóa video này?');">
                                                <i class="fas fa-trash-alt"></i> Xóa
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- Nút Reset luôn hiện -->
                                    <a href="<c:url value='/admin/videos'/>" class="btn btn-custom btn-outline-custom btn-reset-full">
                                        <i class="fas fa-sync-alt"></i> Làm mới
                                    </a>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>

                <!-- TABLE COLUMN (Right) -->
                <div class="col-lg-8 col-md-12">
                    <div class="custom-table-container">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th width="10%">Thumbnail</th>
                                    <th width="12%">Youtube ID</th>
                                    <th>Tiêu đề</th>
                                    <th width="10%" class="text-center">Views</th>
                                    <th width="12%" class="text-center">Trạng thái</th>
                                    <th width="10%" class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="v" items="${videoList}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty v.poster}">
                                                    <img src="${v.poster}" alt="Thumbnail" 
                                                         style="width: 80px; height: 60px; object-fit: cover; border-radius: 4px;">
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="width: 80px; height: 60px; background: #333; border-radius: 4px; display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-video text-muted"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-secondary font-monospace">${v.id}</td>
                                        <td class="video-title-cell" title="${v.title}">${v.title}</td>
                                        <td class="text-center">${v.views}</td>
                                        <td class="text-center">
                                            <span class="status-badge ${v.active ? 'status-active' : 'status-inactive'}">
                                                ${v.active ? 'Hoạt động' : 'Đã ẩn'}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <a href="<c:url value='/admin/videos?action=edit&id=${v.id}'/>" 
                                               class="btn btn-sm btn-outline-light border-0">
                                                <i class="fas fa-pen text-info"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <!-- Empty State handling (Optional) -->
                                <c:if test="${empty videoList}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5 text-muted">
                                            <i class="fas fa-film fa-3x mb-3"></i><br>
                                            Chưa có video nào trong hệ thống.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div> <!-- /video-manager-container -->

        </div>
    </div>

    <!-- scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="<c:url value='/assets/js/video-management.js'/>"></script>
    
    <script>
        // Real-time thumbnail preview update with URL validation
        document.addEventListener('DOMContentLoaded', function() {
            const posterInput = document.getElementById('posterInput');
            const thumbnailPreview = document.querySelector('.thumbnail-preview');
            
            // Whitelist of allowed domains for thumbnail URLs (exact matching)
            const ALLOWED_DOMAINS = [
                'img.youtube.com',
                'i.ytimg.com',
                'imgur.com',
                'i.imgur.com',
                'res.cloudinary.com'
            ];
            
            // Validate URL format and domain
            function isValidThumbnailUrl(urlString) {
                try {
                    const url = new URL(urlString);
                    // Only allow http and https protocols
                    if (!['http:', 'https:'].includes(url.protocol)) {
                        return false;
                    }
                    // Exact domain matching to prevent subdomain bypass
                    return ALLOWED_DOMAINS.includes(url.hostname);
                } catch (e) {
                    return false;
                }
            }
            
            // Only run if both elements exist
            if (posterInput && thumbnailPreview) {
                // Get CSS custom property values
                const computedStyle = getComputedStyle(document.documentElement);
                const accentPrimary = computedStyle.getPropertyValue('--accent-primary').trim() || '#667eea';
                const accentColor = computedStyle.getPropertyValue('--accent-color').trim() || '#ff4757';
                
                posterInput.addEventListener('input', function() {
                    const url = this.value.trim();
                    if (url && isValidThumbnailUrl(url)) {
                        thumbnailPreview.src = url;
                        thumbnailPreview.style.borderColor = accentPrimary;
                    } else if (url) {
                        // Invalid URL - show warning border but don't load
                        thumbnailPreview.style.borderColor = accentColor;
                    }
                });
                
                // Handle image load errors
                thumbnailPreview.addEventListener('error', function() {
                    this.style.borderColor = accentColor;
                    this.alt = 'Failed to load thumbnail';
                });
                
                // Handle successful load
                thumbnailPreview.addEventListener('load', function() {
                    this.style.borderColor = accentPrimary;
                });
            }
        });
    </script>
        });
    </script>
</body>
</html>