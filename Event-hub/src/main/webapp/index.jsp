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
    <link href="static/css/index.css" rel="stylesheet">
</head>
<body>
    <!-- 页面加载动画 -->
    <div id="page-loader" class="page-loader">
        <div class="loader-container">
            <div class="loader-ring"></div>
            <div class="loader-ring"></div>
            <div class="loader-ring"></div>
            <div class="loader-text">Loading EventHub</div>
            <div class="loader-progress">
                <div class="loader-progress-bar"></div>
            </div>
        </div>
    </div>

    <div id="background-container" class="background-container">
        <div id="video-background" class="video-background">
            <video id="bg-video" autoplay muted loop playsinline>
                <source src="static/video/5月18日.mp4" type="video/mp4">
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
                    <a class="nav-link nav-parent" href="#" onclick="toggleCommunitiesSubnav(event)" data-route="communities">
                        <i class="fas fa-users"></i> Communities
                        <i class="fas fa-chevron-down subnav-arrow ms-auto"></i>
                    </a>
                    <div class="subnav" id="communitiesSubnav">
                        <a class="nav-link sub" href="#communities" onclick="showCommunitiesFilter('all')" data-route="communities">
                            <i class="fas fa-globe"></i> All Communities
                        </a>
                        <a class="nav-link sub" href="#communities" onclick="showCommunitiesFilter('joined')" data-route="communities">
                            <i class="fas fa-user-check"></i> My Joined
                        </a>
                        <a class="nav-link sub" href="#communities" onclick="showCommunitiesFilter('created')" data-route="communities">
                            <i class="fas fa-user-edit"></i> My Created
                        </a>
                        <a class="nav-link sub create-community" href="#create-community" onclick="showPage('create-community')" data-route="create-community">
                            <i class="fas fa-plus-circle"></i> Create Community
                        </a>
                    </div>
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
                <div id="userMenuContainer" class="user-area" style="position: relative; z-index: 99999;">
                    <div id="avatarWrapper" class="avatar-trigger" style="width: 48px; height: 48px; cursor: pointer; position: relative; z-index: 100000;">
                        <div id="avatarInner" class="avatar-inner" style="position: absolute; inset: 0; border-radius: 50%; overflow: hidden; border: 2px solid transparent; transition: all 0.3s ease-out;">
                            <img id="headerAvatar" src="" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; display: none;">
                            <span id="headerAvatarInitial" style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 18px; background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);">U</span>
                        </div>
                    </div>
                    <div id="avatarContainer" class="opacity-0 invisible pointer-events-none" style="position: fixed; top: 0; left: 0; width: 100px; height: 100px; z-index: 99999;">
                        <div style="width: 100%; height: 100%; border-radius: 50%; border: 2px solid rgba(255, 255, 255, 0.15); box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15), inset 0 1px 0 rgba(255, 255, 255, 0.1); background: linear-gradient(135deg, rgba(30, 41, 59, 0.95), rgba(45, 55, 72, 0.9));">
                            <div style="width: calc(100% - 4px); height: calc(100% - 4px); border-radius: 50%; overflow: hidden; position: absolute; top: 2px; left: 2px;">
                                <img id="menuAvatar" src="" alt="Avatar" style="width: 100%; height: 100%; object-fit: cover; object-position: center; display: none;">
                                <span id="menuAvatarInitial" style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 40px; background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);">U</span>
                            </div>
                        </div>
                    </div>
                    <div id="userMenu" class="opacity-0 invisible pointer-events-none" style="position: fixed; z-index: 99998; width: 280px; background: linear-gradient(135deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0.03)); border-radius: 20px; border: 1px solid rgba(255, 255, 255, 0.12); transform: scale(0.95) translateY(-10px); transform-origin: 50% 0; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2), inset 0 1px 0 rgba(255, 255, 255, 0.1); backdrop-filter: blur(0px); -webkit-backdrop-filter: blur(0px); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);">
                        <div style="height: 40px; background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%); border-radius: 20px 20px 0 0;"></div>
                        <div style="padding: 16px 16px 8px; text-align: center;">
                            <span id="menuUsername" style="font-weight: 600; color: white; font-size: 16px; display: block; margin-bottom: 2px; word-wrap: break-word; overflow-wrap: break-word; max-width: 100%;">Admin</span>
                            <span style="color: var(--white-60); font-size: 13px;">EventHub Member</span>
                        </div>
                        <div style="padding: 0 10px 10px;">
                            <div style="background: rgba(255, 255, 255, 0.04); border-radius: 16px; padding: 3px; border: 1px solid rgba(255, 255, 255, 0.06);">
                                <a href="#profile" onclick="showPage('profile'); closeUserMenu();" style="display: flex; align-items: center; padding: 10px 14px; border-radius: 12px; color: var(--white-80); text-decoration: none; transition: all 0.2s ease;" onmouseenter="this.style.background='rgba(255,255,255,0.08)'; this.style.color='white';" onmouseleave="this.style.background='transparent'; this.style.color='var(--white-80)';">
                                    <i class="fas fa-user-circle" style="color: var(--white-50); font-size: 16px; width: 18px; text-align: center; margin-right: 12px;"></i>
                                    <span style="font-size: 14px; flex: 1;">Personal Center</span>
                                    <i class="fas fa-chevron-right" style="color: var(--white-40); font-size: 12px;"></i>
                                </a>
                                <a href="#settings" onclick="showPage('settings'); closeUserMenu();" style="display: flex; align-items: center; padding: 10px 14px; border-radius: 12px; color: var(--white-80); text-decoration: none; transition: all 0.2s ease;" onmouseenter="this.style.background='rgba(255,255,255,0.08)'; this.style.color='white';" onmouseleave="this.style.background='transparent'; this.style.color='var(--white-80)';">
                                    <i class="fas fa-cog" style="color: var(--white-50); font-size: 16px; width: 18px; text-align: center; margin-right: 12px;"></i>
                                    <span style="font-size: 14px; flex: 1;">Settings</span>
                                    <i class="fas fa-chevron-right" style="color: var(--white-40); font-size: 12px;"></i>
                                </a>
                                <div style="border-top: 1px solid rgba(255, 255, 255, 0.05); margin: 3px 0;"></div>
                                <a href="#" onclick="handleLogout();" style="display: flex; align-items: center; padding: 10px 14px; border-radius: 12px; color: var(--accent-red); text-decoration: none; transition: all 0.2s ease;" onmouseenter="this.style.background='rgba(232, 116, 116, 0.15)';" onmouseleave="this.style.background='transparent';">
                                    <i class="fas fa-sign-out-alt" style="color: var(--accent-red); font-size: 16px; width: 18px; text-align: center; margin-right: 12px;"></i>
                                    <span style="font-size: 14px;">Logout</span>
                                </a>
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
        // 页面加载动画控制
        (function() {
            function hideLoader() {
                const loader = document.getElementById('page-loader');
                if (loader) {
                    loader.classList.add('hidden');
                    setTimeout(() => {
                        loader.style.display = 'none';
                    }, 600);
                }
            }

            // 监听窗口加载完成
            window.addEventListener('load', function() {
                // 延迟隐藏加载动画，确保体验流畅
                setTimeout(hideLoader, 1200);
            });

            // 如果页面已经加载完成，直接隐藏
            if (document.readyState === 'complete') {
                setTimeout(hideLoader, 500);
            }
        })();

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