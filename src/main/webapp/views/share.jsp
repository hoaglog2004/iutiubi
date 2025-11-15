<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chia Sẻ Video</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="<c:url value='/assets/css/style.css'/>" rel="stylesheet" /> 

    <style>
        .main-content { color: #ffffff; }
        .admin-header {
            font-size: 24px; font-weight: 600; padding-bottom: 20px;
            border-bottom: 1px solid #272727; margin-bottom: 24px;
        }
        .admin-form-wrapper {
            max-width: 600px;
            margin: 40px auto;
        }
        .admin-form { background-color: #1a1a1a; padding: 30px; border-radius: 12px; }
        .admin-form .form-group { margin-bottom: 20px; }
        .admin-form label { display: block; color: #aaaaaa; font-size: 14px; font-weight: 500; margin-bottom: 8px; }
        .admin-form .form-control {
            background-color: #272727; border: 1px solid #404040; color: #ffffff;
            border-radius: 8px; width: 100%; padding: 12px 14px; font-size: 14px;
        }
        .admin-form .form-control:focus { outline: none; border-color: #ff0000; box-shadow: 0 0 0 3px rgba(255, 0, 0, 0.2); }
        .admin-form .btn-primary {
            background-color: #ff0000; color: #ffffff; border: none; padding: 12px 16px;
            border-radius: 20px; font-weight: 600; font-size: 15px; cursor: pointer;
            transition: all 0.2s; width: 100%;
        }
    </style>
</head>
<body>
    
    <jsp:include page="/common/header.jsp"/>
    <jsp:include page="/common/sidebar.jsp"/>

    <div class="main-content" id="mainContent">
        <h2 class="admin-header">SEND VIDEO TO YOUR FRIEND</h2>
        
        <div class="admin-form-wrapper">
            <div class="admin-form">
                
                <c:if test="${not empty message}">
                    <div class="alert alert-success" style="background-color: #d4edda; color: #155724; margin-bottom: 16px;">
                        ${message}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; margin-bottom: 16px;">
                        ${error}
                    </div>
                </c:if>

                <form action="share" method="post">
                    <input type="hidden" name="videoId" value="${videoId}">
                    
                    <div class="form-group">
                        <label for="email">YOUR FRIEND'S EMAIL?</label>
                        <input type="email" class="form-control" id="email" name="email" 
                               placeholder="friend@example.com" required>
                    </div>
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-paper-plane"></i> Send
                    </button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="<c:url value='/assets/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>