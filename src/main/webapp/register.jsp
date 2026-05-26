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
        .register-container {
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
        }
        .alert-danger {
            background: rgba(232, 116, 116, 0.2);
            border-color: rgba(232, 116, 116, 0.3);
            color: #E87474;
        }
        .alert-success {
            background: rgba(126, 217, 87, 0.2);
            border-color: rgba(126, 217, 87, 0.3);
            color: #7ED957;
        }
        .form-text {
            font-size: 12px;
            color: var(--white-65);
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
    <div class="register-container">
        <div class="text-center mb-6">
            <div class="logo-circle">
                <i class="fas fa-calendar-alt logo-icon"></i>
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
        const ctxPath = window.location.pathname.split('/')[1] || '';
        const API_BASE = '/' + ctxPath;

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
                const response = await fetch(API_BASE + '/api/auth/register', {
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
