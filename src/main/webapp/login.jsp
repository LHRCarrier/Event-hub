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
            --primary-color: #25B8A6;
            --primary-dark: #1A8E83;
            --white-95: rgba(255, 255, 255, 0.95);
            --white-90: rgba(255, 255, 255, 0.9);
            --white-70: rgba(255, 255, 255, 0.7);
            --white-65: rgba(255, 255, 255, 0.65);
            --white-20: rgba(255, 255, 255, 0.2);
            --white-12: rgba(255, 255, 255, 0.12);
            --white-10: rgba(255, 255, 255, 0.1);
            --white-08: rgba(255, 255, 255, 0.08);
        }
        body {
            background: linear-gradient(180deg, #0f172a 0%, #1e293b 50%, #334155 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
        }
        .login-container {
            max-width: 420px;
            width: 100%;
            margin: 20px;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            padding: 48px;
        }
        .logo-circle {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 4px 16px rgba(37, 184, 166, 0.4);
        }
        .logo-icon {
            font-size: 1.8rem;
            color: white;
        }
        .form-control {
            background: rgba(255, 255, 255, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 12px;
            color: var(--white-90);
            padding: 14px 16px;
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 184, 166, 0.2);
            background: rgba(255, 255, 255, 0.08);
            color: var(--white-90);
        }
        .form-control::placeholder {
            color: var(--white-65);
        }
        .form-label {
            color: var(--white-90);
            font-weight: 500;
        }
        .form-check-input {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(255, 255, 255, 0.2);
        }
        .form-check-input:checked {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }
        .form-check-label {
            color: var(--white-70);
        }
        .btn-primary {
            background-color: var(--primary-color) !important;
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-size: 16px;
            font-weight: 600;
        }
        .btn-primary:hover {
            background-color: var(--primary-dark) !important;
            box-shadow: 0 4px 16px rgba(37, 184, 166, 0.4);
        }
        .alert {
            border-radius: 12px;
            background: rgba(232, 116, 116, 0.2);
            border-color: rgba(232, 116, 116, 0.3);
            color: #E87474;
        }
        .text-primary {
            color: var(--primary-color);
        }
        .text-gray-800 {
            color: var(--white-95);
        }
        .text-gray-500 {
            color: var(--white-65);
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="text-center mb-6">
            <div class="logo-circle">
                <i class="fas fa-calendar-alt logo-icon"></i>
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
        const ctxPath = window.location.pathname.split('/')[1] || '';
        const API_BASE = '/' + ctxPath;
        
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
                const response = await fetch(API_BASE + '/api/auth/login', {
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
                        token: result.data.token,
                        avatarUrl: result.data.avatarUrl
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
