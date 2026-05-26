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
            --primary-color: #25B8A6;
            --primary-light: #5DD3CD;
            --primary-dark: #1A8E83;
            --accent-orange: #F5A623;
            --accent-red: #E87474;
            --accent-green: #7ED957;
            --accent-blue: #6BB3D9;
            --sidebar-bg: rgba(45, 55, 72, 0.6);
            --sidebar-active: rgba(37, 184, 166, 0.3);
            --bg-color: transparent;
            --white-95: rgba(255, 255, 255, 0.95);
            --white-90: rgba(255, 255, 255, 0.9);
            --white-80: rgba(255, 255, 255, 0.8);
            --white-70: rgba(255, 255, 255, 0.7);
            --white-65: rgba(255, 255, 255, 0.65);
            --white-20: rgba(255, 255, 255, 0.2);
            --white-15: rgba(255, 255, 255, 0.15);
            --white-12: rgba(255, 255, 255, 0.12);
            --white-10: rgba(255, 255, 255, 0.1);
            --white-08: rgba(255, 255, 255, 0.08);
            --white-06: rgba(255, 255, 255, 0.06);
        }
        body {
            background-color: var(--bg-color);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
            margin: 0;
            padding: 0;
        }
        .background-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
            overflow: hidden;
        }
        .video-background {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(180deg, #0f172a 0%, #1e293b 50%, #334155 100%);
        }
        .video-background video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.9;
        }
        .main-layout {
            display: flex;
            width: 100%;
            height: 100vh;
            overflow: hidden;
        }
        .sidebar {
            width: 260px;
            min-width: 260px;
            height: 100vh;
            display: flex;
            flex-direction: column;
            background: rgba(45, 55, 72, 0.6);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid rgba(255, 255, 255, 0.1);
            color: white;
            position: relative;
            z-index: 1002;
        }
        .sidebar-header {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .sidebar-logo-circle {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: #25B8A6;
            box-shadow: 0 4px 12px rgba(37, 184, 166, 0.4);
        }
        .sidebar-logo-text {
            font-size: 22px;
            font-weight: 700;
            color: var(--white-95);
        }
        .sidebar-nav {
            display: flex;
            flex-direction: column;
            gap: 4px;
            padding: 0 16px;
            flex: 1;
        }
        .nav-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
            padding: 8px 0;
        }
        .nav-group:not(:last-child) {
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 8px;
        }
        .sidebar .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 12px;
            border-radius: 8px;
            color: var(--white-90);
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: transparent;
            margin: 0;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: var(--sidebar-active);
            color: white;
        }
        .sidebar .nav-link i {
            width: 20px;
            text-align: center;
            margin-right: 0;
        }
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow: hidden;
            position: relative;
            z-index: 100;
        }
        .top-navbar {
            height: 72px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            background: var(--white-06);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--white-10);
            position: relative;
            z-index: 1000;
        }
        .search-area {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0 16px;
            width: 420px;
            height: 44px;
            border-radius: 12px;
            background: var(--white-08);
        }
        .search-icon {
            color: var(--white-80);
        }
        .search-input {
            flex: 1;
            background: transparent;
            border: none;
            outline: none;
            color: var(--white-80);
            font-size: 14px;
        }
        .search-input::placeholder {
            color: var(--white-65);
        }
        .user-area {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--white-20);
        }
        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 32px;
            color: white;
        }
        .content-area h2, .content-area h3, .content-area h4 {
            color: var(--white-90);
        }
        .stat-card {
            border-radius: 16px;
            background: var(--white-08);
            border: 1px solid var(--white-12);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.2);
        }
        .stat-icon-bg {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: var(--white-95);
        }
        .stat-label {
            font-size: 14px;
            color: var(--white-65);
        }
        .event-card {
            border-radius: 16px;
            background: var(--white-08);
            border: 1px solid var(--white-12);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .event-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        }
        .event-badge {
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }
        .event-badge.upcoming {
            background: var(--white-10);
            color: var(--white-80);
        }
        .event-badge.active {
            background: rgba(37, 184, 166, 0.25);
            color: var(--primary-color);
        }
        .event-badge.past {
            background: var(--white-10);
            color: var(--white-65);
        }
        .btn-primary {
            background-color: var(--primary-color) !important;
            border: none;
            border-radius: 12px;
        }
        .btn-primary:hover {
            background-color: var(--primary-dark) !important;
            box-shadow: 0 4px 12px rgba(37, 184, 166, 0.4);
        }
        .table-container {
            background: var(--white-08);
            border: 1px solid var(--white-12);
            border-radius: 16px;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
        }
        .table-container .table {
            color: var(--white-90);
            background: transparent;
        }
        .table-container .table th {
            color: var(--white-70);
            border-bottom: 1px solid var(--white-12);
        }
        .table-container .table td {
            border-bottom: 1px solid var(--white-10);
        }
        .table-container .table thead {
            background: transparent;
        }
        .badge {
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-success {
            background: rgba(126, 217, 87, 0.25);
            color: #7ED957;
        }
        .badge-warning {
            background: rgba(245, 166, 35, 0.25);
            color: #F5A623;
        }
        .badge-danger {
            background: rgba(232, 116, 116, 0.25);
            color: #E87474;
        }
        .badge-admin {
            background: rgba(139, 92, 246, 0.25);
            color: #8B5CF6;
        }
        .badge-member {
            background: rgba(59, 130, 246, 0.25);
            color: #3B82F6;
        }
        .community-card {
            border-radius: 16px;
            background: var(--white-08);
            border: 1px solid var(--white-12);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .community-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        }
        .btn-community {
            background-color: rgba(107, 179, 217, 0.3) !important;
            border: 1px solid rgba(107, 179, 217, 0.5) !important;
            border-radius: 12px;
            color: #6BB3D9;
        }
        .btn-community:hover {
            background-color: rgba(107, 179, 217, 0.5) !important;
            color: white;
        }
        .page-content {
            color: var(--white-90);
        }
        .text-primary {
            color: var(--primary-color);
        }
        .text-gray-500 {
            color: var(--white-65);
        }
        .form-control, .form-select {
            background: var(--white-08);
            border: 1px solid var(--white-12);
            border-radius: 12px;
            color: var(--white-90);
        }
        .form-control:focus, .form-select:focus {
            background: var(--white-08);
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 184, 166, 0.2);
            color: var(--white-90);
        }
        .form-control::placeholder {
            color: var(--white-65);
        }
        .modal-content {
            background: rgba(30, 41, 59, 0.95);
            border: 1px solid var(--white-12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
        }
        .modal-header, .modal-footer {
            border-color: var(--white-12);
        }
        .modal-title {
            color: var(--white-95);
        }
        .btn-close {
            filter: invert(1);
        }
        .list-group-item {
            background: var(--white-08);
            border-color: var(--white-12);
            color: var(--white-90);
        }
        .nav-tabs .nav-link {
            color: var(--white-70);
            border-color: var(--white-12);
            border-radius: 12px 12px 0 0;
        }
        .nav-tabs .nav-link.active {
            background: var(--white-08);
            color: var(--primary-color);
            border-color: var(--white-12);
        }
        .tab-content {
            background: var(--white-08);
            border: 1px solid var(--white-12);
            border-top: none;
            border-radius: 0 12px 12px 12px;
            padding: 20px;
        }
        .card {
            background: var(--white-08);
            border: 1px solid var(--white-12);
            border-radius: 16px;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
        }
        .card-header {
            border-color: var(--white-12);
            color: var(--white-95);
        }
        .card-title {
            color: var(--white-95);
        }
        .pagination .page-link {
            background: var(--white-08);
            border-color: var(--white-12);
            color: var(--white-80);
            border-radius: 8px !important;
            margin: 0 4px;
        }
        .pagination .page-link:hover {
            background: var(--white-12);
            color: var(--primary-color);
        }
        .pagination .page-item.active .page-link {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }
        .text-muted {
            color: var(--white-65);
        }
        .text-white {
            color: var(--white-95);
        }
        .border {
            border-color: var(--white-12);
        }
        .bg-white {
            background: var(--white-08) !important;
        }
        .hover\:shadow-xl:hover {
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2), 0 10px 10px -5px rgba(0, 0, 0, 0.1);
        }
        .transition-shadow {
            transition: box-shadow 0.3s;
        }
        .transition-opacity {
            transition: opacity 0.3s;
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
        .opacity-0 {
            opacity: 0;
        }
        .hover\:opacity-100:hover {
            opacity: 1;
        }
        .rounded-full {
            border-radius: 9999px;
        }
        .shadow-lg {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.15), 0 4px 6px -2px rgba(0, 0, 0, 0.1);
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
        .transition-all {
            transition: all 0.2s;
        }
        .welcome-section {
            margin-bottom: 32px;
        }
        .welcome-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--white-95);
            margin: 0 0 8px 0;
        }
        .welcome-subtitle {
            font-size: 16px;
            color: var(--white-70);
            margin: 0;
        }
        .stats-section {
            margin-bottom: 32px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--white-90);
            margin: 0;
        }
        .section-link {
            font-size: 14px;
            font-weight: 500;
            color: var(--primary-color);
            text-decoration: none;
        }
        .section-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div id="background-container" class="background-container">
        <div id="video-background" class="video-background">
            <video id="bg-video" autoplay muted loop playsinline>
                <source src="Mock-background/videos/8cd6ab41d3814faac0f96ec1e2bd4fbd_raw.mp4" type="video/mp4">
            </video>
        </div>
    </div>

    <div class="main-layout">
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo-circle"></div>
                <span class="sidebar-logo-text">EventHub</span>
            </div>
            <nav class="sidebar-nav">
                <div class="nav-group">
                    <a class="nav-link active" href="#home" onclick="showPage('home')" data-route="home">
                        <i class="fas fa-home"></i> Home
                    </a>
                </div>
                <div class="nav-group">
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
                </div>
                <div class="nav-group">
                    <a class="nav-link" href="#applications" onclick="showPage('applications')" data-route="applications">
                        <i class="fas fa-file-clipboard"></i> Applications
                    </a>
                    <a class="nav-link" href="#community-approvals" onclick="showPage('community-approvals')" data-route="community-approvals" data-admin-only="true">
                        <i class="fas fa-check-circle"></i> Approvals
                    </a>
                </div>
                <div class="nav-group">
                    <a class="nav-link" href="#profile" onclick="showPage('profile')" data-route="profile">
                        <i class="fas fa-user-circle"></i> Profile
                    </a>
                    <a class="nav-link" href="#settings" onclick="showPage('settings')" data-route="settings" data-admin-only="true">
                        <i class="fas fa-cog"></i> Settings
                    </a>
                </div>
            </nav>
        </aside>

        <div class="main-content">
            <header class="top-navbar">
                <div class="user-area">
                    <div id="userMenuContainer" class="relative" style="z-index: 99999;">
                        <div id="avatarWrapper" class="cursor-pointer relative" style="width: 48px; height: 48px; z-index: 99999;">
                            <div class="absolute inset-0 rounded-full overflow-hidden" style="transition: all 0.3s ease;">
                                <img id="headerAvatar" src="" alt="Avatar" class="w-full h-full object-cover" style="display: none;">
                                <span id="headerAvatarInitial" class="w-full h-full flex items-center justify-center text-white font-semibold text-lg" style="background: var(--primary-color);">U</span>
                            </div>
                        </div>
                        <div id="userMenu" class="absolute top-0 left-0 overflow-hidden opacity-0 invisible transition-all duration-300 ease-out pointer-events-none" style="z-index: 99999; background-color: rgba(30, 30, 30, 0.98); border-radius: 20px; border: 1px solid rgba(80, 80, 80, 0.6); transform: translate(-24px, -64px) scale(0.4); transform-origin: 24px 64px; box-shadow: 0 25px 80px rgba(0, 0, 0, 0.6); backdrop-filter: blur(25px); -webkit-backdrop-filter: blur(25px); width: 320px;">
                            <div class="relative">
                                <div class="h-40 bg-gradient-to-r from-gray-700 to-gray-800" style="border-radius: 19px 19px 0 0;"></div>
                                <div class="absolute left-1/2 -translate-x-1/2" style="bottom: -52px; width: 100px; height: 100px;">
                                    <div class="relative w-full h-full rounded-full overflow-hidden border-4 border-gray-600 bg-gray-800" style="box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);">
                                        <img id="menuAvatar" src="" alt="Avatar" class="w-full h-full object-cover" style="display: none; object-position: center;">
                                        <span id="menuAvatarInitial" class="w-full h-full flex items-center justify-center text-white font-bold text-3xl" style="background: var(--primary-color);">U</span>
                                    </div>
                                </div>
                            </div>
                            <div class="pt-28 pb-5 px-6 text-center">
                                <span id="menuUsername" class="font-bold text-white text-2xl block mb-2" style="word-wrap: break-word; overflow-wrap: break-word; max-width: 100%;">Admin</span>
                                <span class="text-gray-400 text-base">EventHub Member</span>
                            </div>
                            <div class="px-3 pb-3">
                                <div class="bg-gray-800/50 rounded-2xl p-2 space-y-1">
                                    <a href="#profile" onclick="showPage('profile'); closeUserMenu();" class="flex items-center px-4 py-3 rounded-xl hover:bg-gray-700/80 text-white transition-all duration-200">
                                        <i class="fas fa-user-circle mr-4 text-gray-400 text-xl w-6 text-center"></i>
                                        <span class="text-lg">Profile</span>
                                        <i class="fas fa-chevron-right ml-auto text-gray-500"></i>
                                    </a>
                                    <a href="#settings" onclick="showPage('settings'); closeUserMenu();" class="flex items-center px-4 py-3 rounded-xl hover:bg-gray-700/80 text-white transition-all duration-200">
                                        <i class="fas fa-cog mr-4 text-gray-400 text-xl w-6 text-center"></i>
                                        <span class="text-lg">Settings</span>
                                        <i class="fas fa-chevron-right ml-auto text-gray-500"></i>
                                    </a>
                                    <div class="border-t border-gray-700 my-2"></div>
                                    <a href="#" onclick="handleLogout();" class="flex items-center px-4 py-3 rounded-xl hover:bg-red-600/30 text-red-300 transition-all duration-200">
                                        <i class="fas fa-sign-out-alt mr-4 text-red-400 text-xl w-6 text-center"></i>
                                        <span class="text-lg">Logout</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="search-area">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" placeholder="Search events..." id="searchInput">
                </div>
            </header>

            <div class="content-area">
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
    </div>

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
    
    <script src="static/js/app.js"></script>
</body>
</html>