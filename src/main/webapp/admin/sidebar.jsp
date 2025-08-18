<%@ page contentType="text/html;charset=UTF-8" %>
<nav class="modern-navbar">
    <div class="navbar-container">
        <!-- Logo Section -->
        <div class="navbar-brand">
            <div class="logo-icon">
                <i class="fas fa-graduation-cap"></i>
            </div>
            <div class="brand-text">
                <h3 class="brand-name">Pahana Edu</h3>
                <span class="brand-subtitle">Admin Portal</span>
            </div>
        </div>

        <!-- Navigation Menu -->
        <div class="navbar-nav">
            <a class="nav-item active" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                <i class="fas fa-chart-pie"></i>
                <span>Dashboard</span>
            </a>
            <a class="nav-item" href="${pageContext.request.contextPath}/ManageStaff">
                <i class="fas fa-users"></i>
                <span>Manage Staff</span>
            </a>
            <a class="nav-item" href="${pageContext.request.contextPath}/admin/addstaff.jsp">
                <i class="fas fa-user-plus"></i>
                <span>Add Staff</span>
            </a>
            <a class="nav-item" href="${pageContext.request.contextPath}/admin/bill-report.jsp">
                <i class="fas fa-receipt"></i>
                <span>Bill Reports</span>
            </a>
            <a class="nav-item" href="${pageContext.request.contextPath}/admin/settings.jsp">
                <i class="fas fa-cog"></i>
                <span>Settings</span>
            </a>
        </div>

        <!-- Right Section -->
        <div class="navbar-actions">
            <!-- Search Bar -->
            <div class="search-container">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search..." class="search-input">
            </div>

            <!-- Notifications -->
            <div class="notification-bell">
                <i class="fas fa-bell"></i>
                <span class="notification-badge">3</span>
            </div>

            <!-- User Profile -->
            <div class="user-profile" onclick="toggleUserMenu()">
                <div class="user-avatar">
                    <i class="fas fa-user-shield"></i>
                </div>
                <div class="user-info">
                    <span class="user-name">Administrator</span>
                    <span class="user-role">System Admin</span>
                </div>
                <i class="fas fa-chevron-down dropdown-arrow"></i>

                <!-- Dropdown Menu -->
                <div class="user-dropdown" id="userDropdown">
                    <a href="${pageContext.request.contextPath}/admin/profile.jsp" class="dropdown-item">
                        <i class="fas fa-user"></i>
                        <span>My Profile</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/preferences.jsp" class="dropdown-item">
                        <i class="fas fa-sliders-h"></i>
                        <span>Preferences</span>
                    </a>
                    <div class="dropdown-divider"></div>
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item logout">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </div>

            <!-- Mobile Menu Toggle -->
            <button class="mobile-menu-toggle" onclick="toggleMobileMenu()">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </div>

    <!-- Mobile Menu -->
    <div class="mobile-menu" id="mobileMenu">
        <div class="mobile-nav-items">
            <a class="mobile-nav-item active" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                <i class="fas fa-chart-pie"></i>
                <span>Dashboard</span>
            </a>
            <a class="mobile-nav-item" href="${pageContext.request.contextPath}/ManageStaff">
                <i class="fas fa-users"></i>
                <span>Manage Staff</span>
            </a>
            <a class="mobile-nav-item" href="${pageContext.request.contextPath}/admin/addstaff.jsp">
                <i class="fas fa-user-plus"></i>
                <span>Add Staff</span>
            </a>
            <a class="mobile-nav-item" href="${pageContext.request.contextPath}/admin/bill-report.jsp">
                <i class="fas fa-receipt"></i>
                <span>Bill Reports</span>
            </a>
            <a class="mobile-nav-item" href="${pageContext.request.contextPath}/admin/settings.jsp">
                <i class="fas fa-cog"></i>
                <span>Settings</span>
            </a>
            <div class="mobile-divider"></div>
            <a class="mobile-nav-item logout" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </div>
    </div>
</nav>

