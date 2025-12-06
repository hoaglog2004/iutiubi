<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Help - Hướng Dẫn Sử Dụng</title>
    
    <!-- Bootstrap 5 & Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
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
            --border-color: #333;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Roboto, sans-serif;
        }

        .main-content {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-header {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .help-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .help-card h3 {
            color: var(--accent-color);
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }

        .help-card h4 {
            color: #fff;
            margin-top: 1.5rem;
            margin-bottom: 0.75rem;
            font-size: 1.2rem;
        }

        .help-card ul {
            margin-left: 1.5rem;
        }

        .help-card li {
            margin-bottom: 0.5rem;
            line-height: 1.6;
        }

        .feature-tag {
            display: inline-block;
            background: rgba(255, 71, 87, 0.15);
            color: var(--accent-color);
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-right: 8px;
        }

        code {
            background: #2c2c2c;
            padding: 2px 6px;
            border-radius: 4px;
            color: #ff6b81;
            font-family: 'Courier New', monospace;
        }

        .example-box {
            background: #2c2c2c;
            border-left: 3px solid var(--accent-color);
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 4px;
        }
    </style>
</head>
<body>

    <jsp:include page="/common/header.jsp" />
    
    <div class="d-flex">
        <jsp:include page="/common/sidebar.jsp" />

        <div class="flex-grow-1 main-content" id="mainContent">
            
            <div class="page-header">
                <h2><i class="fas fa-question-circle me-2"></i>Hướng Dẫn Sử Dụng Admin Panel</h2>
                <p class="text-muted">Tài liệu hướng dẫn sử dụng các tính năng quản trị</p>
            </div>

            <!-- Video Management Help -->
            <div class="help-card">
                <h3><i class="fas fa-video me-2"></i>Quản Lý Video</h3>
                <span class="feature-tag">MỚI</span>
                <span class="feature-tag">THUMBNAIL</span>

                <h4>Hiển Thị Thumbnail</h4>
                <p>Danh sách video hiện nay hiển thị hình thu nhỏ (thumbnail) cho mỗi video:</p>
                <ul>
                    <li><strong>Tự động từ YouTube</strong>: Nếu để trống trường Thumbnail URL, hệ thống tự động lấy từ YouTube</li>
                    <li><strong>Custom URL</strong>: Bạn có thể nhập URL hình ảnh tùy chỉnh</li>
                    <li><strong>Fallback Icon</strong>: Nếu không có thumbnail, hiển thị icon mặc định</li>
                </ul>

                <h4>Thêm/Sửa Video</h4>
                <div class="example-box">
                    <p><strong>YouTube ID:</strong> Nhập ID video từ YouTube (ví dụ: <code>dQw4w9WgXcQ</code>)</p>
                    <p><strong>Thumbnail URL:</strong> Tùy chọn - Để trống để tự động tạo hoặc nhập URL tùy chỉnh</p>
                    <p class="mb-0"><strong>Ví dụ URL:</strong> <code>https://example.com/image.jpg</code></p>
                </div>

                <h4>Cơ Chế Tự Động</h4>
                <p>Khi tạo/cập nhật video:</p>
                <ul>
                    <li>Nếu <strong>không nhập</strong> Thumbnail URL → Tự động tạo: <code>https://img.youtube.com/vi/{VIDEO_ID}/hqdefault.jpg</code></li>
                    <li>Nếu <strong>có nhập</strong> Thumbnail URL → Sử dụng URL bạn cung cấp</li>
                </ul>
            </div>

            <!-- User Management Help -->
            <div class="help-card">
                <h3><i class="fas fa-users me-2"></i>Quản Lý User</h3>
                <span class="feature-tag">MỚI</span>
                <span class="feature-tag">AVATAR</span>

                <h4>Hiển Thị Avatar</h4>
                <p>Danh sách user hiện nay hiển thị avatar cho mỗi người dùng:</p>
                <ul>
                    <li><strong>Avatar từ URL</strong>: Hiển thị hình ảnh từ URL đã lưu trong database</li>
                    <li><strong>Fallback Icon</strong>: Nếu user chưa có avatar, hiển thị icon user mặc định</li>
                    <li><strong>Hình tròn</strong>: Avatar được hiển thị dạng hình tròn (40x40px) cho đẹp mắt</li>
                </ul>

                <h4>Thêm/Sửa User</h4>
                <div class="example-box">
                    <p><strong>Username:</strong> ID đăng nhập duy nhất (không thể sửa sau khi tạo)</p>
                    <p><strong>Avatar URL:</strong> Tùy chọn - URL hình ảnh đại diện của user</p>
                    <p><strong>Email:</strong> Chỉ đọc - không thể sửa trực tiếp</p>
                    <p class="mb-0"><strong>Password:</strong> Để trống khi update nếu không muốn đổi mật khẩu</p>
                </div>

                <h4>Lưu Ý Bảo Mật</h4>
                <ul>
                    <li>Mật khẩu được mã hóa bằng BCrypt</li>
                    <li>Email không thể trùng lặp trong hệ thống</li>
                    <li>Role Admin có toàn quyền truy cập</li>
                </ul>
            </div>

            <!-- Login Features Help -->
            <div class="help-card">
                <h3><i class="fas fa-sign-in-alt me-2"></i>Đăng Nhập & Xác Thực</h3>
                <span class="feature-tag">CẢI TIẾN</span>
                <span class="feature-tag">BẢO MẬT</span>

                <h4>Đăng Nhập Bằng Username HOẶC Email</h4>
                <div class="example-box">
                    <p>Người dùng giờ đây có thể đăng nhập bằng:</p>
                    <p>✅ <strong>Username:</strong> <code>john123</code></p>
                    <p>✅ <strong>Email:</strong> <code>john@example.com</code></p>
                    <p class="mb-0">Hệ thống tự động nhận diện và xác thực</p>
                </div>

                <h4>Google Login - Kiểm Tra Email</h4>
                <p>Tính năng mới: Khi đăng nhập bằng Google:</p>
                <ul>
                    <li><strong>Kiểm tra email tồn tại</strong>: Hệ thống kiểm tra email từ Google có trong database chưa</li>
                    <li><strong>Nếu tồn tại</strong>: Hiển thị thông báo <code>"Email đã được đăng ký"</code> và không cho đăng ký trùng</li>
                    <li><strong>Nếu chưa tồn tại</strong>: Tiếp tục đăng ký và đăng nhập bình thường</li>
                </ul>

                <h4>Bảo Mật</h4>
                <ul>
                    <li><strong>Rate Limiting</strong>: Giới hạn số lần đăng nhập sai để chống brute force</li>
                    <li><strong>Password Hashing</strong>: Tất cả mật khẩu được mã hóa BCrypt</li>
                    <li><strong>CSRF Protection</strong>: OAuth state validation cho social login</li>
                </ul>
            </div>

            <!-- Best Practices -->
            <div class="help-card">
                <h3><i class="fas fa-lightbulb me-2"></i>Best Practices</h3>

                <h4>Khi Quản Lý Video</h4>
                <ul>
                    <li>Luôn kiểm tra YouTube ID trước khi thêm video</li>
                    <li>Sử dụng thumbnail từ YouTube trừ khi cần custom</li>
                    <li>Đặt trạng thái Active/Inactive để kiểm soát hiển thị</li>
                    <li>Phân loại video đúng category để dễ tìm kiếm</li>
                </ul>

                <h4>Khi Quản Lý User</h4>
                <ul>
                    <li>Tạo username ngắn gọn, dễ nhớ</li>
                    <li>Luôn sử dụng email hợp lệ</li>
                    <li>Cẩn thận khi gán role Admin</li>
                    <li>Avatar URL nên dùng HTTPS để bảo mật</li>
                </ul>

                <h4>Bảo Mật</h4>
                <ul>
                    <li>Thay đổi mật khẩu admin định kỳ</li>
                    <li>Không chia sẻ thông tin đăng nhập</li>
                    <li>Kiểm tra log đăng nhập thường xuyên</li>
                    <li>Sao lưu database định kỳ</li>
                </ul>
            </div>

            <!-- Technical Notes -->
            <div class="help-card">
                <h3><i class="fas fa-code me-2"></i>Ghi Chú Kỹ Thuật</h3>

                <h4>Database Schema Updates</h4>
                <div class="example-box">
                    <p><strong>Video Table:</strong></p>
                    <p>→ <code>Poster</code> (varchar) - Lưu URL thumbnail</p>
                    <p class="mt-2"><strong>Users Table:</strong></p>
                    <p class="mb-0">→ <code>Avatar</code> (varchar) - Lưu URL avatar</p>
                </div>

                <h4>API Changes</h4>
                <ul>
                    <li><code>POST /login</code> - Giờ chấp nhận username hoặc email</li>
                    <li><code>GET /oauth2/google/callback</code> - Thêm validation email tồn tại</li>
                    <li><code>POST /admin/videos</code> - Xử lý thumbnail URL input</li>
                </ul>

                <h4>Xem Thêm</h4>
                <p>Đọc file <code>README.md</code> trong thư mục gốc của project để biết thêm chi tiết về:</p>
                <ul>
                    <li>Cấu trúc database đầy đủ</li>
                    <li>API endpoints</li>
                    <li>Hướng dẫn build & deploy</li>
                    <li>Cấu hình OAuth</li>
                </ul>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/assets/js/app.js'/>"></script>
</body>
</html>
