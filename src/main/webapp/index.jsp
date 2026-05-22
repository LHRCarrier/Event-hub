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
        .bg-gradient-to-br {
            background: linear-gradient(to bottom right, var(--tw-gradient-stops));
        }
        .from-purple-500 {
            --tw-gradient-from: #a855f7;
            --tw-gradient-to: rgba(168, 85, 247, 0);
            --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to);
        }
        .to-pink-500 {
            --tw-gradient-to: #ec4899;
            --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to);
        }
        .hover\:shadow-xl:hover {
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
        .transition-shadow {
            transition: box-shadow 0.3s;
        }
        .transition-opacity {
            transition: opacity 0.3s;
        }
        .bg-black {
            background-color: #000;
        }
        .bg-opacity-50 {
            opacity: 0.5;
        }
        .text-gray-500 {
            color: #6b7280;
        }
        .text-white {
            color: #fff;
        }
        .text-3xl {
            font-size: 1.875rem;
        }
        .font-bold {
            font-weight: 700;
        }
        .w-24 {
            width: 6rem;
        }
        .h-24 {
            height: 6rem;
        }
        .w-full {
            width: 100%;
        }
        .h-full {
            height: 100%;
        }
        .flex {
            display: flex;
        }
        .items-center {
            align-items: center;
        }
        .justify-center {
            justify-content: center;
        }
        .relative {
            position: relative;
        }
        .absolute {
            position: absolute;
        }
        .inset-0 {
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
        }
        .opacity-0 {
            opacity: 0;
        }
        .hover\:opacity-100:hover {
            opacity: 1;
        }
        .rounded-full {
            border-radius: 9999px;
        }
        .border-4 {
            border-width: 4px;
        }
        .border-white {
            border-color: #fff;
        }
        .shadow-lg {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
        .object-cover {
            object-fit: cover;
        }
        .cursor-pointer {
            cursor: pointer;
        }
        .overflow-hidden {
            overflow: hidden;
        }
        .text-sm {
            font-size: 0.875rem;
        }
        .font-medium {
            font-weight: 500;
        }
        .text-center {
            text-align: center;
        }
        .mb-6 {
            margin-bottom: 1.5rem;
        }
        .mt-2 {
            margin-top: 0.5rem;
        }
        .ms-auto {
            margin-left: auto;
        }
        .d-none {
            display: none !important;
        }
        .hover\\:border-primary:hover {
            border-color: #1e88e5 !important;
        }
        .hover\\:shadow-md:hover {
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        .hover\\:bg-gray-50:hover {
            background-color: #f9fafb;
        }
        .transition-all {
            transition: all 0.2s;
        }
        .wallpaper-item:hover {
            border-color: #1e88e5 !important;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        #wallpaperUploadArea:hover {
            border-color: #1e88e5 !important;
            background-color: #f9fafb;
        }
        .h-28 {
            height: 7rem;
        }
        .row-cols-2 {
            column-count: 2;
        }
        @media (min-width: 768px) {
            .row-cols-md-3 {
                column-count: 3;
            }
        }
    </style>
</head>
<body>
    <header id="headerBanner" class="fixed top-0 left-0 right-0" style="height: 80px; z-index: 999; background: linear-gradient(to right, #1e88e5, #42a5f5);">
        <div class="relative h-full flex items-center justify-between px-4" style="width: 83.3333%; margin-left: 16.6667%; z-index: 1;">
            <div class="d-flex align-items-center">
                <div id="userMenuContainer" class="relative">
                    <div id="avatarWrapper" class="cursor-pointer">
                        <img id="headerAvatar" src="" alt="Avatar" class="rounded-circle" style="width: 40px; height: 40px; object-fit: cover; border: 2px solid rgba(255,255,255,0.5); box-shadow: 0 2px 8px rgba(0,0,0,0.2); transition: transform 0.2s ease;">
                    </div>
                    <div id="userMenu" class="absolute top-full left-1/2 transform -translate-x-1/2 mt-2 bg-white rounded-xl shadow-xl w-72 overflow-hidden opacity-0 invisible transition-all duration-200" style="z-index: 1000;">
                        <div class="p-4 border-b border-gray-100">
                            <div class="flex flex-col items-center">
                                <img id="menuAvatar" src="" alt="Avatar" class="rounded-full mb-2" style="width: 64px; height: 64px; object-fit: cover;">
                                <span id="menuUsername" class="font-bold text-gray-800">Admin</span>
                                <span class="text-xs text-gray-500">EventHub Member</span>
                            </div>
                        </div>
                        <div class="p-2">
                            <a href="#profile" onclick="showPage('profile'); closeUserMenu();" class="flex items-center px-3 py-2 rounded-lg hover:bg-gray-50 text-gray-700">
                                <i class="fas fa-user-circle mr-3 text-gray-400"></i>
                                <span>Profile</span>
                                <i class="fas fa-chevron-right ml-auto text-gray-400"></i>
                            </a>
                            <a href="#settings" onclick="showPage('settings'); closeUserMenu();" class="flex items-center px-3 py-2 rounded-lg hover:bg-gray-50 text-gray-700">
                                <i class="fas fa-cog mr-3 text-gray-400"></i>
                                <span>Settings</span>
                                <i class="fas fa-chevron-right ml-auto text-gray-400"></i>
                            </a>
                            <div class="border-t border-gray-100 my-2"></div>
                            <a href="#" onclick="handleLogout();" class="flex items-center px-3 py-2 rounded-lg hover:bg-gray-50 text-gray-700">
                                <i class="fas fa-sign-out-alt mr-3 text-gray-400"></i>
                                <span>Logout</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="d-flex align-items-center">
                <div class="input-group" style="width: 450px;">
                    <input type="text" class="form-control bg-white/90 backdrop-blur-sm" placeholder="Search events..." id="searchInput" style="border-radius: 20px 0 0 20px;">
                    <button class="btn btn-primary" type="button" onclick="searchEvents()" style="border-radius: 0 20px 20px 0;">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
        </div>
    </header>

    <div class="modal fade" id="avatarModal" tabindex="-1" aria-labelledby="avatarModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="avatarModalLabel">Profile Picture</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="previewAvatarImg" src="" alt="Profile Picture" class="rounded-lg" style="max-width: 200px; max-height: 200px; object-fit: cover;">
                </div>
            </div>
        </div>
    </div>

    <div class="row g-0" style="padding-top: 80px;">
        <div class="col-2 sidebar p-0" style="position: relative; z-index: 1001;">
            <div class="p-4 border-bottom border-white/10" style="background: transparent; position: relative; z-index: 1;">
                <h4 class="text-center font-bold">EventHub</h4>
            </div>
            <nav class="nav flex-column p-2">
                <a class="nav-link active" href="#home" onclick="showPage('home')" data-route="home">
                    <i class="fas fa-home"></i> Home
                </a>
                <a class="nav-link" href="#communities" onclick="showPage('communities')" data-route="communities">
                    <i class="fas fa-users"></i> Communities
                </a>
                <a class="nav-link" href="#events" onclick="showPage('events')" data-route="events">
                    <i class="fas fa-calendar"></i> Events
                </a>
                <a class="nav-link" href="#registrations" onclick="showPage('registrations')" data-route="registrations">
                    <i class="fas fa-file-alt"></i> Registrations
                </a>
                <a class="nav-link" href="#users" onclick="showPage('users')" data-route="users" data-admin-only="true">
                    <i class="fas fa-users"></i> Users
                </a>
                <a class="nav-link" href="#categories" onclick="showPage('categories')" data-route="categories" data-admin-only="true">
                    <i class="fas fa-tags"></i> Categories
                </a>
                <a class="nav-link" href="#dashboard" onclick="showPage('dashboard')" data-route="dashboard" data-admin-only="true">
                    <i class="fas fa-chart-line"></i> Dashboard
                </a>
                <div class="border-top border-white/10 my-2"></div>
                <a class="nav-link" href="#applications" onclick="showPage('applications')" data-route="applications">
                    <i class="fas fa-file-clipboard"></i> Applications
                </a>
                <a class="nav-link" href="#community-approvals" onclick="showPage('community-approvals')" data-route="community-approvals" data-admin-only="true">
                    <i class="fas fa-check-circle"></i> Approvals
                </a>
                <a class="nav-link" href="#profile" onclick="showPage('profile')" data-route="profile">
                    <i class="fas fa-user-circle"></i> Profile
                </a>
                <a class="nav-link" href="#settings" onclick="showPage('settings')" data-route="settings" data-admin-only="true">
                    <i class="fas fa-cog"></i> Settings
                </a>
            </nav>
        </div>

        <div class="col-10 content p-4" style="position: relative; z-index: 100;">
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
            <%@ include file="/WEB-INF/views/settings/settings.jsp" %>
        </div>
    </div>

    <script>
        window.API_BASE = '${pageContext.request.contextPath}/api';
        window.redirectUrl = "<%= redirectUrl.replace("\\", "\\\\").replace("\"", "\\\"") %>";
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <script src="static/js/api/api-utils.js"></script>
    <script src="static/js/api/users-api.js"></script>
    <script src="static/js/api/categories-api.js"></script>
    <script src="static/js/api/communities-api.js"></script>
    <script src="static/js/api/community-applications-api.js"></script>
    <script src="static/js/api/events-api.js"></script>
    <script src="static/js/api/registrations-api.js"></script>
    <script src="static/js/api/dashboard-api.js"></script>
    <script src="static/js/api/index.js"></script>
    <!-- Permission System Modules -->
    <script src="static/js/permission/permission.js"></script>
    <script src="static/js/permission/router-guard.js"></script>
    <script src="static/js/permission/permission-directives.js"></script>
    <script src="static/js/permission/api-middleware.js"></script>
    <script src="static/js/permission/permission-init.js"></script>
    <script src="static/js/permission/permission.test.js"></script>
    <script src="static/js/app.js"></script>
</body>
</html>