<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Panel - Pahana Edu</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary-50: #eff8ff;
            --primary-100: #dbeafe;
            --primary-200: #bfdbfe;
            --primary-300: #93c5fd;
            --primary-400: #60a5fa;
            --primary-500: #3b82f6;
            --primary-600: #2563eb;
            --primary-700: #1d4ed8;
            --primary-800: #1e40af;
            --primary-900: #1e3a8a;

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

            --success: #10b981;
            --warning: #f59e0b;
            --error: #ef4444;

            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);

            --border-radius: 12px;
            --border-radius-lg: 16px;
            --border-radius-xl: 20px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, var(--primary-50) 0%, var(--gray-50) 100%);
            color: var(--gray-800);
            line-height: 1.6;
            min-height: 100vh;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }

        /* Header Section */
        .header {
            background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-500) 100%);
            border-radius: var(--border-radius-xl);
            padding: 2.5rem;
            margin-bottom: 2rem;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-xl);
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            transform: translate(150px, -150px);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 2rem;
            position: relative;
            z-index: 1;
        }

        .header-info h1 {
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            letter-spacing: -0.025em;
        }

        .header-info p {
            font-size: 1.125rem;
            opacity: 0.9;
            font-weight: 400;
        }

        .header-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        /* Button Styles */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            font-size: 0.875rem;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: white;
            color: var(--primary-600);
            box-shadow: var(--shadow-md);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .btn-outline {
            background: rgba(255,255,255,0.1);
            color: white;
            border: 1px solid rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
        }

        .btn-outline:hover {
            background: rgba(255,255,255,0.2);
            border-color: rgba(255,255,255,0.3);
        }

        .btn-danger {
            background: rgba(239,68,68,0.1);
            color: white;
            border: 1px solid rgba(239,68,68,0.2);
        }

        .btn-danger:hover {
            background: rgba(239,68,68,0.2);
        }



        /* Main Grid */
        .main-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .feature-card {
            background: white;
            border-radius: var(--border-radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow);
            border: 1px solid var(--gray-100);
            transition: all 0.3s ease;
            position: relative;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-xl);
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-500), var(--primary-400));
        }

        .feature-content {
            padding: 1.5rem;
        }

        .feature-icon {
            width: 3.5rem;
            height: 3.5rem;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
            background: var(--primary-100);
            color: var(--primary-600);
        }

        .feature-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--gray-900);
        }

        .feature-desc {
            color: var(--gray-600);
            margin-bottom: 1.5rem;
            line-height: 1.5;
        }

        .feature-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--primary-600);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .feature-link:hover {
            color: var(--primary-700);
            gap: 0.75rem;
        }

        /* Quick Actions */
        .quick-actions {
            background: white;
            border-radius: var(--border-radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            border: 1px solid var(--gray-100);
        }

        .quick-actions h2 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--gray-900);
        }

        .quick-grid {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .quick-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: var(--primary-50);
            color: var(--primary-700);
            text-decoration: none;
            border-radius: 999px;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            border: 1px solid var(--primary-200);
        }

        .quick-btn:hover {
            background: var(--primary-100);
            transform: translateY(-1px);
        }

        .quick-btn.danger {
            background: #fef2f2;
            color: var(--error);
            border-color: #fecaca;
        }

        .quick-btn.danger:hover {
            background: #fee2e2;
        }

        /* Footer */
        .footer {
            text-align: center;
            margin-top: 3rem;
            padding: 1.5rem;
            color: var(--gray-500);
            font-size: 0.875rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .header {
                padding: 1.5rem;
            }

            .header-content {
                flex-direction: column;
                text-align: center;
            }

            .header-info h1 {
                font-size: 1.875rem;
            }

            .header-actions {
                justify-content: center;
            }

            .main-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .animate-fade-in {
            animation: fadeInUp 0.6s ease-out;
        }

        /* Ripple Effect */
        .ripple {
            position: absolute;
            border-radius: 50%;
            background: rgba(59, 130, 246, 0.3);
            transform: scale(0);
            animation: ripple 0.6s linear;
            pointer-events: none;
        }

        @keyframes ripple {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
    </style>
</head>
<body>
<%@ include file="/staff/includes/navbar.jsp" %>
<div class="container">
    <!-- Header -->
    <header class="header animate-fade-in">
        <div class="header-content">
            <div class="header-info">
                <h1>Staff Dashboard</h1>
                <p>Welcome back, <strong>Admin User</strong></p>
            </div>
            <div class="header-actions">
                <a href="#" class="btn btn-outline">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    Check User
                </a>
                <a href="#" class="btn btn-primary">
                    <i class="fa-solid fa-user-plus"></i>
                    Register User
                </a>
                <a href="#" class="btn btn-danger">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    Logout
                </a>
            </div>
        </div>
    </header>



    <!-- Main Features Grid -->
    <div class="main-grid">
        <div class="feature-card animate-fade-in" style="animation-delay: 0.5s;">
            <div class="feature-content">
                <div class="feature-icon">
                    <i class="fa-solid fa-book"></i>
                </div>
                <h3 class="feature-title">Manage Books</h3>
                <p class="feature-desc">Add, edit, and organize your library collection with advanced search and categorization features.</p>
                <a href="${ctx}/manage-books" class="feature-link">
                    Go to Books <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>

        <div class="feature-card animate-fade-in" style="animation-delay: 0.6s;">
            <div class="feature-content">
                <div class="feature-icon">
                    <i class="fa-solid fa-users"></i>
                </div>
                <h3 class="feature-title">Manage Users</h3>
                <p class="feature-desc">View, update, and support user accounts. Handle user registrations and account management.</p>
                <a href="${ctx}/staff/manage_users.jsp" class="feature-link">
                    Go to Users <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>

        <div class="feature-card animate-fade-in" style="animation-delay: 0.7s;">
            <div class="feature-content">
                <div class="feature-icon">
                    <i class="fa-solid fa-folder-tree"></i>
                </div>
                <h3 class="feature-title">Manage Categories</h3>
                <p class="feature-desc">Create and maintain content categories. Organize your library with custom taxonomies.</p>
                <a href="${ctx}/staff/manage-categories" class="feature-link">
                    Go to Categories <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>

        <div class="feature-card animate-fade-in" style="animation-delay: 0.8s;">
            <div class="feature-content">
                <div class="feature-icon">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                </div>
                <h3 class="feature-title">Billing Management</h3>
                <p class="feature-desc">Check user bills, manage payments, and handle financial transactions securely.</p>
                <a href="${ctx}/staff/checkout.jsp" class="feature-link">
                    Go to Billing <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions animate-fade-in" style="animation-delay: 0.9s;">
        <h2>Quick Actions</h2>
        <div class="quick-grid">
            <a href="#" class="quick-btn">
                <i class="fa-solid fa-id-card-clip"></i>
                Check User
            </a>
            <a href="#" class="quick-btn">
                <i class="fa-solid fa-user-plus"></i>
                Register User
            </a>
            <a href="#" class="quick-btn">
                <i class="fa-solid fa-chart-line"></i>
                View Reports
            </a>
            <a href="#" class="quick-btn">
                <i class="fa-solid fa-cog"></i>
                Settings
            </a>
            <a href="#" class="quick-btn danger">
                <i class="fa-solid fa-right-from-bracket"></i>
                Logout
            </a>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; <span id="current-year"></span> Pahana Edu. All rights reserved.</p>
    </footer>
</div>

<script>
    // Set current year
    document.getElementById('current-year').textContent = new Date().getFullYear();

    // Add ripple effect to buttons
    document.querySelectorAll('.btn, .quick-btn, .feature-link').forEach(button => {
        button.addEventListener('click', function(e) {
            const rect = this.getBoundingClientRect();
            const ripple = document.createElement('span');
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;

            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            ripple.classList.add('ripple');

            this.appendChild(ripple);

            setTimeout(() => {
                ripple.remove();
            }, 600);
        });
    });

    // Add smooth scrolling for better UX
    document.documentElement.style.scrollBehavior = 'smooth';

    // Intersection Observer for animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-fade-in');
            }
        });
    }, observerOptions);

    // Observe all cards for animation
    document.querySelectorAll('.feature-card').forEach(card => {
        observer.observe(card);
    });
</script>
</body>
</html>