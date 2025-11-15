<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${video.title}</title>
    
    <style>
        .detail-layout {
            display: flex;
            gap: 24px;
            padding: 24px 0;
        }
        .detail-left {
            flex: 1;
            min-width: 0; /* Cho phép flexbox co lại */
        }
        .detail-right {
            width: 400px;
            flex-shrink: 0;
        }
        
        /* Cột bên trái */
        .video-player {
            position: relative;
            padding-bottom: 56.25%; /* Tỷ lệ 16:9 */
            height: 0;
            overflow: hidden;
            background-color: #000;
            border-radius: 12px;
        }
        .video-player iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: 0;
        }
        .video-main-title {
            font-size: 24px;
            font-weight: 600;
            color: #ffffff;
            margin-top: 16px;
        }
        .video-actions {
            display: flex;
            gap: 12px;
            margin-top: 12px;
            align-items: center;
        }
        .action-btn {
            background-color: #272727;
            color: #ffffff;
            border: none;
            padding: 10px 18px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.2s;
        }
        .action-btn i {
            margin-right: 8px;
        }
        .action-btn:hover {
            background-color: #3a3a3a;
            color: #ffffff;
        }
        .video-stats-detail {
            color: #aaaaaa;
            font-size: 14px;
        }
        .video-description {
            background-color: #272727;
            color: #ffffff;
            padding: 16px;
            border-radius: 12px;
            margin-top: 20px;
            font-size: 14px;
            line-height: 1.6;
            white-space: pre-wrap; /* Giữ các định dạng xuống dòng */
        }
        
        /* Cột bên phải (dùng lại CSS từ trang chủ) */
        .related-video-card {
            display: flex;
            gap: 12px;
            margin-bottom: 12px;
            text-decoration: none;
        }
        .related-thumbnail {
            width: 160px;
            flex-shrink: 0;
            position: relative;
        }
        .related-thumbnail img {
            width: 100%;
            border-radius: 8px;
        }
        .related-details {
            flex: 1;
            min-width: 0;
        }
        .related-title {
            color: #ffffff;
            font-size: 14px;
            font-weight: 500;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .related-channel {
            color: #aaaaaa;
            font-size: 12px;
            margin-top: 4px;
        }
        
        /* Responsive */
        @media (max-width: 1200px) {
            .detail-right { width: 350px; }
        }
        @media (max-width: 992px) {
            .detail-layout { flex-direction: column; }
            .detail-right { width: 100%; }
        }
    </style>
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="main-content" id="mainContent" style="    margin-top: -10px;">
        <div class="detail-layout">
            
            <div class="detail-left">
                <div class="video-player">
                    <iframe src="https://www.youtube.com/embed/${video.id}" 
                            title="YouTube video player"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                            allowfullscreen>
                    </iframe>
                </div>
                
                <h1 class="video-main-title">${video.title}</h1>
                
                <div class="video-actions">
                    <span class="video-stats-detail">${video.views} lượt xem</span>
                    
                    <a href="<c:url value='/like?videoId=${video.id}'/>" class="action-btn">
                        <i class="fas fa-thumbs-up"></i> Like
                    </a>
                    <a href="<c:url value='/share?videoId=${video.id}'/>" class="action-btn">
                        <i class="fas fa-share"></i> Chia sẻ
                    </a>
                </div>
                
                <div class="video-description">
                    <strong>Mô tả:</strong>
                    <p>${video.description}</p>
                </div>
            </div>
            
            <div class="detail-right">
                <h4>Xem thêm</h4>
                
                <c:forEach var="v" items="${videoList}">
                    <a href="<c:url value='/detail?videoId=${v.id}'/>" class="related-video-card">
                        <div class="related-thumbnail">
                            <img src="${v.poster}" alt="${v.title}">
                        </div>
                        <div class="related-details">
                            <div class="related-title">${v.title}</div>
                            <div class="related-channel">Kênh Test</div> <%-- Cần thêm CSDL --%>
                        </div>
                    </a>
                </c:forEach>
                
            </div>
            
        </div>
    </div>
    
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>