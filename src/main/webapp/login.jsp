<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String redirectUrl = (String) session.getAttribute("redirect_url");
    if (redirectUrl != null) {
        session.removeAttribute("redirect_url");
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1e88e5;
            --bg-color: #f5f7fa;
        }
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            max-width: 420px;
            width: 100%;
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.15);
            padding: 48px;
        }
        .logo {
            font-size: 2.5rem;
            color: var(--primary-color);
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(30, 136, 229, 0.25);
        }
        .btn-primary {
            background-color: var(--primary-color) !important;
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-size: 16px;
        }
        .btn-primary:hover {
            background-color: #1976d2 !important;
        }
        .alert {
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="text-center mb-6">
            <div class="logo mb-3">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <h1 class="text-xl font-bold text-gray-800">EventHub</h1>
            <p class="text-gray-500 mt-1">Community Event Management</p>
        </div>

        <div id="loginAlert" class="alert alert-danger d-none" role="alert">
            <i class="fas fa-exclamation-circle mr-2"></i>
            <span id="alertMessage"></span>
        </div>

        <form id="loginForm">
            <div class="mb-4">
                <label class="form-label font-medium">Username</label>
                <input type="text" class="form-control" id="loginUsername" placeholder="Enter username" required>
            </div>
            <div class="mb-4">
                <label class="form-label font-medium">Password</label>
                <input type="password" class="form-control" id="loginPassword" placeholder="Enter password" required>
            </div>
            <div class="mb-4 form-check">
                <input type="checkbox" class="form-check-input" id="rememberMe">
                <label class="form-check-label" for="rememberMe">Remember me</label>
            </div>
            <button type="submit" class="btn btn-primary w-full mb-4">Login</button>
            <div class="text-center">
                <a href="register.jsp" class="text-primary">Don't have an account? Register here</a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const API_BASE = '${pageContext.request.contextPath}/api';
        
        // Check if there's a redirect URL from server session
        <% if (redirectUrl != null) { %>
            if (!sessionStorage.getItem('redirect_url')) {
                sessionStorage.setItem('redirect_url', '<%= redirectUrl.replace("\\", "\\\\").replace("\"", "\\\"") %>');
            }
        <% } %>

        document.getElementById('loginForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const alertDiv = document.getElementById('loginAlert');
            alertDiv.classList.add('d-none');

            const username = document.getElementById('loginUsername').value;
            const password = document.getElementById('loginPassword').value;
            const rememberMe = document.getElementById('rememberMe').checked;

            try {
                const response = await fetch(API_BASE + '/auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username, password })
                });

                const result = await response.json();

                if (result.code === 200) {
                    const userData = {

                        userId: result.data.userId,
                        username: result.data.username,
                        role: result.data.role,
                        token: result.data.token
                    };
                    console.log("用户登录数据:",userData)

                    if (rememberMe) {
                        localStorage.setItem('eventhub_user', JSON.stringify(userData));
                    } else {
                        sessionStorage.setItem('eventhub_user', JSON.stringify(userData));
                    }

                    // Get redirect URL, default to index.jsp
                    const redirectUrl = sessionStorage.getItem('redirect_url') || 'index.jsp';
                    sessionStorage.removeItem('redirect_url');
                    
                    window.location.href = redirectUrl;
                } else {
                    showError(result.message);
                }
            } catch (error) {
                showError('Network error. Please try again later.');
            }
        });

        function showError(message) {
            const alertDiv = document.getElementById('loginAlert');
            document.getElementById('alertMessage').textContent = message;
            alertDiv.classList.remove('d-none');
        }

        window.addEventListener('load', function() {
            // If user is already logged in, redirect
            const savedUser = localStorage.getItem('eventhub_user') || sessionStorage.getItem('eventhub_user');
            if (savedUser) {
                const redirectUrl = sessionStorage.getItem('redirect_url') || 'index.jsp';
                sessionStorage.removeItem('redirect_url');
                window.location.href = redirectUrl;
            }
        });
    </script>
</body>
</html>
