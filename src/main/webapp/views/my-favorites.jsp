<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Video Yêu Thích</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/animations.css'/>" rel="stylesheet" />
    <link href="<c:url value='/assets/css/components.css'/>" rel="stylesheet" /> 

    <style>
        /* Đảm bảo nền tối cho các phần phụ */
        .admin-header {
            font-size: 24px; font-weight: 600; padding-bottom: 20px;
            border-bottom: 1px solid #272727; margin-bottom: 24px; color: #ffffff;
        }
        
        /* Box chứa nút bấm */
        .video-action-footer {
            margin-top: 10px; 
            display: flex; 
            gap: 10px;
        }
        
        /* Style cho nút "Unlike" - Màu accent (đỏ) */
        .btn-unlike {
            background-color: #ff0000;
            color: #ffffff;
            padding: 8px 12px;
            font-size: 12px;
            border-radius: 20px;
            text-decoration: none;
            transition: background-color 0.2s;
            display: inline-flex; /* Để icon và text nằm ngang */
            align-items: center;
        }
        .btn-unlike:hover {
            background-color: #cc0000;
            color: #ffffff;
        }
        
        /* Style cho nút "Share" - Màu phụ (xám) */
        .btn-share-secondary {
            background-color: #272727;
            color: #aaaaaa;
            padding: 8px 12px;
            font-size: 12px;
            border-radius: 20px;
            text-decoration: none;
            transition: background-color 0.2s;
            display: inline-flex;
            align-items: center;
        }
        .btn-share-secondary:hover {
            background-color: #404040;
            color: #ffffff;
        }
        
        /* Căn chỉnh các icon */
        .btn-unlike i, .btn-share-secondary i {
            margin-right: 5px;
        }
    </style>
</head>
<body>

	<jsp:include page="/common/header.jsp" />

	<jsp:include page="/common/sidebar.jsp" />

	<div class="main-content" id="mainContent">
		<h2 class="admin-header">VIDEO YÊU THÍCH CỦA TÔI</h2>

		<div class="video-grid" id="videoGrid" style="margin-top: 20px;">

			<c:forEach var="v" items="${favoriteList}">
				<div class="video-card">
					<%-- Dùng <div> thay vì <a> để thêm nút Unlike --%>
					<a href="<c:url value='/detail?videoId=${v.id}'/>"
						class="video-thumbnail-link">
						<div class="video-thumbnail">
							<img src="${v.poster}" alt="${v.title}">
							<div class="video-duration">15:30</div>
						</div>
					</a>
					<div class="video-info">
						<div class="channel-avatar">TM</div>
						<div class="video-details">
							<a href="<c:url value='/detail?videoId=${v.id}'/>"
								style="text-decoration: none;">
								<div class="video-title">${v.title}</div>
							</a>
							<div class="video-channel">Kênh Test</div>
							
							<div class="video-stats">${v.views} lượt xem</div>

							<div class="video-action-footer">
								<a href="<c:url value='/unlike?videoId=${v.id}'/>"
									class="btn-unlike">
									<i class="fas fa-thumbs-down"></i> Unlike
								</a> 
								<a href="<c:url value='/share?videoId=${v.id}'/>"
									class="btn-share-secondary">
									<i class="fas fa-share"></i> Share
								</a>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
			
			<c:if test="${empty favoriteList}">
				<p
					style="grid-column: 1/-1; text-align: center; padding: 40px; color: #aaa;">
					Bạn chưa thích video nào.</p>
			</c:if>

		</div>
	</div>

	<script src="<c:url value='/assets/js/app.js'/>"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>