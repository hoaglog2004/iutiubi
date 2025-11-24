<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" />
<link href="<c:url value='/assets/css/animations.css'/>" rel="stylesheet" />
<link href="<c:url value='/assets/css/components.css'/>" rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<nav class="navbar-custom">
	<div
		style="display: flex; align-items: center; justify-content: space-between; width: 100%;">
		<div style="display: flex; align-items: center; gap: 24px">
			<button class="header-icon-btn" onclick="toggleSidebar()">
				<i class="fas fa-bars"></i>
			</button>
			<a class="navbar-brand" href="<c:url value='/home'/>"> <i
				class="fas fa-play"></i> Iutiubi
			</a>
		</div>

		<div class="search-container">
			<div style="display: flex">
				<input type="text" id="searchInput"
					placeholder="Tìm kiếm video..."
					value="${param.keyword}" />

				<button class="search-btn" id="searchButton" type="button">
					<i class="fas fa-search"></i>
				</button>
			</div>
		</div>

		<div class="header-icons">
			<button class="header-icon-btn notification-bell" title="Thông báo">
				<i class="fas fa-bell"></i>
			</button>

			<div id="userSection" class="user-section dropdown">
				
				<%-- ====================================== --%>
				<%-- 1. TRẠNG THÁI CHƯA ĐĂNG NHẬP --%>
				<%-- ====================================== --%>
				<c:if test="${empty sessionScope.currentUser}">
					<a href="<c:url value='/login'/>" class="btn-login">Đăng nhập</a>
				</c:if>

				<%-- ====================================== --%>
				<%-- 2. TRẠNG THÁI ĐÃ ĐĂNG NHẬP --%>
				<%-- ====================================== --%>
				<c:if test="${not empty sessionScope.currentUser}">

					<%-- LOGIC HIỂN THỊ AVATAR/PLACEHOLDER --%>
					<c:choose>
						<c:when test="${not empty sessionScope.currentUser.avatar}">
							<img
								src="<c:url value='/uploads/avatars/${sessionScope.currentUser.avatar}'/>"
								class="user-avatar"
								data-bs-toggle="dropdown"
								aria-expanded="false"
								style="cursor: pointer; object-fit: cover; border: 2px solid #fff;"
								title="${sessionScope.currentUser.fullname}">
						</c:when>
						<c:otherwise>
							<div class="user-avatar" data-bs-toggle="dropdown"
								aria-expanded="false" style="cursor: pointer;"
								title="${sessionScope.currentUser.fullname}">
								${sessionScope.currentUser.id.substring(0, 1).toUpperCase()}
							</div>
						</c:otherwise>
					</c:choose>
					
					<%-- MENU DROPDOWN --%>
					<ul class="dropdown-menu dropdown-menu-end">
						<li><a class="dropdown-item"
							href="<c:url value='/edit-profile'/>"> <i
								class="fas fa-user-edit me-2"></i> Edit Profile
						</a></li>
						<%-- <li><a class="dropdown-item"
							href="<c:url value='/change-password'/>"> <i
								class="fas fa-key me-2"></i> Đổi mật khẩu
						</a></li> --%>
						<li><hr class="dropdown-divider"></li>
						<li><a class="dropdown-item" href="<c:url value='/logout'/>">
								<i class="fas fa-sign-out-alt me-2"></i> Logout
						</a></li>
					</ul>

				</c:if>
			</div>
		</div>
	</div>
</nav>