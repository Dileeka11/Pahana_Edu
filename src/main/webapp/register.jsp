<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration - Pahana Edu</title>

    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer">

    <!-- SweetAlert2 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert2/11.10.3/sweetalert2.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert2/11.10.3/sweetalert2.min.css">

    <style>
        :root {
            /* Light Blue Color Palette */
            --primary-50: #f0f9ff;
            --primary-100: #e0f2fe;
            --primary-200: #bae6fd;
            --primary-300: #7dd3fc;
            --primary-400: #38bdf8;
            --primary-500: #0ea5e9;
            --primary-600: #0284c7;
            --primary-700: #0369a1;
            --primary-800: #075985;
            --primary-900: #0c4a6e;

            /* Accent Colors */
            --accent-cyan: #22d3ee;
            --accent-blue: #3b82f6;
            --accent-indigo: #6366f1;
            --accent-purple: #8b5cf6;

            /* Neutral Colors */
            --gray-50: #f8fafc;
            --gray-100: #f1f5f9;
            --gray-200: #e2e8f0;
            --gray-300: #cbd5e1;
            --gray-400: #94a3b8;
            --gray-500: #64748b;
            --gray-600: #475569;
            --gray-700: #334155;
            --gray-800: #1e293b;
            --gray-900: #0f172a;

            /* Status Colors */
            --red-50: #fef2f2;
            --red-500: #ef4444;
            --red-600: #dc2626;
            --green-50: #f0fdf4;
            --green-500: #22c55e;
            --green-600: #16a34a;

            /* Shadows & Effects */
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            --shadow-2xl: 0 25px 50px -12px rgb(0 0 0 / 0.25);
            --shadow-glow: 0 0 30px rgb(14 165 233 / 0.3);

            --radius: 12px;
            --radius-lg: 16px;
            --radius-xl: 24px;

            --backdrop: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            background: linear-gradient(135deg,
            #0ea5e9 0%,
            #38bdf8 25%,
            #7dd3fc 50%,
            #22d3ee 75%,
            #06b6d4 100%);
            background-size: 400% 400%;
            animation: gradientShift 20s ease infinite;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background:
                    radial-gradient(circle at 20% 80%, rgba(14, 165, 233, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(56, 189, 248, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 40% 40%, rgba(34, 211, 238, 0.2) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Floating particles */
        .particles {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: rgba(255, 255, 255, 0.6);
            border-radius: 50%;
            animation: float 8s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
                opacity: 0.4;
            }
            50% {
                transform: translateY(-30px) rotate(180deg);
                opacity: 0.8;
            }
        }

        /* Main container */
        .register-container {
            background: var(--backdrop);
            backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 3rem;
            width: 100%;
            max-width: 500px;
            box-shadow: var(--shadow-2xl), var(--shadow-glow);
            position: relative;
            overflow: hidden;
            animation: slideUp 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .register-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg,
            rgba(255, 255, 255, 0.1) 0%,
            rgba(255, 255, 255, 0.05) 100%);
            pointer-events: none;
            border-radius: var(--radius-xl);
        }

        .register-container::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg,
            var(--primary-500),
            var(--accent-cyan),
            var(--primary-400),
            var(--accent-blue));
            background-size: 400% 400%;
            animation: gradientShift 6s ease infinite;
            border-radius: var(--radius-xl) var(--radius-xl) 0 0;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(40px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Header */
        .register-header {
            text-align: center;
            margin-bottom: 2.5rem;
            position: relative;
            z-index: 2;
        }

        .register-header h1 {
            font-size: 2.5rem;
            font-weight: 900;
            background: linear-gradient(135deg,
            var(--primary-700) 0%,
            var(--primary-500) 50%,
            var(--accent-cyan) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            letter-spacing: -0.02em;
            position: relative;
        }

        .register-header h1::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(90deg, var(--primary-500), var(--accent-cyan));
            border-radius: 2px;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 0.7; width: 80px; }
            50% { opacity: 1; width: 100px; }
        }

        .register-header p {
            color: var(--gray-600);
            font-size: 1.1rem;
            font-weight: 500;
            margin-top: 1rem;
        }

        .register-header .icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
            border-radius: 50%;
            margin-bottom: 1.5rem;
            box-shadow: var(--shadow-lg), 0 0 30px rgba(14, 165, 233, 0.4);
            animation: bounce 2s ease-in-out infinite;
        }

        .register-header .icon i {
            font-size: 2rem;
            color: white;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        /* Form */
        .register-form {
            position: relative;
            z-index: 2;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
            letter-spacing: 0.025em;
        }

        .form-label i {
            margin-right: 0.5rem;
            color: var(--primary-500);
            font-size: 0.9rem;
        }

        .form-input {
            width: 100%;
            padding: 1rem 1.25rem;
            border: 2px solid var(--gray-200);
            border-radius: var(--radius);
            font-size: 1rem;
            font-weight: 500;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            color: var(--gray-700);
            box-shadow: var(--shadow-sm);
            position: relative;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary-500);
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.1), var(--shadow-lg);
            transform: translateY(-2px);
        }

        .form-input:read-only {
            background: var(--gray-50);
            border-color: var(--gray-300);
            color: var(--gray-500);
            cursor: not-allowed;
            position: relative;
        }

        .form-input:read-only::after {
            content: '🔒';
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 14px;
            opacity: 0.6;
        }

        .form-input::placeholder {
            color: var(--gray-400);
            font-weight: 400;
        }

        .form-input.error {
            border-color: var(--red-500);
            background: rgba(239, 68, 68, 0.05);
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.1);
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .form-input.success {
            border-color: var(--green-500);
            background: rgba(34, 197, 94, 0.05);
            box-shadow: 0 0 0 4px rgba(34, 197, 94, 0.1);
        }

        /* Submit Button */
        .submit-btn {
            width: 100%;
            padding: 1.25rem 2rem;
            background: linear-gradient(135deg,
            var(--primary-600) 0%,
            var(--primary-500) 50%,
            var(--accent-cyan) 100%);
            color: white;
            border: none;
            border-radius: var(--radius);
            font-size: 1.1rem;
            font-weight: 700;
            letter-spacing: 0.025em;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: var(--shadow-lg);
            position: relative;
            overflow: hidden;
            margin-top: 1rem;
        }

        .submit-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg,
            transparent,
            rgba(255, 255, 255, 0.3),
            transparent);
            transition: left 0.6s ease;
        }

        .submit-btn:hover::before {
            left: 100%;
        }

        .submit-btn:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-xl), var(--shadow-glow);
            background: linear-gradient(135deg,
            var(--primary-700) 0%,
            var(--primary-600) 50%,
            var(--accent-cyan) 100%);
        }

        .submit-btn:active {
            transform: translateY(-1px);
        }

        .submit-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        .submit-btn.loading {
            pointer-events: none;
            position: relative;
        }

        .submit-btn.loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            margin: -10px 0 0 -10px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Back link */
        .back-link {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(203, 213, 225, 0.3);
        }

        .back-link a {
            color: var(--primary-600);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }

        .back-link a:hover {
            color: var(--primary-700);
            transform: translateX(-5px);
        }

        .back-link a i {
            transition: transform 0.3s ease;
        }

        .back-link a:hover i {
            transform: translateX(-3px);
        }

        /* Account number badge */
        .account-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            box-shadow: var(--shadow-md);
            animation: fadeIn 1s ease-out 0.5s both;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Design */
        @media (max-width: 640px) {
            body {
                padding: 1rem 0.5rem;
            }

            .register-container {
                padding: 2rem 1.5rem;
                margin: 0;
                border-radius: var(--radius-lg);
            }

            .register-header h1 {
                font-size: 2rem;
            }

            .register-header .icon {
                width: 60px;
                height: 60px;
                margin-bottom: 1rem;
            }

            .register-header .icon i {
                font-size: 1.5rem;
            }

            .form-input {
                padding: 0.875rem 1rem;
            }

            .submit-btn {
                padding: 1rem 1.5rem;
                font-size: 1rem;
            }
        }

        /* Custom SweetAlert2 styling */
        .swal2-popup {
            border-radius: var(--radius-lg) !important;
            font-family: 'Inter', sans-serif !important;
            backdrop-filter: blur(20px) !important;
            background: rgba(255, 255, 255, 0.95) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
        }

        .swal2-title {
            font-weight: 700 !important;
            color: var(--gray-800) !important;
        }

        .swal2-confirm {
            background: linear-gradient(135deg, var(--primary-600), var(--primary-700)) !important;
            border-radius: var(--radius) !important;
            font-weight: 600 !important;
            padding: 0.75rem 2rem !important;
            box-shadow: var(--shadow-lg) !important;
        }

        .swal2-cancel {
            background: linear-gradient(135deg, var(--gray-500), var(--gray-600)) !important;
            border-radius: var(--radius) !important;
            font-weight: 600 !important;
            padding: 0.75rem 2rem !important;
            box-shadow: var(--shadow-lg) !important;
        }
    </style>
