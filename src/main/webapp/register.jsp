<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub - Register</title>
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
        .register-container {
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
        .form-text {
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="text-center mb-6">
            <div class="logo mb-3">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <h1 class="text-xl font-bold text-gray-800">EventHub</h1>
            <p class="text-gray-500 mt-1">Create your account</p>
        </div>

        <div id="registerAlert" class="alert alert-danger d-none" role="alert">
            <i class="fas fa-exclamation-circle mr-2"></i>
            <span id="alertMessage"></span>
        </div>

        <div id="successAlert" class="alert alert-success d-none" role="alert">
            <i class="fas fa-check-circle mr-2"></i>
            Registration successful! Redirecting to login...
        </div>

        <form id="registerForm">
            <div class="mb-3">
                <label class="form-label font-medium">Email</label>
                <input type="email" class="form-control" id="registerEmail" placeholder="Enter email" required>
                <div class="form-text text-gray-500">We'll never share your email with anyone else.</div>
            </div>
            <div class="mb-3">
                <label class="form-label font-medium">Username</label>
                <input type="text" class="form-control" id="registerUsername" placeholder="Enter username" required>
                <div class="form-text text-gray-500">3-50 characters</div>
            </div>
            <div class="mb-3">
                <label class="form-label font-medium">Password</label>
                <input type="password" class="form-control" id="registerPassword" placeholder="Enter password" required>
                <div class="form-text text-gray-500">At least 6 characters</div>
            </div>
            <div class="mb-4">
                <label class="form-label font-medium">Confirm Password</label>
                <input type="password" class="form-control" id="registerConfirmPassword" placeholder="Confirm password" required>
            </div>
            <button type="submit" class="btn btn-primary w-full mb-4">Register</button>
            <div class="text-center">
                <a href="login.jsp" class="text-primary">Already have an account? Login here</a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const API_BASE = '${pageContext.request.contextPath}/api';

        document.getElementById('registerForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const alertDiv = document.getElementById('registerAlert');
            const successDiv = document.getElementById('successAlert');
            alertDiv.classList.add('d-none');
            successDiv.classList.add('d-none');

            const email = document.getElementById('registerEmail').value;
            const username = document.getElementById('registerUsername').value;
            const password = document.getElementById('registerPassword').value;
            const confirmPassword = document.getElementById('registerConfirmPassword').value;

            if (password !== confirmPassword) {
                showError('Passwords do not match');
                return;
            }

            if (password.length < 6) {
                showError('Password must be at least 6 characters');
                return;
            }

            if (username.length < 3 || username.length > 50) {
                showError('Username must be between 3 and 50 characters');
                return;
            }

            try {
                const response = await fetch(API_BASE + '/auth/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username, password, email })
                });

                const result = await response.json();

                if (result.code === 201) {
                    successDiv.classList.remove('d-none');
                    setTimeout(() => {
                        window.location.href = 'login.jsp';
                    }, 2000);
                } else {
                    showError(result.message);
                }
            } catch (error) {
                showError('Network error. Please try again later.');
            }
        });

        function showError(message) {
            const alertDiv = document.getElementById('registerAlert');
            document.getElementById('alertMessage').textContent = message;
            alertDiv.classList.remove('d-none');
        }
    </script>
</body>
</html>
