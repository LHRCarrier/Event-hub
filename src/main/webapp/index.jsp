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
                    <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-circle me-2"></i> <span id="currentUsername">Admin</span>
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
            </nav>
        </div>

        <div class="col-10 content p-4">
            <div id="page-home" class="page-content">
                <h2 class="mb-4">Welcome to EventHub</h2>
                <div class="row mb-6" id="statsRow">
                    <div class="col-md-3">
                        <div class="stat-card p-4 bg-white">
                            <div class="text-3xl mb-2">📅</div>
                            <div class="text-2xl font-bold text-gray-800" id="statUpcoming">24</div>
                            <div class="text-sm text-gray-500">Upcoming Events</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card p-4 bg-white">
                            <div class="text-3xl mb-2">👥</div>
                            <div class="text-2xl font-bold text-gray-800" id="statParticipants">156</div>
                            <div class="text-sm text-gray-500">Participants</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card p-4 bg-white">
                            <div class="text-3xl mb-2">👤</div>
                            <div class="text-2xl font-bold text-gray-800" id="statUsers">89</div>
                            <div class="text-sm text-gray-500">Active Users</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card p-4 bg-white">
                            <div class="text-3xl mb-2">🏷️</div>
                            <div class="text-2xl font-bold text-gray-800" id="statCategories">8</div>
                            <div class="text-sm text-gray-500">Categories</div>
                        </div>
                    </div>
                </div>

                <div class="mb-4 d-flex justify-content-between">
                    <h3>Upcoming Events</h3>
                    <a href="#events" onclick="showPage('events')" class="text-primary">View All →</a>
                </div>
                <div class="row" id="eventList">
                </div>
            </div>

            <div id="page-events" class="page-content d-none">
                <div class="d-flex justify-content-between mb-4">
                    <h2>Events Management</h2>
                    <button class="btn btn-primary" onclick="showPage('create-event')">+ New Event</button>
                </div>
                <div class="table-container p-4">
                    <table class="table" id="eventsTable">
                        <thead>
                            <tr>
                                <th>Event Name</th>
                                <th>Date</th>
                                <th>Location</th>
                                <th>Category</th>
                                <th>Status</th>
                                <th>Participants</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <nav class="mt-4" aria-label="Page navigation">
                        <ul class="pagination justify-content-center" id="eventsPagination"></ul>
                    </nav>
                </div>
            </div>

            <div id="page-event-detail" class="page-content d-none">
                <div class="mb-4">
                    <button class="btn btn-outline-primary" onclick="showPage('events')">← Back</button>
                </div>
                <div class="bg-white rounded-xl overflow-hidden" id="eventDetail">
                </div>
            </div>

            <div id="page-create-event" class="page-content d-none">
                <div class="mb-4">
                    <button class="btn btn-outline-primary" onclick="showPage('events')">← Back</button>
                </div>
                <div class="bg-white rounded-xl p-6 max-w-2xl mx-auto">
                    <h2 class="text-xl font-bold mb-6">Create New Event</h2>
                    <form id="createEventForm">
                        <div class="mb-4">
                            <label class="form-label font-medium">Event Name</label>
                            <input type="text" class="form-control" id="eventName" placeholder="Enter event name">
                        </div>
                        <div class="mb-4">
                            <label class="form-label font-medium">Event Date</label>
                            <input type="datetime-local" class="form-control" id="eventDate">
                        </div>
                        <div class="mb-4">
                            <label class="form-label font-medium">Location</label>
                            <input type="text" class="form-control" id="eventLocation" placeholder="Enter location">
                        </div>
                        <div class="mb-4">
                            <label class="form-label font-medium">Category</label>
                            <select class="form-control" id="eventCategory"></select>
                        </div>
                        <div class="mb-4">
                            <label class="form-label font-medium">Description</label>
                            <textarea class="form-control" rows="4" id="eventDescription" placeholder="Enter event description"></textarea>
                        </div>
                        <div class="d-flex gap-3">
                            <button type="button" class="btn btn-secondary" onclick="showPage('events')">Cancel</button>
                            <button type="submit" class="btn btn-primary ms-auto">Create Event</button>
                        </div>
                    </form>
                </div>
            </div>

            <div id="page-registrations" class="page-content d-none">
                <h2 class="mb-4">Registrations Management</h2>
                <div class="table-container p-4">
                    <table class="table" id="registrationsTable">
                        <thead>
                            <tr>
                                <th>Event Name</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Register Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>

            <div id="page-users" class="page-content d-none">
                <div class="d-flex justify-content-between mb-4">
                    <h2>Users Management</h2>
                    <button class="btn btn-primary" onclick="showPage('create-user')">+ New User</button>
                </div>
                <div class="table-container p-4">
                    <table class="table" id="usersTable">
                        <thead>
                            <tr>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <nav class="mt-4" aria-label="Page navigation">
                        <ul class="pagination justify-content-center" id="usersPagination"></ul>
                    </nav>
                </div>
            </div>

            <div id="page-categories" class="page-content d-none">
                <div class="d-flex justify-content-between mb-4">
                    <h2>Categories Management</h2>
                    <button class="btn btn-primary" onclick="showPage('create-category')">+ New Category</button>
                </div>
                <div class="row" id="categoriesList">
                </div>
            </div>

            <div id="page-create-category" class="page-content d-none">
                <div class="mb-4">
                    <button class="btn btn-outline-primary" onclick="showPage('categories')">← Back</button>
                </div>
                <div class="bg-white rounded-xl p-6 max-w-2xl mx-auto">
                    <h2 class="text-xl font-bold mb-6">Create New Category</h2>
                    <form id="createCategoryForm">
                        <div class="mb-4">
                            <label class="form-label font-medium">Category Name</label>
                            <input type="text" class="form-control" id="categoryName" placeholder="Enter category name">
                        </div>
                        <div class="mb-4">
                            <label class="form-label font-medium">Description</label>
                            <textarea class="form-control" rows="3" id="categoryDescription" placeholder="Enter description"></textarea>
                        </div>
                        <div class="d-flex gap-3">
                            <button type="button" class="btn btn-secondary" onclick="showPage('categories')">Cancel</button>
                            <button type="submit" class="btn btn-primary ms-auto">Create Category</button>
                        </div>
                    </form>
                </div>
            </div>

            <div id="page-dashboard" class="page-content d-none">
                <h2 class="mb-4">Admin Dashboard</h2>
                <div class="row mb-6" id="dashboardStats">
                    <div class="col-md-3">
                        <div class="stat-card p-4 bg-white">
                            <div class="text-3xl mb-2">📊</div>
                            <div class="text-2xl font-bold text-gray-800" id="dbTotalRegistrations">156</div>
                            <div class="text-sm text-gray-500">Total Registrations</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card p-4 bg-white">
                            <div class="text-3xl mb-2">📅</div>
                            <div class="text-2xl font-bold text-gray-800" id="dbTotalEvents">48</div>
                            <div class="text-sm text-gray-500">Total Events</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card p-4 bg-white">
                            <div class="text-3xl mb-2">👤</div>
                            <div class="text-2xl font-bold text-gray-800" id="dbTotalUsers">128</div>
                            <div class="text-sm text-gray-500">Total Users</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-card p-4 bg-white">
                            <div class="text-3xl mb-2">📈</div>
                            <div class="text-2xl font-bold text-green-600">+24%</div>
                            <div class="text-sm text-gray-500">Growth Rate</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="bg-white rounded-xl p-4 shadow-sm">
                            <h3 class="font-bold mb-4">Event Registrations Trend</h3>
                            <div class="h-48 bg-gray-50 rounded-lg flex items-end justify-around p-4">
                                <div class="flex flex-col items-center">
                                    <div class="w-10 bg-primary rounded-t" style="height: 100px;"></div>
                                    <span class="text-xs mt-2">Jan</span>
                                </div>
                                <div class="flex flex-col items-center">
                                    <div class="w-10 bg-primary rounded-t" style="height: 120px;"></div>
                                    <span class="text-xs mt-2">Feb</span>
                                </div>
                                <div class="flex flex-col items-center">
                                    <div class="w-10 bg-primary rounded-t" style="height: 80px;"></div>
                                    <span class="text-xs mt-2">Mar</span>
                                </div>
                                <div class="flex flex-col items-center">
                                    <div class="w-10 bg-primary rounded-t" style="height: 150px;"></div>
                                    <span class="text-xs mt-2">Apr</span>
                                </div>
                                <div class="flex flex-col items-center">
                                    <div class="w-10 bg-primary rounded-t" style="height: 180px;"></div>
                                    <span class="text-xs mt-2">May</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="bg-white rounded-xl p-4 shadow-sm">
                            <h3 class="font-bold mb-4">Events by Category</h3>
                            <div class="h-48 flex items-center justify-center">
                                <div class="relative w-32 h-32">
                                    <div class="absolute inset-0 rounded-full bg-primary/60" style="clip-path: polygon(50% 50%, 50% 0%, 100% 0%, 100% 100%, 0% 100%, 0% 0%, 30% 0%);"></div>
                                    <div class="absolute inset-0 rounded-full bg-orange-500/60" style="clip-path: polygon(50% 50%, 30% 0%, 50% 0%);"></div>
                                    <div class="absolute inset-0 rounded-full bg-pink-500/60" style="clip-path: polygon(50% 50%, 50% 0%, 70% 0%);"></div>
                                    <div class="absolute inset-0 rounded-full bg-green-500/60" style="clip-path: polygon(50% 50%, 70% 0%, 100% 0%);"></div>
                                    <div class="absolute inset-4 rounded-full bg-white flex items-center justify-center">
                                        <span class="text-xs text-center">8<br>Categories</span>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 space-y-2">
                                <div class="flex items-center"><span class="w-3 h-3 bg-primary rounded mr-2"></span><span class="text-sm">Tech (35%)</span></div>
                                <div class="flex items-center"><span class="w-3 h-3 bg-orange-500 rounded mr-2"></span><span class="text-sm">Sports (25%)</span></div>
                                <div class="flex items-center"><span class="w-3 h-3 bg-pink-500 rounded mr-2"></span><span class="text-sm">Cultural (20%)</span></div>
                                <div class="flex items-center"><span class="w-3 h-3 bg-green-500 rounded mr-2"></span><span class="text-sm">Art (20%)</span></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-6 bg-white rounded-xl p-4 shadow-sm">
                    <h3 class="font-bold mb-4">Recent Activities</h3>
                    <div class="space-y-3" id="recentActivities">
                    </div>
                </div>
            </div>

            <div id="page-profile" class="page-content d-none">
                <h2 class="mb-4">Profile Settings</h2>
                <div class="bg-white rounded-xl p-6 max-w-2xl mx-auto">
                    <form id="profileForm">
                        <div class="mb-4">
                            <label class="form-label font-medium">Username</label>
                            <input type="text" class="form-control" id="profileUsername" readonly>
                        </div>
                        <div class="mb-4">
                            <label class="form-label font-medium">Email</label>
                            <input type="email" class="form-control" id="profileEmail">
                        </div>
                        <div class="mb-4">
                            <label class="form-label font-medium">Phone</label>
                            <input type="text" class="form-control" id="profilePhone" placeholder="Enter phone number">
                        </div>
                        <div class="mb-4">
                            <label class="form-label font-medium">Real Name</label>
                            <input type="text" class="form-control" id="profileRealName" placeholder="Enter real name">
                        </div>
                        <div class="d-flex gap-3">
                            <button type="button" class="btn btn-secondary" onclick="showPage('home')">Cancel</button>
                            <button type="submit" class="btn btn-primary ms-auto">Update Profile</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        const API_BASE = '${pageContext.request.contextPath}/api';
        const redirectUrl = "<%= redirectUrl.replace("\\", "\\\\").replace("\"", "\\\"") %>";
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="static/js/app.js"></script>
</body>
</html>