<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Iutiubi - Trang chủ</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
<link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" />
</head>
<body>

	<jsp:include page="/common/header.jsp" />
	<jsp:include page="/common/sidebar.jsp" />

	<div class="main-content" id="mainContent">
		<div class="filter-tags" id="filterTags">
			<a href="<c:url value='/home'/>"
				class="filter-tag ${activeCategory == 'all' ? 'active' : ''}">Tất
				cả</a>

			<c:forEach var="cat" items="${categoryList}">
				<a href="<c:url value='/home?categoryId=${cat.id}'/>"
					class="filter-tag ${activeCategory == cat.id ? 'active' : ''}">
					${cat.name} </a>
			</c:forEach>
		</div>


		<div class="video-grid" id="videoGrid" >

			<c:forEach var="v" items="${videoList}">
				<a href="<c:url value='/detail?videoId=${v.id}'/>"
					class="video-card">
					<div class="video-thumbnail">
						<img src="${v.poster}" alt="${v.title}">
						<div class="video-duration">15:30</div>
					</div>
					<div class="video-info">
						<div class="channel-avatar">TM</div>
						<div class="video-details">
							<div class="video-title">${v.title}</div>
							<div class="video-channel">Kênh Test</div>
							<div class="video-stats">${v.views}lượt xem</div>
						</div>
					</div>
				</a>
			</c:forEach>

			<c:if test="${empty videoList}">
				<p
					style="grid-column: 1/-1; text-align: center; padding: 40px; color: #aaa;">
					Không có video nào để hiển thị.</p>
			</c:if>
		</div>
		<nav aria-label="Page navigation">
            <ul class="pagination justify-content-center" style="margin: 20px 0;">
                
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" 
                       href="home?page=${currentPage - 1}&categoryId=${activeCategory == 'all' ? '' : activeCategory}"
                    >Previous</a>
                </li>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" 
                           href="home?page=${i}&categoryId=${activeCategory == 'all' ? '' : activeCategory}"
                        >${i}</a>
                    </li>
                </c:forEach>
                
                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                    <a class="page-link" 
                       href="home?page=${currentPage + 1}&categoryId=${activeCategory == 'all' ? '' : activeCategory}"
                    >Next</a>
                </li>
            </ul>
        </nav>
	</div>

	<script src="<c:url value='/assets/js/app.js'/>"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>