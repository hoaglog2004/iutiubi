<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Báo Cáo - Thống Kê</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" /> 

    <style>
        .main-content { color: #ffffff; }
        .admin-header {
            font-size: 24px; font-weight: 600; padding-bottom: 20px;
            border-bottom: 1px solid #272727; margin-bottom: 24px;
        }
        
        /* Định dạng Tabs (Dark Mode) */
        .nav-tabs {
            border-bottom: 1px solid #404040;
        }
        .nav-tabs .nav-link {
            background-color: transparent;
            border: 1px solid transparent;
            color: #aaaaaa;
            margin-right: 4px;
            border-radius: 8px 8px 0 0;
            font-weight: 600;
        }
        .nav-tabs .nav-link.active {
            background-color: #1a1a1a;
            color: #ff0000;
            border-color: #404040 #404040 transparent #404040;
        }
        .tab-content {
            background-color: #1a1a1a;
            padding: 24px;
            border: 1px solid #404040;
            border-top: none;
            border-radius: 0 0 12px 12px;
        }
        
        /* Định dạng Bảng (Giống các trang admin khác) */
        .admin-table { width: 100%; border-collapse: collapse; font-size: 14px; }
        .admin-table th, .admin-table td { padding: 12px 10px; text-align: left; border-bottom: 1px solid #272727; }
        .admin-table th { color: #aaaaaa; font-weight: 600; }
        .admin-table td { color: #ffffff; }
        
        /* Định dạng Form (Dropdown) */
        .admin-form .form-label { color: #aaaaaa; font-size: 14px; font-weight: 500; }
        .admin-form .form-select {
            background-color: #272727; border: 1px solid #404040; color: #ffffff;
            border-radius: 8px; padding: 10px 14px; font-size: 14px;
        }
    </style>
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="main-content" id="mainContent">
        <h2 class="admin-header">BÁO CÁO & THỐNG KÊ</h2>
        
        <c:set var="activeTab" value="${not empty param.videoId ? 'favoriteUsers' : 'favorites'}" />
        <c:if test="${param.tab == 'shares'}">
            <c:set var="activeTab" value="sharedFriends" />
        </c:if>

        <ul class="nav nav-tabs" id="myTab" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link ${activeTab == 'favorites' ? 'active' : ''}" id="favorites-tab" data-bs-toggle="tab" data-bs-target="#favorites" type="button" role="tab">FAVORITES</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link ${activeTab == 'favoriteUsers' ? 'active' : ''}" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button" role="tab">FAVORITE USERS</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link ${activeTab == 'sharedFriends' ? 'active' : ''}" id="shares-tab" data-bs-toggle="tab" data-bs-target="#shares" type="button" role="tab">SHARED FRIENDS</button>
          </li>
        </ul>
        
        <div class="tab-content" id="myTabContent">
          
          <div class="tab-pane fade ${activeTab == 'favorites' ? 'show active' : ''}" id="favorites" role="tabpanel">
              <h4 class="mt-2" style="font-weight: 600;">Thống kê video theo lượt yêu thích</h4>
              <table class="admin-table mt-3">
                  <thead>
                      <tr>
                          <th>Video Title</th>
                          <th>Favorite Count</th>
                          <th>Latest Date</th>
                          <th>Oldest Date</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach var="item" items="${reportFavorites}">
                          <tr>
                              <td>${item.videoTitle}</td>
                              <td>${item.likeCount}</td>
                              <td>${item.newestDate}</td>
                              <td>${item.oldestDate}</td>
                          </tr>
                      </c:forEach>
                  </tbody>
              </table>
          </div>
          
          <div class="tab-pane fade ${activeTab == 'favoriteUsers' ? 'show active' : ''}" id="users" role="tabpanel">
              <h4 class="mt-2" style="font-weight: 600;">Lọc người dùng đã thích video</h4>
              
              <form class="row g-3 align-items-end admin-form" action="reports" method="get" style="background: none; padding: 10px 0;">
                  <div class="col-md-6">
                      <label class="form-label">VIDEO TITLE?</label>
                      <select name="videoId" class="form-select" onchange="this.form.submit()">
                          <option value="">-- Chọn video --</option>
                          <c:forEach var="v" items="${videoList}">
                              <option value="${v.id}" ${param.videoId == v.id ? 'selected' : ''}>${v.title}</option>
                          </c:forEach>
                      </select>
                  </div>
              </form>
              
              <table class="admin-table mt-3">
                  <thead>
                      <tr>
                          <th>Username</th>
                          <th>Fullname</th>
                          <th>Email</th>
                          <th>Favorite Date</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach var="item" items="${usersWhoLiked}">
                          <tr>
                              <td>${item.user.id}</td>
                              <td>${item.user.fullname}</td>
                              <td>${item.user.email}</td>
                              <td>${item.likeDate}</td>
                          </tr>
                      </c:forEach>
                  </tbody>
              </table>
          </div>
          
          <div class="tab-pane fade ${activeTab == 'sharedFriends' ? 'show active' : ''}" id="shares" role="tabpanel">
               <h4 class="mt-2" style="font-weight: 600;">Lọc người gửi & nhận theo video</h4>
               
               <form class="row g-3 align-items-end admin-form" action="reports" method="get" style="background: none; padding: 10px 0;">
                   <input type="hidden" name="tab" value="shares"> <div class="col-md-6">
                       <label class="form-label">VIDEO TITLE?</label>
                       <select name="sharedVideoId" class="form-select" onchange="this.form.submit()">
                           <option value="">-- Chọn video --</option>
                           <c:forEach var="v" items="${videoList}">
                               <option value="${v.id}" ${param.sharedVideoId == v.id ? 'selected' : ''}>${v.title}</option>
                           </c:forEach>
                       </select>
                   </div>
               </form>
               
               <table class="admin-table mt-3">
                  <thead>
                      <tr>
                          <th>Sender Name</th>
                          <th>Sender Email</th>
                          <th>Receiver Email</th>
                          <th>Sent Date</th>
                      </tr>
                  </thead>
                  <tbody>
                      <c:forEach var="item" items="${sharesOfVideo}">
                          <tr>
                              <td>${item.user.fullname}</td>
                              <td>${item.user.email}</td>
                              <td>${item.emails}</td>
                              <fmt:formatDate value="${item.shareDate}" pattern="HH:mm dd/MM/yyyy"/>
                          </tr>
                      </c:forEach>
                  </tbody>
              </table>
          </div>
        </div>
        
    </div>
    
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>