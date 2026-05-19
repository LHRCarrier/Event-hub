<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String redirectUrl = (String) session.getAttribute("redirect_url");
    if (redirectUrl == null) {
        redirectUrl = request.getContextPath() + "/index.jsp";
    }
    session.removeAttribute("redirect_url");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Community Event Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1e88e5;
            --sidebar-bg: #1a237e;
            --sidebar-active: #3949ab;
            --bg-color: #f5f7fa;
            --community-color: #673ab7;
            --community-light: #b39ddb;
        }
        body {
            background-color: var(--bg-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            min-height: 100vh;
            background-color: var(--sidebar-bg);
            color: white;
        }
        .sidebar .nav-link {
            color: #e8eaf6;
            padding: 12px 20px;
            margin: 4px 12px;
            border-radius: 8px;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: var(--sidebar-active);
            color: white;
        }
        .sidebar .nav-link i {
            margin-right: 10px;
        }
        .content {
            min-height: 100vh;
        }
        .stat-card {
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .event-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .event-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }
        .event-banner {
            height: 120px;
            background: linear-gradient(135deg, var(--primary-color), #42a5f5);
        }
        .btn-primary {
            background-color: var(--primary-color) !important;
            border: none;
            border-radius: 8px;
        }
        .btn-primary:hover {
            background-color: #1976d2 !important;
        }
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .table thead {
            background-color: #fafafa;
        }
        .badge {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
        }
        .badge-success {
            background-color: #c8e6c9;
            color: #2e7d32;
        }
        .badge-warning {
            background-color: #fff3e0;
            color: #e65100;
        }
        .badge-danger {
            background-color: #ffcdd2;
            color: #c62828;
        }
        .badge-admin {
            background-color: #e1bee7;
            color: #6a1b9a;
        }
        .badge-member {
            background-color: #bbdefb;
            color: #1565c0;
        }
        .community-card {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: transform 0.3s, box-shadow 0.3s;
            border-top: 4px solid var(--community-color);
        }
        .community-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }
        .community-banner {
            height: 100px;
            background: linear-gradient(135deg, var(--community-color), #9575cd);
        }
        .btn-community {
            background-color: var(--community-color) !important;
            border: none;
            border-radius: 8px;
            color: white;
        }
        .btn-community:hover {
            background-color: #5e35b1 !important;
            color: white;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom">
        <div class="container-fluid">
            <a class="navbar-brand" href="#home" onclick="showPage('home')">
                <i class="fas fa-calendar-alt text-primary"></i> EventHub
            </a>
            <div class="d-flex align-items-center">
                <div class="input-group me-3" style="width: 300px;">
                    <input type="text" class="form-control" placeholder="Search events..." id="searchInput">
                    <button class="btn btn-outline-primary" type="button" onclick="searchEvents()">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
                <div class="dropdown">
                    <button class="btn btn-secondary dropdown-toggle d-flex align-items-center" type="button" data-bs-toggle="dropdown">
                        <img id="headerAvatar" src="" alt="Avatar" class="rounded-circle me-2" style="width: 32px; height: 32px; object-fit: cover; display: none;">
                        <span id="headerAvatarInitial" class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">U</span>
                        <span id="currentUsername">Admin</span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="#profile" onclick="showPage('profile')">Profile</a></li>
                        <li><a class="dropdown-item" href="#settings">Settings</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#" onclick="handleLogout()">Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="row g-0">
        <div class="col-2 sidebar p-0">
            <div class="p-4 border-bottom border-white/10">
                <h4 class="text-center font-bold">EventHub</h4>
            </div>
            <nav class="nav flex-column p-2">
                <a class="nav-link active" href="#home" onclick="showPage('home')">
                    <i class="fas fa-home"></i> Home
                </a>
                <a class="nav-link" href="#communities" onclick="showPage('communities')">
                    <i class="fas fa-users"></i> Communities
                </a>
                <a class="nav-link" href="#events" onclick="showPage('events')">
                    <i class="fas fa-calendar"></i> Events
                </a>
                <a class="nav-link" href="#registrations" onclick="showPage('registrations')">
                    <i class="fas fa-file-alt"></i> Registrations
                </a>
                <a class="nav-link" href="#users" onclick="showPage('users')">
                    <i class="fas fa-users"></i> Users
                </a>
                <a class="nav-link" href="#categories" onclick="showPage('categories')">
                    <i class="fas fa-tags"></i> Categories
                </a>
                <a class="nav-link" href="#dashboard" onclick="showPage('dashboard')">
                    <i class="fas fa-chart-line"></i> Dashboard
                </a>
                <div class="border-top border-white/10 my-2"></div>
                <a class="nav-link" href="#applications" onclick="showPage('applications')">
                    <i class="fas fa-file-clipboard"></i> Applications
                </a>
                <a class="nav-link" href="#community-approvals" onclick="showPage('community-approvals')">
                    <i class="fas fa-check-circle"></i> Approvals
                </a>
                <a class="nav-link" href="#profile" onclick="showPage('profile')">
                    <i class="fas fa-user-circle"></i> Profile
                </a>
            </nav>
        </div>

        <div class="col-10 content p-4">
            <%@ include file="/WEB-INF/views/home/home.jsp" %>
            <%@ include file="/WEB-INF/views/home/home-new.jsp" %>
            <%@ include file="/WEB-INF/views/communities/communities-list.jsp" %>
            <%@ include file="/WEB-INF/views/communities/community-detail.jsp" %>
            <%@ include file="/WEB-INF/views/communities/community-create.jsp" %>
            <%@ include file="/WEB-INF/views/communities/community-members.jsp" %>
            <%@ include file="/WEB-INF/views/communities/community-home.jsp" %>
            <%@ include file="/WEB-INF/views/communities/community-dashboard.jsp" %>
            <%@ include file="/WEB-INF/views/applications/applications.jsp" %>
            <%@ include file="/WEB-INF/views/admin/community-approvals.jsp" %>
            <%@ include file="/WEB-INF/views/events/events-list.jsp" %>
            <%@ include file="/WEB-INF/views/events/event-detail.jsp" %>
            <%@ include file="/WEB-INF/views/events/event-create.jsp" %>
            <%@ include file="/WEB-INF/views/registrations/registrations.jsp" %>
            <%@ include file="/WEB-INF/views/users/users.jsp" %>
            <%@ include file="/WEB-INF/views/categories/categories-list.jsp" %>
            <%@ include file="/WEB-INF/views/categories/category-create.jsp" %>
            <%@ include file="/WEB-INF/views/dashboard/dashboard.jsp" %>
            <%@ include file="/WEB-INF/views/profile/profile.jsp" %>
        </div>
    </div>

    <script>
        window.API_BASE = '${pageContext.request.contextPath}/api';
        window.redirectUrl = "<%= redirectUrl.replace("\\", "\\\\").replace("\"", "\\\"") %>";
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="static/js/api/api-utils.js"></script>
    <script src="static/js/api/users-api.js"></script>
    <script src="static/js/api/categories-api.js"></script>
    <script src="static/js/api/communities-api.js"></script>
    <script src="static/js/api/community-applications-api.js"></script>
    <script src="static/js/api/events-api.js"></script>
    <script src="static/js/api/registrations-api.js"></script>
    <script src="static/js/api/dashboard-api.js"></script>
    <script src="static/js/app.js"></script>
</body>
</html>