<style>
    :root {
        --primary-blue: #3b82f6;
        --light-blue: #dbeafe;
        --sky-blue: #0ea5e9;
        --blue-50: #eff6ff;
        --blue-100: #dbeafe;
        --blue-500: #3b82f6;
        --blue-600: #2563eb;
        --blue-700: #1d4ed8;
        --blue-800: #1e40af;
        --gray-50: #f9fafb;
        --gray-100: #f3f4f6;
        --gray-200: #e5e7eb;
        --gray-300: #d1d5db;
        --gray-400: #9ca3af;
        --gray-500: #6b7280;
        --gray-600: #4b5563;
        --gray-700: #374151;
        --gray-800: #1f2937;
        --gray-900: #111827;
        --white: #ffffff;
        --success: #10b981;
        --danger: #ef4444;
        --warning: #f59e0b;
        --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
        --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
        --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
    }

    * {
        box-sizing: border-box;
    }

    body {
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        margin: 0;
        padding-top: 80px; /* Space for fixed navbar */
    }

    .modern-navbar {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1000;
        background: var(--white);
        border-bottom: 1px solid var(--gray-200);
        box-shadow: var(--shadow-md);
        backdrop-filter: blur(10px);
    }

    .navbar-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 2rem;
        height: 80px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 2rem;
    }

    /* Logo Section */
    .navbar-brand {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        flex-shrink: 0;
    }

    .logo-icon {
        width: 48px;
        height: 48px;
        background: linear-gradient(135deg, var(--blue-500), var(--sky-blue));
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--white);
        font-size: 1.25rem;
        box-shadow: var(--shadow-md);
    }

    .brand-text {
        display: flex;
        flex-direction: column;
    }

    .brand-name {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--gray-900);
        margin: 0;
        line-height: 1.2;
    }

    .brand-subtitle {
        font-size: 0.75rem;
        color: var(--gray-500);
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }

    /* Navigation Menu */
    .navbar-nav {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        flex: 1;
        justify-content: center;
    }

    .nav-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.75rem 1.25rem;
        border-radius: 12px;
        color: var(--gray-600);
        text-decoration: none;
        font-weight: 500;
        font-size: 0.875rem;
        transition: all 0.2s ease;
        position: relative;
        white-space: nowrap;
    }

    .nav-item:hover {
        background: var(--blue-50);
        color: var(--blue-600);
        text-decoration: none;
        transform: translateY(-1px);
    }

    .nav-item.active {
        background: linear-gradient(135deg, var(--blue-500), var(--blue-600));
        color: var(--white);
        box-shadow: var(--shadow-md);
    }

    .nav-item.active:hover {
        background: linear-gradient(135deg, var(--blue-600), var(--blue-700));
    }

    .nav-item i {
        font-size: 1rem;
        width: 16px;
        text-align: center;
    }

    /* Right Section */
    .navbar-actions {
        display: flex;
        align-items: center;
        gap: 1.5rem;
    }

    /* Search */
    .search-container {
        position: relative;
        display: flex;
        align-items: center;
    }

    .search-container i {
        position: absolute;
        left: 1rem;
        color: var(--gray-400);
        font-size: 0.875rem;
    }

    .search-input {
        width: 280px;
        padding: 0.75rem 1rem 0.75rem 2.5rem;
        border: 1px solid var(--gray-300);
        border-radius: 12px;
        font-size: 0.875rem;
        background: var(--gray-50);
        transition: all 0.2s ease;
    }

    .search-input:focus {
        outline: none;
        border-color: var(--blue-500);
        background: var(--white);
        box-shadow: 0 0 0 3px var(--blue-100);
    }

    /* Notifications */
    .notification-bell {
        position: relative;
        padding: 0.75rem;
        border-radius: 12px;
        background: var(--gray-50);
        color: var(--gray-600);
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .notification-bell:hover {
        background: var(--blue-50);
        color: var(--blue-600);
        transform: translateY(-1px);
    }

    .notification-badge {
        position: absolute;
        top: 0.25rem;
        right: 0.25rem;
        width: 18px;
        height: 18px;
        background: var(--danger);
        color: var(--white);
        border-radius: 50%;
        font-size: 0.7rem;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
    }

    /* User Profile */
    .user-profile {
        position: relative;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.5rem 1rem;
        border-radius: 12px;
        background: var(--gray-50);
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .user-profile:hover {
        background: var(--blue-50);
        transform: translateY(-1px);
    }

    .user-avatar {
        width: 40px;
        height: 40px;
        background: linear-gradient(135deg, var(--gray-600), var(--gray-700));
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--white);
        font-size: 0.875rem;
    }

    .user-info {
        display: flex;
        flex-direction: column;
    }

    .user-name {
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--gray-900);
        line-height: 1.2;
    }

    .user-role {
        font-size: 0.75rem;
        color: var(--gray-500);
        font-weight: 500;
    }

    .dropdown-arrow {
        font-size: 0.75rem;
        color: var(--gray-400);
        transition: transform 0.2s ease;
    }

    .user-profile.active .dropdown-arrow {
        transform: rotate(180deg);
    }

    /* User Dropdown */
    .user-dropdown {
        position: absolute;
        top: calc(100% + 0.5rem);
        right: 0;
        width: 220px;
        background: var(--white);
        border: 1px solid var(--gray-200);
        border-radius: 12px;
        box-shadow: var(--shadow-xl);
        padding: 0.5rem 0;
        opacity: 0;
        visibility: hidden;
        transform: translateY(-10px);
        transition: all 0.2s ease;
        z-index: 1000;
    }

    .user-dropdown.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .dropdown-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.75rem 1rem;
        color: var(--gray-700);
        text-decoration: none;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.2s ease;
    }

    .dropdown-item:hover {
        background: var(--blue-50);
        color: var(--blue-600);
        text-decoration: none;
    }

    .dropdown-item.logout {
        color: var(--danger);
    }

    .dropdown-item.logout:hover {
        background: #fef2f2;
        color: var(--danger);
    }

    .dropdown-divider {
        height: 1px;
        background: var(--gray-200);
        margin: 0.5rem 0;
    }

    /* Mobile Menu Toggle */
    .mobile-menu-toggle {
        display: none;
        flex-direction: column;
        gap: 4px;
        padding: 0.75rem;
        background: none;
        border: none;
        cursor: pointer;
        border-radius: 8px;
        transition: all 0.2s ease;
    }

    .mobile-menu-toggle:hover {
        background: var(--gray-100);
    }

    .mobile-menu-toggle span {
        width: 24px;
        height: 3px;
        background: var(--gray-600);
        border-radius: 2px;
        transition: all 0.3s ease;
    }

    .mobile-menu-toggle.active span:nth-child(1) {
        transform: rotate(45deg) translate(6px, 6px);
    }

    .mobile-menu-toggle.active span:nth-child(2) {
        opacity: 0;
    }

    .mobile-menu-toggle.active span:nth-child(3) {
        transform: rotate(-45deg) translate(6px, -6px);
    }

    /* Mobile Menu */
    .mobile-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: var(--white);
        border-top: 1px solid var(--gray-200);
        box-shadow: var(--shadow-lg);
        opacity: 0;
        visibility: hidden;
        transform: translateY(-10px);
        transition: all 0.3s ease;
    }

    .mobile-menu.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .mobile-nav-items {
        padding: 1rem;
    }

    .mobile-nav-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 1rem;
        border-radius: 12px;
        color: var(--gray-700);
        text-decoration: none;
        font-weight: 500;
        margin-bottom: 0.5rem;
        transition: all 0.2s ease;
    }

    .mobile-nav-item:hover {
        background: var(--blue-50);
        color: var(--blue-600);
        text-decoration: none;
    }

    .mobile-nav-item.active {
        background: linear-gradient(135deg, var(--blue-500), var(--blue-600));
        color: var(--white);
    }

    .mobile-nav-item.logout {
        color: var(--danger);
    }

    .mobile-divider {
        height: 1px;
        background: var(--gray-200);
        margin: 1rem 0;
    }

    /* Responsive Design */
    @media (max-width: 1200px) {
        .search-input {
            width: 200px;
        }
    }

    @media (max-width: 992px) {
        .navbar-nav {
            display: none;
        }

        .search-container {
            display: none;
        }

        .mobile-menu-toggle {
            display: flex;
        }

        .mobile-menu {
            display: block;
        }

        .user-info {
            display: none;
        }
    }

    @media (max-width: 576px) {
        .navbar-container {
            padding: 0 1rem;
        }

        .brand-text {
            display: none;
        }

        .notification-bell {
            padding: 0.5rem;
        }
    }

    /* Smooth scrolling for internal links */
    html {
        scroll-behavior: smooth;
    }

    /* Focus states for accessibility */
    .nav-item:focus,
    .dropdown-item:focus {
        outline: 2px solid var(--blue-500);
        outline-offset: 2px;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Highlight current page
        const currentPath = window.location.pathname;
        const navItems = document.querySelectorAll('.nav-item, .mobile-nav-item');

        navItems.forEach(item => {
            item.classList.remove('active');
            const href = item.getAttribute('href');
            if (href && (currentPath.includes(href) || currentPath.endsWith(href.split('/').pop()))) {
                item.classList.add('active');
            }
        });

        // Close dropdowns when clicking outside
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.user-profile')) {
                document.getElementById('userDropdown').classList.remove('show');
                document.querySelector('.user-profile').classList.remove('active');
            }

            if (!e.target.closest('.mobile-menu-toggle') && !e.target.closest('.mobile-menu')) {
                document.getElementById('mobileMenu').classList.remove('show');
                document.querySelector('.mobile-menu-toggle').classList.remove('active');
            }
        });
    });

    // Toggle user dropdown menu
    function toggleUserMenu() {
        const dropdown = document.getElementById('userDropdown');
        const userProfile = document.querySelector('.user-profile');

        dropdown.classList.toggle('show');
        userProfile.classList.toggle('active');
    }

    // Toggle mobile menu
    function toggleMobileMenu() {
        const mobileMenu = document.getElementById('mobileMenu');
        const toggle = document.querySelector('.mobile-menu-toggle');

        mobileMenu.classList.toggle('show');
        toggle.classList.toggle('active');
    }

    // Search functionality
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.querySelector('.search-input');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    // Add your search functionality here
                    console.log('Searching for:', this.value);
                }
            });
        }
    });

    // Notification bell click
    document.addEventListener('DOMContentLoaded', function() {
        const notificationBell = document.querySelector('.notification-bell');
        if (notificationBell) {
            notificationBell.addEventListener('click', function() {
                // Add your notification functionality here
                console.log('Notifications clicked');
            });
        }
    });
</script>