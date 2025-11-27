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
    
    <!-- Bootstrap 5 & Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <!-- Custom CSS Path -->
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
            --accent-hover: #ff6b81;
            --border-color: #333;
        }

        body {
            background-color: var(--bg-dark);
            color: var(--text-primary);
            font-family: 'Segoe UI', Roboto, sans-serif;
        }

        .main-content {
            padding: 2rem;
        }

        /* Header Styling */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border-color);
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: #fff;
            margin: 0;
        }

        /* Card Styling */
        .glass-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.2);
            padding: 1.5rem;
            transition: transform 0.2s;
        }
        
        /* Modern Tab Styling */
        .nav-tabs {
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 0;
        }
        
        .nav-tabs .nav-link {
            background-color: transparent;
            border: none;
            color: var(--text-secondary);
            padding: 1rem 1.5rem;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-radius: 8px 8px 0 0;
            transition: all 0.3s ease;
        }
        
        .nav-tabs .nav-link:hover {
            color: var(--accent-color);
            background-color: rgba(255, 71, 87, 0.05);
        }
        
        .nav-tabs .nav-link.active {
            background-color: var(--bg-card);
            color: var(--accent-color);
            border-bottom: 2px solid var(--accent-color);
        }
        
        .nav-tabs .nav-link i {
            margin-right: 8px;
        }
        
        .tab-content {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-top: none;
            border-radius: 0 0 16px 16px;
            padding: 1.5rem;
        }

        /* Form Styling */
        .form-label {
            color: var(--text-secondary);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .custom-input {
            background-color: #2c2c2c;
            border: 1px solid var(--border-color);
            color: #fff;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .custom-input:focus {
            background-color: #333;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 4px rgba(255, 71, 87, 0.15);
            color: #fff;
        }

        /* Table Styling */
        .custom-table-container {
            overflow-x: auto;
        }
        
        .custom-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px;
        }

        .custom-table th {
            color: var(--text-secondary);
            font-weight: 600;
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .custom-table td {
            background-color: #252525;
            padding: 1rem;
            vertical-align: middle;
            color: #fff;
            border-top: 1px solid transparent;
            border-bottom: 1px solid transparent;
        }

        .custom-table td:first-child { border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
        .custom-table td:last-child { border-top-right-radius: 8px; border-bottom-right-radius: 8px; }

        .custom-table tr:hover td {
            background-color: #2a2a2a;
            transform: scale(1.005);
            transition: transform 0.2s;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #fff;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--border-color);
        }

        .filter-form {
            background-color: #252525;
            padding: 1rem 1.5rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    
    <div class="d-flex">
        <jsp:include page="/common/sidebar.jsp"/>

        <div class="flex-grow-1 main-content" id="mainContent">
            
            <!-- Header Section -->
            <div class="page-header">
                <h2 class="page-title"><i class="fas fa-chart-bar me-2"></i>Báo Cáo & Thống Kê</h2>
            </div>
            
            <c:set var="activeTab" value="${not empty param.videoId ? 'favoriteUsers' : 'favorites'}" />
            <c:if test="${param.tab == 'shares'}">
                <c:set var="activeTab" value="sharedFriends" />
            </c:if>

            <ul class="nav nav-tabs" id="myTab" role="tablist">
              <li class="nav-item" role="presentation">
                <button class="nav-link ${activeTab == 'favorites' ? 'active' : ''}" id="favorites-tab" data-bs-toggle="tab" data-bs-target="#favorites" type="button" role="tab">
                    <i class="fas fa-heart"></i>Favorites
                </button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link ${activeTab == 'favoriteUsers' ? 'active' : ''}" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button" role="tab">
                    <i class="fas fa-user-heart"></i>Favorite Users
                </button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link ${activeTab == 'sharedFriends' ? 'active' : ''}" id="shares-tab" data-bs-toggle="tab" data-bs-target="#shares" type="button" role="tab">
                    <i class="fas fa-share-alt"></i>Shared Friends
                </button>
              </li>
            </ul>
            
            <div class="tab-content" id="myTabContent">
              
              <!-- TAB 1: FAVORITES -->
              <div class="tab-pane fade ${activeTab == 'favorites' ? 'show active' : ''}" id="favorites" role="tabpanel">
                  <h4 class="section-title"><i class="fas fa-chart-line me-2 text-danger"></i>Thống kê video theo lượt yêu thích</h4>
                  
                  <div class="custom-table-container">
                      <table class="custom-table">
                          <thead>
                              <tr>
                                  <th>Video Title</th>
                                  <th width="15%">Favorite Count</th>
                                  <th width="20%">Latest Date</th>
                                  <th width="20%">Oldest Date</th>
                              </tr>
                          </thead>
                          <tbody>
                              <c:forEach var="item" items="${reportFavorites}">
                                  <tr>
                                      <td>${item.videoTitle}</td>
                                      <td><span class="badge bg-danger">${item.likeCount}</span></td>
                                      <td class="text-secondary">${item.newestDate}</td>
                                      <td class="text-secondary">${item.oldestDate}</td>
                                  </tr>
                              </c:forEach>
                              
                              <c:if test="${empty reportFavorites}">
                                  <tr>
                                      <td colspan="4" class="text-center py-5 text-muted">
                                          <i class="fas fa-heart fa-3x mb-3"></i><br>
                                          Chưa có dữ liệu thống kê.
                                      </td>
                                  </tr>
                              </c:if>
                          </tbody>
                      </table>
                  </div>
              </div>
              
              <!-- TAB 2: FAVORITE USERS -->
              <div class="tab-pane fade ${activeTab == 'favoriteUsers' ? 'show active' : ''}" id="users" role="tabpanel">
                  <h4 class="section-title"><i class="fas fa-users me-2 text-danger"></i>Lọc người dùng đã thích video</h4>
                  
                  <div class="filter-form">
                      <form class="row g-3 align-items-end" action="reports" method="get">
                          <div class="col-md-6">
                              <label class="form-label">Chọn Video</label>
                              <div class="input-group">
                                  <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fas fa-video"></i></span>
                                  <select name="videoId" class="form-select custom-input" onchange="this.form.submit()">
                                      <option value="">-- Chọn video --</option>
                                      <c:forEach var="v" items="${videoList}">
                                          <option value="${v.id}" ${param.videoId == v.id ? 'selected' : ''}>${v.title}</option>
                                      </c:forEach>
                                  </select>
                              </div>
                          </div>
                      </form>
                  </div>
                  
                  <div class="custom-table-container">
                      <table class="custom-table">
                          <thead>
                              <tr>
                                  <th width="15%">Username</th>
                                  <th>Fullname</th>
                                  <th>Email</th>
                                  <th width="20%">Favorite Date</th>
                              </tr>
                          </thead>
                          <tbody>
                              <c:forEach var="item" items="${usersWhoLiked}">
                                  <tr>
                                      <td class="text-secondary font-monospace">${item.user.id}</td>
                                      <td>${item.user.fullname}</td>
                                      <td>${item.user.email}</td>
                                      <td class="text-secondary">${item.likeDate}</td>
                                  </tr>
                              </c:forEach>
                              
                              <c:if test="${empty usersWhoLiked}">
                                  <tr>
                                      <td colspan="4" class="text-center py-5 text-muted">
                                          <i class="fas fa-user-friends fa-3x mb-3"></i><br>
                                          Vui lòng chọn video để xem danh sách người dùng.
                                      </td>
                                  </tr>
                              </c:if>
                          </tbody>
                      </table>
                  </div>
              </div>
              
              <!-- TAB 3: SHARED FRIENDS -->
              <div class="tab-pane fade ${activeTab == 'sharedFriends' ? 'show active' : ''}" id="shares" role="tabpanel">
                   <h4 class="section-title"><i class="fas fa-share-alt me-2 text-danger"></i>Lọc người gửi & nhận theo video</h4>
                   
                   <div class="filter-form">
                       <form class="row g-3 align-items-end" action="reports" method="get">
                           <input type="hidden" name="tab" value="shares">
                           <div class="col-md-6">
                               <label class="form-label">Chọn Video</label>
                               <div class="input-group">
                                   <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fas fa-video"></i></span>
                                   <select name="sharedVideoId" class="form-select custom-input" onchange="this.form.submit()">
                                       <option value="">-- Chọn video --</option>
                                       <c:forEach var="v" items="${videoList}">
                                           <option value="${v.id}" ${param.sharedVideoId == v.id ? 'selected' : ''}>${v.title}</option>
                                       </c:forEach>
                                   </select>
                               </div>
                           </div>
                       </form>
                   </div>
                   
                   <div class="custom-table-container">
                       <table class="custom-table">
                          <thead>
                              <tr>
                                  <th>Sender Name</th>
                                  <th>Sender Email</th>
                                  <th>Receiver Email</th>
                                  <th width="20%">Sent Date</th>
                              </tr>
                          </thead>
                          <tbody>
                              <c:forEach var="item" items="${sharesOfVideo}">
                                  <tr>
                                      <td>${item.user.fullname}</td>
                                      <td>${item.user.email}</td>
                                      <td>${item.emails}</td>
                                      <td class="text-secondary"><fmt:formatDate value="${item.shareDate}" pattern="HH:mm dd/MM/yyyy"/></td>
                                  </tr>
                              </c:forEach>
                              
                              <c:if test="${empty sharesOfVideo}">
                                  <tr>
                                      <td colspan="4" class="text-center py-5 text-muted">
                                          <i class="fas fa-share fa-3x mb-3"></i><br>
                                          Vui lòng chọn video để xem danh sách chia sẻ.
                                      </td>
                                  </tr>
                              </c:if>
                          </tbody>
                      </table>
                  </div>
              </div>
            </div>
            
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/assets/js/app.js'/>"></script>
</body>
</html>