</head>
<body>
<!-- Floating particles -->
<div class="particles" id="particles"></div>

<div class="register-container">
    <div class="register-header">
        <div class="icon">
            <i class="fas fa-user-plus"></i>
        </div>
        <h1>Customer Registration</h1>
        <p>Create a new account to get started</p>
    </div>

    <form class="register-form" action="register" method="post" id="registerForm">
        <input type="hidden" name="user_type" value="<%= (request.getAttribute("user_type") != null ? request.getAttribute("user_type") : "customer") %>">
        <input type="hidden" name="redirectTo" value="<%= request.getParameter("redirectTo") != null ? request.getParameter("redirectTo") : "" %>">

        <div class="form-group">
            <label class="form-label">
                <i class="fas fa-hashtag"></i>Account Number
            </label>
            <div class="account-badge">
                <i class="fas fa-id-card"></i>
                Auto-generated: <%= request.getAttribute("account_number") != null ? request.getAttribute("account_number") : "ACC-" + System.currentTimeMillis() %>
            </div>
            <input type="text"
                   name="account_number"
                   class="form-input"
                   value="<%= request.getAttribute("account_number") != null ? request.getAttribute("account_number") : "ACC-" + System.currentTimeMillis() %>"
                   readonly>
        </div>

        <div class="form-group">
            <label class="form-label" for="name">
                <i class="fas fa-user"></i>Full Name *
            </label>
            <input type="text"
                   id="name"
                   name="name"
                   class="form-input"
                   placeholder="Enter your full name"
                   required>
        </div>

        <div class="form-group">
            <label class="form-label" for="address">
                <i class="fas fa-map-marker-alt"></i>Address *
            </label>
            <input type="text"
                   id="address"
                   name="address"
                   class="form-input"
                   placeholder="Enter your address"
                   required>
        </div>

        <div class="form-group">
            <label class="form-label" for="telephone">
                <i class="fas fa-phone"></i>Telephone *
            </label>
            <input type="tel"
                   id="telephone"
                   name="telephone"
                   class="form-input"
                   placeholder="Enter your phone number"
                   required>
        </div>

        <div class="form-group">
            <label class="form-label" for="email">
                <i class="fas fa-envelope"></i>Email Address *
            </label>
            <input type="email"
                   id="email"
                   name="email"
                   class="form-input"
                   placeholder="Enter your email address"
                   required>
        </div>

        <button type="submit" class="submit-btn" id="submitBtn">
            <i class="fas fa-user-plus"></i>
            Create Account
        </button>
    </form>

    <div class="back-link">
        <a href="javascript:history.back()">
            <i class="fas fa-arrow-left"></i>
            Back to previous page
        </a>
    </div>
