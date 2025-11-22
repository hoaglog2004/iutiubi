<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lịch Sử Xem</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" /> 
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="main-content" id="mainContent">
        <h2 style="color: #ffffff; padding-bottom: 20px; border-bottom: 1px solid #272727;">
            LỊCH SỬ XEM
        </h2>
        
        <div class="video-grid" id="videoGrid" style="margin-top: 20px;">
        
            <c:forEach var="item" items="${historyList}">
                <a href="<c:url value='/detail?videoId=${item.video.id}'/>" class="video-card">
                    <div class="video-thumbnail">
                        <img src="${item.video.poster}" alt="${item.video.title}">
                        <%-- Hiển thị thời gian User dừng xem --%>
                        <div class="video-duration">Dừng lúc: ${item.lastTime}s</div> 
                    </div>
                    <div class="video-info">
                        <div class="channel-avatar">TM</div>
                        <div class="video-details">
                            <div class="video-title">${item.video.title}</div>
                            <div class="video-channel">Xem lần cuối: <fmt:formatDate value="${item.viewDate}" pattern="HH:mm dd/MM"/></div>
                            <div class="video-stats">${item.video.views} lượt xem</div>
                        </div>
                    </div>
                </a>
            </c:forEach>
            
            <c:if test="${empty historyList}">
                <p style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #aaa;">
                    Bạn chưa có lịch sử xem nào.
                </p>
            </c:if>

        </div>
    </div>
    
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>