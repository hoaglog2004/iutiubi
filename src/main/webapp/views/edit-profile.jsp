<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Xác định tab đang active -->
<c:set var="activeTab" value="${not empty activeTab ? activeTab : 'profile-info'}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cập Nhật Tài Khoản</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/animations.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/components.css'/>" rel="stylesheet" /> 

    <style>
        /* ... GIỮ NGUYÊN TOÀN BỘ CSS CŨ ... */
        :root {
            --bg-dark: #0f0f0f;
            --bg-card: #1a1a1a;
            --bg-card-hover: #222;
            --text-primary: #e0e0e0;
            --text-secondary: #aaa;
            --accent: #ff4757;
            --accent-hover: #ff6b81;
            --border-color: #2a2a2a;
            --success: #2ed573;
            --info: #1e90ff;
        }

        body {
            background: var(--bg-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Roboto, sans-serif;
        }

        .main-content {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-header {
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-custom {
            background: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            transition: transform 0.2s;
            height: 100%;
        }

        .card-custom:hover {
            transform: translateY(-2px);
        }

        .card-header-custom {
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1rem;
            margin-bottom: 1.5rem;
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
        }

        /* Avatar Upload Section */
        .avatar-section {
            text-align: center;
            padding: 2rem 1rem;
        }

        .avatar-wrapper {
            position: relative;
            width: 150px;
            height: 150px;
            margin: 0 auto 1rem;
            cursor: pointer;
        }

        .avatar-img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--accent);
            box-shadow: 0 8px 24px rgba(255, 71, 87, 0.3);
            transition: all 0.3s;
        }

        .avatar-wrapper:hover .avatar-img {
            transform: scale(1.05);
            box-shadow: 0 12px 32px rgba(255, 71, 87, 0.5);
        }

        .avatar-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .avatar-wrapper:hover .avatar-overlay {
            opacity: 1;
        }

        .avatar-overlay i {
            font-size: 2rem;
            color: #fff;
            margin-bottom: 0.5rem;
        }

        .avatar-badge {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background: var(--success);
            width: 30px;
            height: 30px;
            border-radius: 50%;
            border: 3px solid var(--bg-card);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .file-input-hidden {
            display: none;
        }

        /* Form Styling */
        .form-group-custom {
            margin-bottom: 1.25rem;
        }

        .form-label-custom {
            color: var(--text-secondary);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-control-custom {
            background: #252525;
            border: 1px solid var(--border-color);
            color: #fff;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            transition: all 0.3s;
            width: 100%;
        }

        .form-control-custom:focus {
            background: #2a2a2a;
            border-color: var(--accent);
            box-shadow: 0 0 0 4px rgba(255, 71, 87, 0.15);
            color: #fff;
            outline: none;
        }

        .form-control-custom:disabled,
        .form-control-custom[readonly] {
            background: #1a1a1a;
            color: #666;
            cursor: not-allowed;
        }

        .input-group-custom {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            z-index: 1;
        }

        .input-group-custom .form-control-custom {
            padding-left: 40px;
        }

        /* Activity Timeline */
        .activity-item {
            display: flex;
            gap: 1rem;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 0.75rem;
            background: #252525;
            transition: background 0.2s;
        }

        .activity-item:hover {
            background: #2a2a2a;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .activity-icon.video { background: rgba(255, 0, 0, 0.2); color: #ff0000; }
        .activity-icon.like { background: rgba(46, 213, 115, 0.2); color: var(--success); }
        .activity-icon.share { background: rgba(30, 144, 255, 0.2); color: var(--info); }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .activity-time {
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        /* Buttons */
        .btn-custom-primary {
            background: linear-gradient(45deg, var(--accent), var(--accent-hover));
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(255, 71, 87, 0.3);
            width: 100%;
        }

        .btn-custom-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 71, 87, 0.4);
            color: white;
        }

        .btn-custom-outline {
            background: transparent;
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
            width: 100%;
        }

        .btn-custom-outline:hover {
            background: #252525;
            border-color: #fff;
            color: #fff;
        }

        /* Badge */
        .badge-custom {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-premium {
            background: linear-gradient(45deg, #FFD700, #FFA500);
            color: #000;
        }

        /* Tabs Custom */
        .nav-tabs-custom {
            border: none;
            margin-bottom: 1.5rem;
        }

        .nav-tabs-custom .nav-link {
            background: transparent;
            border: none;
            color: var(--text-secondary);
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            border-radius: 8px;
            margin-right: 0.5rem;
            transition: all 0.3s;
        }

        .nav-tabs-custom .nav-link:hover {
            background: #252525;
            color: #fff;
        }

        .nav-tabs-custom .nav-link.active {
            background: var(--accent);
            color: white;
        }

        @media (max-width: 992px) {
            .main-content {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="main-content" id="mainContent">
        
        <!-- Page Header -->
        <div class="page-header">
            <h2 class="page-title">
                <i class="fas fa-user-circle"></i>
                Quản Lý Tài Khoản
            </h2>
            <span class="badge-custom badge-premium">
                <i class="fas fa-crown"></i> Premium User
            </span>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
                <i class="fas fa-check-circle me-2"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            
            <!-- LEFT COLUMN: Profile Information -->
            <div class="col-lg-8">
                <div class="card-custom">
                    
                    <!-- Tabs Navigation -->
                    <ul class="nav nav-tabs-custom" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link ${activeTab == 'profile-info' ? 'active' : ''}" 
                               data-bs-toggle="tab" href="#profile-info">
                                <i class="fas fa-user me-2"></i>Thông tin cá nhân
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${activeTab == 'security' ? 'active' : ''}" 
                               data-bs-toggle="tab" href="#security">
                                <i class="fas fa-lock me-2"></i>Bảo mật
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${activeTab == 'preferences' ? 'active' : ''}" 
                               data-bs-toggle="tab" href="#preferences">
                                <i class="fas fa-cog me-2"></i>Tùy chọn
                            </a>
                        </li>
                    </ul>

                    <!-- Tab Content -->
                    <div class="tab-content">
                        
                        <!-- Profile Info Tab -->
                        <div class="tab-pane fade ${activeTab == 'profile-info' ? 'show active' : ''}" 
                             id="profile-info">
                            <form action="edit-profile" method="post" enctype="multipart/form-data">
                                <input type="hidden" name="action" value="updateProfile">
                                
                                <div class="row">
                                    <!-- Avatar Upload (Left) -->
                                    <div class="col-md-4">
                                        <div class="avatar-section">
                                            <c:set var="avatarUrl" value="${pageContext.request.contextPath}/uploads/avatars/${sessionScope.currentUser.avatar}" />
                                            
                                            <div class="avatar-wrapper" onclick="document.getElementById('avatarFileInput').click()">
                                                <img id="avatarPreviewImg" 
                                                     src="${not empty sessionScope.currentUser.avatar ? avatarUrl : 'https://ui-avatars.com/api/?name='.concat(sessionScope.currentUser.id).concat('&background=ff4757&color=fff&size=200')}" 
                                                     alt="Avatar" 
                                                     class="avatar-img">
                                                
                                                <div class="avatar-overlay">
                                                    <i class="fas fa-camera"></i>
                                                    <span style="font-size: 0.8rem;">Thay đổi</span>
                                                </div>
                                                
                                                <div class="avatar-badge">
                                                    <i class="fas fa-check" style="color: white; font-size: 0.9rem;"></i>
                                                </div>
                                            </div>
                                            
                                            <input type="file" id="avatarFileInput" name="avatarFile" 
                                                   class="file-input-hidden" accept="image/png, image/jpeg, image/jpg">
                                            
                                            <p class="text-secondary" style="font-size: 0.85rem; margin-top: 1rem;">
                                                <i class="fas fa-info-circle"></i> Kích thước tối đa: 10MB<br>
                                                Định dạng: JPG, PNG
                                            </p>
                                        </div>
                                    </div>

                                    <!-- Form Fields (Right) -->
                                    <div class="col-md-8">
                                        
                                        <div class="form-group-custom">
                                            <label class="form-label-custom">
                                                <i class="fas fa-user"></i> Tên đăng nhập
                                            </label>
                                            <div class="input-group-custom">
                                                <i class="fas fa-at input-icon"></i>
                                                <input type="text" class="form-control-custom" name="username"
                                                       value="${sessionScope.currentUser.id}" readonly>
                                            </div>
                                            <small class="text-secondary">Tên đăng nhập không thể thay đổi</small>
                                        </div>

                                        <div class="form-group-custom">
                                            <label class="form-label-custom">
                                                <i class="fas fa-envelope"></i> Email
                                            </label>
                                            <div class="input-group-custom">
                                                <i class="fas fa-envelope input-icon"></i>
                                                <input type="email" class="form-control-custom" name="email"
                                                       value="${sessionScope.currentUser.email}" readonly>
                                            </div>
                                            <small class="text-secondary">
                                                <i class="fas fa-check-circle text-success"></i> Đã xác thực
                                            </small>
                                        </div>

                                        <div class="form-group-custom">
                                            <label class="form-label-custom">
                                                <i class="fas fa-id-card"></i> Họ và tên
                                            </label>
                                            <div class="input-group-custom">
                                                <i class="fas fa-signature input-icon"></i>
                                                <input type="text" class="form-control-custom" name="fullname"
                                                       value="${sessionScope.currentUser.fullname}" required>
                                            </div>
                                        </div>

                                        <div class="row mt-4">
                                            <div class="col-6">
                                                <button type="submit" class="btn-custom-primary">
                                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                                </button>
                                            </div>
                                            <div class="col-6">
                                                <button type="reset" class="btn-custom-outline">
                                                    <i class="fas fa-undo me-2"></i>Hủy bỏ
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <!-- Security Tab -->
                        <div class="tab-pane fade ${activeTab == 'security' ? 'show active' : ''}" 
                             id="security">
                            <div class="card-header-custom">
                                <h3 class="card-title">
                                    <i class="fas fa-shield-alt"></i> Bảo mật tài khoản
                                </h3>
                            </div>

                            <form action="edit-profile" method="post" id="changePasswordForm">
                                <input type="hidden" name="action" value="changePassword">
                                
                                <div class="form-group-custom">
                                    <label class="form-label-custom">
                                        <i class="fas fa-user"></i> Tên đăng nhập
                                    </label>
                                    <div class="input-group-custom">
                                        <i class="fas fa-at input-icon"></i>
                                        <input type="text" class="form-control-custom" 
                                               value="${sessionScope.currentUser.id}" readonly>
                                    </div>
                                    <small class="text-secondary">
                                        <i class="fas fa-info-circle"></i> Xác nhận tài khoản đang thao tác
                                    </small>
                                </div>
                                
                                <div class="form-group-custom">
                                    <label class="form-label-custom">
                                        <i class="fas fa-key"></i> Mật khẩu hiện tại
                                    </label>
                                    <div class="input-group-custom">
                                        <i class="fas fa-lock input-icon"></i>
                                        <input type="password" class="form-control-custom" 
                                               name="currentPassword" 
                                               placeholder="Nhập mật khẩu hiện tại"
                                               required>
                                    </div>
                                </div>

                                <div class="form-group-custom">
                                    <label class="form-label-custom">
                                        <i class="fas fa-key"></i> Mật khẩu mới
                                    </label>
                                    <div class="input-group-custom">
                                        <i class="fas fa-lock input-icon"></i>
                                        <input type="password" class="form-control-custom" 
                                               name="newPassword" 
                                               placeholder="Ít nhất 6 ký tự"
                                               minlength="6"
                                               required>
                                    </div>
                                </div>

                                <div class="form-group-custom">
                                    <label class="form-label-custom">
                                        <i class="fas fa-key"></i> Xác nhận mật khẩu mới
                                    </label>
                                    <div class="input-group-custom">
                                        <i class="fas fa-lock input-icon"></i>
                                        <input type="password" class="form-control-custom" 
                                               name="confirmPassword" 
                                               placeholder="Nhập lại mật khẩu mới"
                                               minlength="6"
                                               required>
                                    </div>
                                </div>

                                <div class="row mt-4">
                                    <div class="col-6">
                                        <button type="submit" class="btn-custom-primary">
                                            <i class="fas fa-shield-alt me-2"></i>Đổi mật khẩu
                                        </button>
                                    </div>
                                    <div class="col-6">
                                        <button type="reset" class="btn-custom-outline">
                                            <i class="fas fa-undo me-2"></i>Hủy bỏ
                                        </button>
                                    </div>
                                </div>
                            </form>

                            <hr style="border-color: var(--border-color); margin: 2rem 0;">

                            <div class="d-flex justify-content-between align-items-center p-3" 
                                 style="background: #252525; border-radius: 8px;">
                                <div>
                                    <strong>Xác thực hai yếu tố (2FA)</strong><br>
                                    <small class="text-secondary">Tăng cường bảo mật tài khoản</small>
                                </div>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" 
                                           style="width: 50px; height: 25px;" disabled>
                                </div>
                            </div>
                            <small class="text-secondary mt-2 d-block">
                                <i class="fas fa-info-circle"></i> Chức năng đang phát triển
                            </small>
                        </div>

                        <!-- Preferences Tab -->
                        <div class="tab-pane fade ${activeTab == 'preferences' ? 'show active' : ''}" 
                             id="preferences">
                            <div class="card-header-custom">
                                <h3 class="card-title">
                                    <i class="fas fa-sliders-h"></i> Tùy chỉnh giao diện
                                </h3>
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">
                                    <i class="fas fa-language"></i> Ngôn ngữ
                                </label>
                                <select class="form-control-custom">
                                    <option selected>Tiếng Việt</option>
                                    <option>English</option>
                                    <option>日本語</option>
                                </select>
                            </div>

                            <div class="form-group-custom">
                                <div class="d-flex justify-content-between align-items-center p-3" 
                                     style="background: #252525; border-radius: 8px;">
                                    <div>
                                        <strong>Chế độ tối</strong><br>
                                        <small class="text-secondary">Giao diện tối bảo vệ mắt</small>
                                    </div>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" checked style="width: 50px; height: 25px;">
                                    </div>
                                </div>
                            </div>

                            <div class="form-group-custom">
                                <div class="d-flex justify-content-between align-items-center p-3" 
                                     style="background: #252525; border-radius: 8px;">
                                    <div>
                                        <strong>Tự động phát video</strong><br>
                                        <small class="text-secondary">Phát video tiếp theo tự động</small>
                                    </div>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" checked style="width: 50px; height: 25px;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- RIGHT COLUMN: Activity -->
            <div class="col-lg-4">
                
                <!-- Recent Activity -->
                <div class="card-custom">
                    <div class="card-header-custom">
                        <h3 class="card-title">
                            <i class="fas fa-clock"></i> Hoạt động gần đây
                        </h3>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon video">
                            <i class="fas fa-play"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Đã xem video</div>
                            <div class="activity-time">Shiku 1000 Ánh Mắt - 2 giờ trước</div>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon like">
                            <i class="fas fa-heart"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Đã thích video</div>
                            <div class="activity-time">Em - Binz - 5 giờ trước</div>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon share">
                            <i class="fas fa-share-alt"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Đã chia sẻ</div>
                            <div class="activity-time">Chị Là Không Có Nhau - 1 ngày trước</div>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon video">
                            <i class="fas fa-play"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">Đã xem video</div>
                            <div class="activity-time">TÙNG - ĐẶT TRÁI TIM LÊN BÀN - 2 ngày trước</div>
                        </div>
                    </div>

                    <a href="#" class="btn-custom-outline mt-3" style="text-align: center; display: block; padding: 0.5rem;">
                        Xem tất cả hoạt động <i class="fas fa-arrow-right ms-2"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Avatar Preview khi chọn file
        document.getElementById('avatarFileInput').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                // Validate file size (10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('Kích thước file không được vượt quá 10MB!');
                    this.value = '';
                    return;
                }
                
                // Validate file type
                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn file ảnh (JPG, PNG)!');
                    this.value = '';
                    return;
                }
                
                // Preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatarPreviewImg').src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
        
        // Validation cho form đổi mật khẩu
        document.getElementById('changePasswordForm')?.addEventListener('submit', function(e) {
            const newPass = document.querySelector('input[name="newPassword"]').value;
            const confirmPass = document.querySelector('input[name="confirmPassword"]').value;
            
            if (newPass !== confirmPass) {
                e.preventDefault();
                alert('Xác nhận mật khẩu không khớp!');
                return false;
            }
        });
    </script>
</body>
</html>