</div>

<script>
    // Create floating particles
    function createParticles() {
        const particles = document.getElementById('particles');
        const particleCount = 25;

        for (let i = 0; i < particleCount; i++) {
            const particle = document.createElement('div');
            particle.className = 'particle';
            particle.style.left = Math.random() * 100 + '%';
            particle.style.top = Math.random() * 100 + '%';
            particle.style.animationDelay = Math.random() * 8 + 's';
            particle.style.animationDuration = (Math.random() * 4 + 4) + 's';
            particles.appendChild(particle);
        }
    }

    createParticles();

    // Handle error messages from URL parameters with SweetAlert
    const urlParams = new URLSearchParams(window.location.search);
    const error = urlParams.get('error');

    if (error) {
        let title = 'Registration Error';
        let message = 'An error occurred during registration.';
        let icon = 'error';

        switch (error) {
            case 'empty':
                message = 'All fields are required. Please fill in all the information.';
                break;
            case 'email':
                message = 'This email address is already registered. Please use a different email.';
                break;
            case 'telephone':
                message = 'This telephone number is already registered. Please use a different number.';
                break;
            case 'unknown':
                message = 'An unexpected error occurred. Please try again later.';
                break;
            default:
                message = 'Registration failed. Please check your information and try again.';
        }

        Swal.fire({
            icon: icon,
            title: title,
            html: message,
            confirmButtonText: 'Try Again',
            confirmButtonColor: '#0ea5e9',
            background: 'rgba(255,255,255,0.98)',
            backdrop: 'rgba(0,0,0,0.4)',
            allowOutsideClick: true,
            allowEscapeKey: true,
            showCloseButton: true,
            timer: 8000,
            timerProgressBar: true
        });
    }

    // Form validation and submission
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('registerForm');
        const submitBtn = document.getElementById('submitBtn');
        const inputs = form.querySelectorAll('.form-input[required]');

        // Real-time validation
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                validateField(this);
            });

            input.addEventListener('input', function() {
                if (this.classList.contains('error')) {
                    validateField(this);
                }
            });
        });

        // Form submission
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            let isValid = true;
            const formData = new FormData(this);

            // Validate all fields
            inputs.forEach(input => {
                if (!validateField(input)) {
                    isValid = false;
                }
            });

            if (!isValid) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Validation Error',
                    text: 'Please fix the errors in the form before submitting.',
                    confirmButtonColor: '#0ea5e9',
                    showCloseButton: true
                });
                return;
            }

            // Show confirmation dialog
            Swal.fire({
                title: 'Confirm Registration',
                html: `
                        <div style="text-align: left; margin: 1rem 0;">
                            <p><strong>Name:</strong> ${formData.get('name')}</p>
                            <p><strong>Email:</strong> ${formData.get('email')}</p>
                            <p><strong>Phone:</strong> ${formData.get('telephone')}</p>
                            <p><strong>Address:</strong> ${formData.get('address')}</p>
                        </div>
                        <p style="margin-top: 1rem; color: #64748b; font-size: 0.9rem;">
                            Are you sure you want to create this account?
                        </p>
                    `,
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: '<i class="fas fa-check"></i> Yes, create account!',
                cancelButtonText: '<i class="fas fa-times"></i> Cancel',
                confirmButtonColor: '#0ea5e9',
                cancelButtonColor: '#64748b',
                background: 'rgba(255,255,255,0.98)',
                backdrop: 'rgba(0,0,0,0.4)',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    // Show loading state
                    submitBtn.classList.add('loading');
                    submitBtn.innerHTML = '<span style="opacity: 0;">Creating Account...</span>';
                    submitBtn.disabled = true;

                    // Show loading dialog
                    Swal.fire({
                        title: 'Creating Account...',
                        html: 'Please wait while we set up your new account.',
                        icon: 'info',
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        showConfirmButton: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    });

                    // Submit the form
                    setTimeout(() => {
                        this.submit();
                    }, 1000);
                }
            });
        });

        // Field validation function
        function validateField(field) {
            const value = field.value.trim();
            let isValid = true;

            // Remove existing classes
            field.classList.remove('error', 'success');

            if (field.hasAttribute('required') && !value) {
                field.classList.add('error');
                isValid = false;
            } else if (field.type === 'email' && value) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(value)) {
                    field.classList.add('error');
                    isValid = false;
                } else {
                    field.classList.add('success');
                }
            } else if (field.type === 'tel' && value) {
                const phoneRegex = /^[\+]?[\d\s\-\(\)]{10,}$/;
                if (!phoneRegex.test(value)) {
                    field.classList.add('error');
                    isValid = false;
                } else {
                    field.classList.add('success');
                }
            } else if (value) {
                if (field.name === 'name' && value.length < 2) {
                    field.classList.add('error');
                    isValid = false;
                } else {
                    field.classList.add('success');
                }
            }

            return isValid;
        }

        // Auto-focus first input
        const firstInput = form.querySelector('input[type="text"]:not([readonly])');
        if (firstInput) {
            setTimeout(() => firstInput.focus(), 500);
        }

        // Handle success message from session or redirect
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success')) {
            Swal.fire({
                icon: 'success',
                title: 'Registration Successful!',
                text: 'Your account has been created successfully.',
                confirmButtonText: 'Continue',
                confirmButtonColor: '#22c55e',
                timer: 5000,
                timerProgressBar: true,
                showCloseButton: true
            });
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Escape to clear focused input
            if (e.key === 'Escape' && document.activeElement.classList.contains('form-input')) {
                document.activeElement.blur();
            }

            // Ctrl/Cmd + Enter to submit form
            if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
                e.preventDefault();
                form.dispatchEvent(new Event('submit'));
            }
        });
    });

    // Utility function for showing alerts
    window.showAlert = function(type, title, message) {
        Swal.fire({
            icon: type,
            title: title,
            text: message,
            confirmButtonText: 'OK',
            confirmButtonColor: '#0ea5e9',
            background: 'rgba(255,255,255,0.98)',
            backdrop: 'rgba(0,0,0,0.4)'
        });
    };

    // Handle page visibility for animations
    document.addEventListener('visibilitychange', function() {
        if (!document.hidden) {
            // Re-trigger animations when page becomes visible
            const container = document.querySelector('.register-container');
            container.style.animation = 'none';
            setTimeout(() => {
                container.style.animation = 'slideUp 0.8s cubic-bezier(0.4, 0, 0.2, 1)';
            }, 10);
        }
    });
</script>
</body>
</html>