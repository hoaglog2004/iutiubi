<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
        Không tìm thấy video nào.
    </p>
</c:if>