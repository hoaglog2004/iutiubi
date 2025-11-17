<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Kết quả cho: ${searchKeyword}</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" /> 
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="main-content" id="mainContent">
        
        <h2 style="color: #ffffff; padding-bottom: 20px; border-bottom: 1px solid #272727;">
            Kết quả tìm kiếm cho: "${searchKeyword}"
        </h2>

        <div class="video-grid" id="videoGrid" style="margin-top: 20px;">
            
            <c:forEach var="v" items="${videoList}">
                <a href="<c:url value='/detail?videoId=${v.id}'/>" class="video-card">
                    <div class="video-thumbnail">
                        <img src="${v.poster}" alt="${v.title}">
                        <div class="video-duration">15:30</div>
                    </div>
                    <div class="video-info">
                        <div class="channel-avatar">TM</div>
                        <div class="video-details">
                            <div class="video-title">${v.title}</div>
                            <div class="video-channel">Kênh Test</div>
                            <div class="video-stats">${v.views} lượt xem</div>
                        </div>
                    </div>
                </a>
            </c:forEach>
            
            <c:if test="${empty videoList}">
                <p style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #aaa;">
                    Không tìm thấy video nào khớp với từ khóa "${searchKeyword}".
                </p>
            </c:if>
        </div>
        
        </div>
    
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>