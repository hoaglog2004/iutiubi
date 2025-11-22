<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="sidebar" id="sidebar">
    <a href="<c:url value='/home'/>" class="sidebar-item ${activePage == 'home' ? 'active' : ''}">
        <i class="fas fa-home"></i>
        <span class="sidebar-label">Trang chủ</span>
    </a>
    <%-- <a href="#" class="sidebar-item ${activePage == 'trending' ? 'active' : ''}">
        <i class="fas fa-fire"></i>
        <span class="sidebar-label">Xu hướng</span>
    </a>
    
    <a href="#" class="sidebar-item ${activePage == 'subscriptions' ? 'active' : ''}">
        <i class="fas fa-list"></i>
        <span class="sidebar-label">Đăng ký</span>
    </a>
    
    <div class="sidebar-divider"></div>
    
    <a href="#" class="sidebar-item ${activePage == 'library' ? 'active' : ''}">
        <i class="fas fa-bookmark"></i>
        <span class="sidebar-label">Thư viện</span>
    </a>
    
    <a href="#" class="sidebar-item ${activePage == 'history' ? 'active' : ''}">
        <i class="fas fa-history"></i>
        <span class="sidebar-label">Lịch sử</span>
    </a> --%>
    
    <a href="<c:url value='/my-favorites'/>" class="sidebar-item ${activePage == 'favorites' ? 'active' : ''}">
        <i class="fas fa-thumbs-up"></i>
        <span class="sidebar-label">Yêu thích</span>
    </a>
    
    <c:if test="${not empty sessionScope.currentUser}">
        <a href="<c:url value='/history'/>" class="sidebar-item ${activePage == 'history' ? 'active' : ''}">
            <i class="fas fa-history"></i>
            <span class="sidebar-label">Lịch sử xem</span>
        </a>
    </c:if>
    
    <div class="sidebar-divider"></div>
    
    <c:if test="${sessionScope.currentUser.admin == true}">
        <a href="<c:url value='/admin/videos'/>" class="sidebar-item ${activePage == 'admin' ? 'active' : ''}">
            <i class="fas fa-shield-halved"></i>
            <span class="sidebar-label">Quản Trị</span>
        </a>
        <a href="<c:url value='/admin/categories'/>" 
       class="sidebar-item ${activePage == 'categories' ? 'active' : ''}">
        <i class="fas fa-tags"></i>
        <span class="sidebar-label">Quản Trị Thể Loại</span>
    </a>
    <a href="<c:url value='/admin/users'/>" class="sidebar-item ${activePage == 'users' ? 'active' : ''}">
            <i class="fas fa-shield-halved"></i>
            <span class="sidebar-label">Quản Trị Users</span>
        </a>
         <a href="<c:url value='/admin/reports'/>" class="sidebar-item ${activePage == 'reports' ? 'active' : ''}">
            <i class="fas fa-shield-halved"></i>
            <span class="sidebar-label">Báo Cáo - Thống Kê</span>
        </a>
    </c:if>
    
    <a href="<c:url value='/edit-profile'/>" class="sidebar-item ${activePage == 'settings' ? 'active' : ''}">
        <i class="fas fa-cog"></i>
        <span class="sidebar-label">Cài đặt</span>
    </a>
    
    <a href="#" class="sidebar-item ${activePage == 'help' ? 'active' : ''}">
        <i class="fas fa-question-circle"></i>
        <span class="sidebar-label">Trợ giúp</span>
    </a>
</div>