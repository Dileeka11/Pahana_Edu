<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Pahana Edu</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <style>
        :root {
            --primary: linear-gradient(135deg, #3b82f6 0%, #60a5fa 100%);
            --primary-solid: #3b82f6;
            --secondary: #f8fafc;
            --accent: #06b6d4;
            --text-primary: #1a202c;
            --text-secondary: #718096;
            --border: rgba(226, 232, 240, 0.8);
            --shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --shadow-hover: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            --glass: rgba(255, 255, 255, 0.25);
            --glass-border: rgba(255, 255, 255, 0.18);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            background: linear-gradient(-45deg, #3b82f6, #60a5fa, #0ea5e9, #06b6d4);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
        }

        .shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 50%;
            animation: float 20s infinite linear;
        }

        .shape:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }

        .shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 60%;
            left: 80%;
            animation-delay: -5s;
        }

        .shape:nth-child(3) {
            width: 60px;
            height: 60px;
            top: 80%;
            left: 20%;
            animation-delay: -10s;
        }

        .shape:nth-child(4) {
            width: 100px;
            height: 100px;
            top: 10%;
            left: 70%;
            animation-delay: -15s;
        }

        @keyframes float {
            0% { transform: translateY(0px) rotate(0deg); opacity: 1; }
            50% { opacity: 0.8; }
            100% { transform: translateY(-100vh) rotate(360deg); opacity: 0; }
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: var(--shadow);
            width: 100%;
            max-width: 440px;
            padding: 48px;
            position: relative;
            z-index: 1;
            transform: translateY(20px);
            opacity: 0;
            animation: slideUp 0.8s ease forwards;
        }

        @keyframes slideUp {
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .logo {
            width: 80px;
            height: 80px;
            margin: 0 auto 24px;
            background: var(--primary);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: white;
            font-weight: 800;
            box-shadow: var(--shadow);
            animation: logoFloat 3s ease-in-out infinite;
            position: relative;
            overflow: hidden;
        }

        .logo::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            animation: logoShine 4s infinite;
        }

        .logo-text {
            position: relative;
            z-index: 2;
            font-family: 'Inter', sans-serif;
            letter-spacing: -1px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        @keyframes logoFloat {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-8px) rotate(1deg); }
        }

        @keyframes logoShine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            50% { transform: translateX(100%) translateY(100%) rotate(45deg); }
            100% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
        }

        .login-header h1 {
            color: var(--text-primary);
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
            background: var(--primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .login-header p {
            color: var(--text-secondary);
            font-size: 16px;
            font-weight: 400;
        }

        .form-group {
            margin-bottom: 24px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-primary);
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .input-container {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            font-size: 16px;
            transition: all 0.3s ease;
            z-index: 2;
        }

        .form-group input {
            width: 100%;
            padding: 16px 16px 16px 48px;
            border: 2px solid var(--border);
            border-radius: 12px;
            font-size: 16px;
            font-weight: 400;
            background: rgba(248, 250, 252, 0.8);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .form-group input:focus {
            border-color: var(--primary-solid);
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            outline: none;
            background: white;
            transform: translateY(-2px);
        }

        .form-group input:focus + .input-icon {
            color: var(--primary-solid);
            transform: translateY(-50%) scale(1.1);
        }

        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
            font-size: 16px;
            padding: 4px;
            transition: all 0.3s ease;
            z-index: 2;
        }

        .password-toggle:hover {
            color: var(--primary-solid);
            transform: translateY(-50%) scale(1.1);
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 20px 0 32px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: var(--primary-solid);
        }

        .remember-me label {
            font-size: 14px;
            color: var(--text-secondary);
            margin: 0;
        }

        .forgot-password {
            color: var(--primary-solid);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            position: relative;
        }

        .forgot-password::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -2px;
            left: 0;
            background: var(--primary-solid);
            transition: width 0.3s ease;
        }

        .forgot-password:hover::after {
            width: 100%;
        }

        .login-button {
            width: 100%;
            padding: 16px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: var(--shadow);
        }

        .login-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }

        .login-button:hover::before {
            left: 100%;
        }

        .login-button:active {
            transform: translateY(0);
        }

        .login-button:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }



        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 32px 24px;
                margin: 16px;
            }

            .login-header h1 {
                font-size: 28px;
            }

            .form-group input {
                padding: 14px 14px 14px 44px;
                font-size: 14px;
            }

            .social-login {
                grid-template-columns: 1fr;
            }
        }

        .error-shake {
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        .success-checkmark {
            display: inline-block;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #4caf50;
            color: white;
            text-align: center;
            line-height: 20px;
            font-size: 12px;
            margin-right: 8px;
            animation: checkmark 0.3s ease-in-out;
        }

        @keyframes checkmark {
            0% { transform: scale(0); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
<div class="floating-shapes">
    <div class="shape"></div>
    <div class="shape"></div>
    <div class="shape"></div>
    <div class="shape"></div>
</div>

<div class="login-container">
    <div class="login-header">
        <div class="logo">
            <span class="logo-text">PE</span>
        </div>
        <h1>Welcome Back</h1>
        <p>Sign in to continue your learning journey</p>
    </div>

    <form method="post" action="login" id="loginForm">
        <div class="form-group">
            <label for="email">Email Address</label>
            <div class="input-container">
                <input
                        type="email"
                        id="email"
                        name="email"
                        required
                        placeholder="Enter your email"
                        autocomplete="username"
                        autofocus
                >
                <i class="fas fa-envelope input-icon"></i>
            </div>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <div class="input-container">
                <input
                        type="password"
                        id="password"
                        name="password"
                        required
                        placeholder="Enter your password"
                        autocomplete="current-password"
                >
                <i class="fas fa-lock input-icon"></i>
                <button type="button" class="password-toggle" id="passwordToggle">
                    <i class="fas fa-eye"></i>
                </button>
            </div>
        </div>

        <div class="form-options">
            <div class="remember-me">
                <input type="checkbox" id="remember" name="remember">
                <label for="remember">Remember me</label>
            </div>
            <a href="#" class="forgot-password">Forgot Password?</a>
        </div>

        <button type="submit" class="login-button" id="loginBtn">
            Sign In
        </button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('loginForm');
        const passwordToggle = document.getElementById('passwordToggle');
        const passwordInput = document.getElementById('password');
        const loginBtn = document.getElementById('loginBtn');
        const forgotPasswordLink = document.querySelector('.forgot-password');

        // Password toggle functionality
        passwordToggle.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);

            const icon = this.querySelector('i');
            icon.classList.toggle('fa-eye');
            icon.classList.toggle('fa-eye-slash');
        });

        // Enhanced form validation and submission
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;

            // Reset any previous error states
            form.classList.remove('error-shake');

            // Validation
            if (!email || !password) {
                form.classList.add('error-shake');
                Swal.fire({
                    title: 'Missing Information',
                    text: 'Please fill in all fields',
                    icon: 'warning',
                    confirmButtonColor: '#3b82f6',
                    background: 'rgba(255, 255, 255, 0.95)',
                    backdrop: 'rgba(0, 0, 0, 0.4)'
                });
                return;
            }

            if (!isValidEmail(email)) {
                form.classList.add('error-shake');
                Swal.fire({
                    title: 'Invalid Email',
                    text: 'Please enter a valid email address',
                    icon: 'error',
                    confirmButtonColor: '#3b82f6'
                });
                return;
            }

            // Show loading state
            showLoadingState(true);

            // Simulate login process (replace with actual form submission)
            setTimeout(() => {
                // For demo purposes - replace with actual form submission
                form.submit();
            }, 1500);
        });

        // Check URL parameters for messages
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');
        const loginStatus = urlParams.get('login');

        if (loginStatus === 'success') {
            Swal.fire({
                title: 'Welcome Back!',
                text: 'You have successfully logged in.',
                icon: 'success',
                confirmButtonColor: '#3b82f6',
                timer: 3000,
                timerProgressBar: true,
                showConfirmButton: false,
                position: 'top-end',
                toast: true,
                background: 'rgba(255, 255, 255, 0.95)'
            });
        }

        if (error) {
            form.classList.add('error-shake');
            Swal.fire({
                title: 'Login Failed',
                text: 'Invalid email or password. Please try again.',
                icon: 'error',
                confirmButtonColor: '#3b82f6',
                confirmButtonText: 'Try Again',
                background: 'rgba(255, 255, 255, 0.95)',
                backdrop: 'rgba(0, 0, 0, 0.4)'
            });
        }

        // Forgot password functionality
        forgotPasswordLink.addEventListener('click', function(e) {
            e.preventDefault();

            Swal.fire({
                title: 'Reset Password',
                html: `
                        <div style="text-align: left; margin: 20px 0;">
                            <p style="color: #718096; margin-bottom: 15px;">Enter your email address and we'll send you a link to reset your password.</p>
                        </div>
                    `,
                input: 'email',
                inputPlaceholder: 'Enter your email address',
                inputAttributes: {
                    style: 'padding: 12px; border-radius: 8px; border: 2px solid #e2e8f0; font-size: 14px;'
                },
                showCancelButton: true,
                confirmButtonColor: '#3b82f6',
                cancelButtonColor: '#a0aec0',
                confirmButtonText: '<i class="fas fa-paper-plane"></i> Send Reset Link',
                showLoaderOnConfirm: true,
                background: 'rgba(255, 255, 255, 0.95)',
                backdrop: 'rgba(0, 0, 0, 0.4)',
                preConfirm: (email) => {
                    if (!isValidEmail(email)) {
                        Swal.showValidationMessage('Please enter a valid email address');
                        return false;
                    }

                    return new Promise((resolve) => {
                        setTimeout(() => {
                            resolve();
                        }, 2000);
                    });
                },
                allowOutsideClick: () => !Swal.isLoading()
            }).then((result) => {
                if (result.isConfirmed) {
                    Swal.fire({
                        title: 'Email Sent!',
                        html: '<i class="fas fa-check-circle" style="color: #4caf50; font-size: 24px; margin-bottom: 10px;"></i><br>We have sent a password reset link to your email address.',
                        icon: 'success',
                        confirmButtonColor: '#3b82f6',
                        background: 'rgba(255, 255, 255, 0.95)'
                    });
                }
            });
        });

        // Utility functions
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function showLoadingState(loading) {
            if (loading) {
                loginBtn.disabled = true;
                loginBtn.innerHTML = '<span class="loading-spinner"></span>Signing In...';
            } else {
                loginBtn.disabled = false;
                loginBtn.innerHTML = 'Sign In';
            }
        }

        // Add input focus animations
        const inputs = document.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.parentElement.querySelector('label').style.color = '#3b82f6';
            });

            input.addEventListener('blur', function() {
                if (!this.value) {
                    this.parentElement.parentElement.querySelector('label').style.color = '#1a202c';
                }
            });
        });

        // Clean up URL parameters
        if (urlParams.has('error') || urlParams.has('login')) {
            const cleanUrl = window.location.pathname;
            window.history.replaceState({}, document.title, cleanUrl);
        }
    });
</script>
</body>
</html>