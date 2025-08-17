<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="src.business.user.dto.Userdto" %>
<%
    List<Userdto> users = (List<Userdto>) request.getAttribute("users");
    String q = request.getParameter("q");
    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Users - Pahana Edu</title>

    <!-- Icons & Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- SweetAlert2 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert2/11.10.3/sweetalert2.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert2/11.10.3/sweetalert2.min.css" />

    <style>
        :root {
            --primary-50: #eff6ff;
            --primary-100: #dbeafe;
            --primary-200: #bfdbfe;
            --primary-300: #93c5fd;
            --primary-400: #60a5fa;
            --primary-500: #3b82f6;
            --primary-600: #2563eb;
            --primary-700: #1d4ed8;
            --primary-800: #1e40af;
            --primary-900: #1e3a8a;

            --secondary-50: #f8fafc;
            --secondary-100: #f1f5f9;
            --secondary-200: #e2e8f0;
            --secondary-300: #cbd5e1;
            --secondary-400: #94a3b8;
            --secondary-500: #64748b;
            --secondary-600: #475569;
            --secondary-700: #334155;
            --secondary-800: #1e293b;
            --secondary-900: #0f172a;

            --accent-purple: #8b5cf6;
            --accent-pink: #ec4899;
            --accent-orange: #f59e0b;
            --accent-teal: #14b8a6;

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

            --red-50: #fef2f2;
            --red-500: #ef4444;
            --red-600: #dc2626;
            --red-700: #b91c1c;

            --green-50: #f0fdf4;
            --green-500: #22c55e;
            --green-600: #16a34a;
            --green-700: #15803d;

            --yellow-50: #fffbeb;
            --yellow-500: #eab308;
            --yellow-600: #ca8a04;

            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
            --shadow-2xl: 0 25px 50px -12px rgb(0 0 0 / 0.25);
            --shadow-glow: 0 0 20px rgb(59 130 246 / 0.15);

            --radius-sm: 8px;
            --radius: 12px;
            --radius-lg: 16px;
            --radius-xl: 24px;

            --backdrop: rgba(255, 255, 255, 0.8);
            --glass-border: rgba(255, 255, 255, 0.2);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 25%, #f093fb 50%, #f5576c 75%, #4facfe 100%);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            color: var(--gray-800);
            min-height: 100vh;
            line-height: 1.6;
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
                    radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
                    radial-gradient(circle at 40% 40%, rgba(120, 219, 255, 0.2) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Floating particles animation */
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
            background: rgba(255, 255, 255, 0.4);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0.4; }
            50% { transform: translateY(-20px) rotate(180deg); opacity: 0.8; }
        }

        /* Container */
        .sp-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
            min-height: calc(100vh - 120px);
            position: relative;
            z-index: 1;
        }

        /* Header */
        .sp-header {
            background: var(--backdrop);
            backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl);
            padding: 2.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-xl), var(--shadow-glow);
            position: relative;
            overflow: hidden;
        }

        .sp-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
            pointer-events: none;
        }

        .sp-header-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 2rem;
            flex-wrap: wrap;
            position: relative;
            z-index: 2;
        }

        .sp-header-text h1 {
            font-size: 3rem;
            font-weight: 900;
            background: linear-gradient(135deg, var(--secondary-900) 0%, var(--primary-600) 50%, var(--accent-purple) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.75rem;
            letter-spacing: -0.03em;
            text-shadow: 0 4px 8px rgba(0,0,0,0.1);
            position: relative;
        }

        .sp-header-text h1::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-500), var(--accent-purple));
            border-radius: 2px;
            animation: shimmer 2s ease-in-out infinite;
        }

        @keyframes shimmer {
            0%, 100% { opacity: 0.7; transform: scaleX(1); }
            50% { opacity: 1; transform: scaleX(1.1); }
        }

        .sp-header-text p {
            color: var(--secondary-600);
            font-size: 1.2rem;
            font-weight: 500;
            opacity: 0.9;
        }

        .sp-toolbar {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .sp-search-wrapper {
            position: relative;
            min-width: 350px;
        }

        .sp-search-wrapper i {
            position: absolute;
            left: 1.25rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 1rem;
            z-index: 3;
        }

        .sp-input {
            width: 100%;
            padding: 1rem 1.25rem 1rem 3rem;
            border: 2px solid rgba(255,255,255,0.2);
            border-radius: var(--radius);
            font-size: 1rem;
            font-weight: 500;
            background: rgba(255,255,255,0.9);
            backdrop-filter: blur(10px);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            color: var(--gray-700);
            box-shadow: var(--shadow-sm);
        }

        .sp-input:focus {
            outline: none;
            border-color: var(--primary-400);
            background: rgba(255,255,255,0.95);
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1), var(--shadow-lg);
            transform: translateY(-2px);
        }

        .sp-input::placeholder {
            color: var(--gray-400);
            font-weight: 400;
        }

        /* Enhanced Buttons */
        .sp-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 1.75rem;
            border-radius: var(--radius);
            font-weight: 600;
            font-size: 0.95rem;
            text-decoration: none;
            border: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            white-space: nowrap;
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
        }

        .sp-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }

        .sp-btn:hover::before {
            left: 100%;
        }

        .sp-btn:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-xl);
        }

        .sp-btn:active {
            transform: translateY(-1px);
        }

        .sp-btn--primary {
            background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 50%, var(--accent-purple) 100%);
            color: white;
            border-color: var(--primary-600);
        }

        .sp-btn--primary:hover {
            background: linear-gradient(135deg, var(--primary-700) 0%, var(--primary-800) 50%, var(--accent-purple) 100%);
            box-shadow: var(--shadow-xl), 0 0 30px rgba(59, 130, 246, 0.4);
        }

        .sp-btn--outline {
            background: rgba(255,255,255,0.9);
            backdrop-filter: blur(10px);
            color: var(--gray-700);
            border-color: rgba(255,255,255,0.3);
        }

        .sp-btn--outline:hover {
            background: rgba(255,255,255,0.95);
            border-color: var(--primary-300);
            color: var(--primary-700);
        }

        .sp-btn--danger {
            background: linear-gradient(135deg, var(--red-500) 0%, var(--red-600) 50%, #dc2626 100%);
            color: white;
            border-color: var(--red-500);
        }

        .sp-btn--danger:hover {
            background: linear-gradient(135deg, var(--red-600) 0%, var(--red-700) 50%, #b91c1c 100%);
            box-shadow: var(--shadow-xl), 0 0 30px rgba(239, 68, 68, 0.4);
        }

        .sp-btn--sm {
            padding: 0.625rem 1.25rem;
            font-size: 0.875rem;
        }

        /* Enhanced Table Container */
        .sp-table-container {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(20px) saturate(180%);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-2xl);
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
        }

        .sp-table-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-500), var(--accent-purple), var(--accent-pink), var(--accent-teal));
            background-size: 400% 400%;
            animation: gradientShift 8s ease infinite;
        }

        .sp-table-wrapper {
            overflow-x: auto;
            overflow-y: visible;
        }

        .sp-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.95rem;
        }

        .sp-table thead {
            background: linear-gradient(135deg, var(--secondary-50) 0%, rgba(255,255,255,0.8) 100%);
            backdrop-filter: blur(10px);
        }

        .sp-table th {
            padding: 1.5rem 1.25rem;
            text-align: left;
            font-weight: 700;
            color: var(--secondary-800);
            border-bottom: 2px solid var(--gray-200);
            white-space: nowrap;
            letter-spacing: 0.025em;
            text-transform: uppercase;
            font-size: 0.85rem;
            position: relative;
        }

        .sp-table th::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: var(--primary-500);
            transition: all 0.3s ease;
        }

        .sp-table th:hover::after {
            width: 80%;
            left: 10%;
        }

        .sp-table td {
            padding: 1.25rem;
            border-bottom: 1px solid rgba(229, 231, 235, 0.5);
            vertical-align: middle;
            position: relative;
        }

        .sp-table tbody tr {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .sp-table tbody tr::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 0;
            height: 100%;
            background: linear-gradient(90deg, var(--primary-500), transparent);
            transition: width 0.3s ease;
            opacity: 0.1;
        }

        .sp-table tbody tr:hover {
            background: rgba(59, 130, 246, 0.02);
            transform: scale(1.001);
            box-shadow: 0 4px 20px rgba(59, 130, 246, 0.1);
        }

        .sp-table tbody tr:hover::before {
            width: 4px;
        }

        .sp-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Enhanced Input fields */
        .sp-input--sm {
            padding: 0.75rem 1rem;
            font-size: 0.9rem;
            border-radius: var(--radius-sm);
            border: 2px solid var(--gray-200);
            background: var(--gray-50);
            width: 100%;
            min-width: 140px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .sp-input--sm:focus {
            background: rgba(255,255,255,0.95);
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1), var(--shadow-md);
            transform: translateY(-1px);
        }

        /* Locked/Unlocked states */
        .sp-input--locked {
            background: var(--gray-100);
            border-color: var(--gray-300);
            color: var(--gray-600);
            cursor: pointer;
            user-select: none;
            position: relative;
        }

        .sp-input--locked::before {
            content: '🔒';
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 12px;
            opacity: 0.6;
            pointer-events: none;
        }

        .sp-input--unlocked {
            background: rgba(255, 248, 220, 0.8);
            border-color: var(--yellow-500);
            box-shadow: 0 0 0 2px rgba(234, 179, 8, 0.1);
            animation: pulse 2s infinite;
        }

        .sp-input--unlocked::before {
            content: '🔓';
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 12px;
            opacity: 0.8;
            pointer-events: none;
        }

        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 2px rgba(234, 179, 8, 0.1); }
            50% { box-shadow: 0 0 0 4px rgba(234, 179, 8, 0.2); }
        }

        /* Enhanced Badge */
        .sp-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.5rem 1rem;
            background: linear-gradient(135deg, var(--primary-500) 0%, var(--primary-600) 50%, var(--accent-purple) 100%);
            color: white;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.875rem;
            min-width: 60px;
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
        }

        .sp-badge::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            animation: shine 3s ease-in-out infinite;
        }

        @keyframes shine {
            0% { left: -100%; }
            50% { left: -100%; }
            100% { left: 100%; }
        }

        /* Actions */
        .sp-actions {
            display: flex;
            gap: 0.75rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .sp-col-actions {
            width: 220px;
            text-align: center;
        }

        /* Enhanced Empty state */
        .sp-empty {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--gray-500);
            font-size: 1.125rem;
            font-weight: 500;
        }

        .sp-empty i {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            display: block;
            background: linear-gradient(135deg, var(--gray-400), var(--gray-500));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: float 3s ease-in-out infinite;
        }

        /* Footer */
        .sp-footer {
            text-align: center;
            padding: 2rem;
            color: rgba(255,255,255,0.8);
            font-size: 0.95rem;
            font-weight: 500;
            margin-top: auto;
            backdrop-filter: blur(10px);
        }

        /* Enhanced Loading state */
        .sp-loading {
            opacity: 0.7;
            pointer-events: none;
            position: relative;
        }

        .sp-loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 24px;
            height: 24px;
            margin: -12px 0 0 -12px;
            border: 3px solid rgba(255,255,255,0.3);
            border-top: 3px solid var(--primary-500);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Lock/Unlock notification */
        .lock-hint {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: rgba(0,0,0,0.8);
            color: white;
            padding: 1rem 1.5rem;
            border-radius: var(--radius);
            font-size: 0.875rem;
            font-weight: 500;
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.3s ease;
            z-index: 1000;
            backdrop-filter: blur(10px);
        }

        .lock-hint.show {
            opacity: 1;
            transform: translateY(0);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sp-container {
                padding: 1rem;
            }

            .sp-header {
                padding: 1.5rem;
            }

            .sp-header-content {
                flex-direction: column;
                align-items: stretch;
            }

            .sp-header-text h1 {
                font-size: 2.5rem;
            }

            .sp-toolbar {
                justify-content: stretch;
            }

            .sp-search-wrapper {
                min-width: auto;
                flex: 1;
            }

            .sp-btn {
                flex: 1;
                justify-content: center;
            }

            .sp-table-wrapper {
                border-radius: 0;
                margin: 0 -1rem;
            }

            .sp-actions {
                flex-direction: column;
                width: 100%;
            }

            .sp-actions .sp-btn {
                width: 100%;
            }
        }

        /* Custom SweetAlert2 styling */
        .swal2-popup {
            border-radius: var(--radius-lg) !important;
            font-family: 'Inter', sans-serif !important;
            backdrop-filter: blur(20px) !important;
            background: rgba(255,255,255,0.95) !important;
            border: 1px solid rgba(255,255,255,0.2) !important;
        }

        .swal2-title {
            font-weight: 700 !important;
            color: var(--gray-800) !important;
        }

        .swal2-confirm {
            background: linear-gradient(135deg, var(--primary-600), var(--primary-700)) !important;
            border-radius: var(--radius-sm) !important;
            font-weight: 600 !important;
            padding: 0.75rem 2rem !important;
            box-shadow: var(--shadow-lg) !important;
        }

        .swal2-cancel {
            background: linear-gradient(135deg, var(--gray-500), var(--gray-600)) !important;
            border-radius: var(--radius-sm) !important;
            font-weight: 600 !important;
            padding: 0.75rem 2rem !important;
            box-shadow: var(--shadow-lg) !important;
        }
    </style>
</head>
<body>
<% request.setAttribute("activePage", "manage-users"); %>
<%@ include file="/staff/includes/navbar.jsp" %>

<!-- Floating particles -->
<div class="particles" id="particles"></div>

<main class="sp-container">
    <header class="sp-header">
        <div class="sp-header-content">
            <div class="sp-header-text">
                <h1>Manage Customers</h1>
                <p>Advanced user management with secure editing capabilities</p>
            </div>
            <form class="sp-toolbar" method="get" action="${pageContext.request.contextPath}/manage-users">
                <div class="sp-search-wrapper">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input class="sp-input" type="search" name="q" placeholder="Search by name, account, email..." value="<%= q != null ? q : "" %>" />
                </div>
                <button class="sp-btn sp-btn--outline" type="submit">
                    <i class="fa-solid fa-search"></i> Search
                </button>
                <a class="sp-btn sp-btn--primary" href="${pageContext.request.contextPath}/register?user_type=customer&redirectTo=${pageContext.request.contextPath}/manage-users">
                    <i class="fa-solid fa-user-plus"></i> New User
                </a>
            </form>
        </div>
    </header>

    <div class="sp-table-container">
        <div class="sp-table-wrapper">
            <table class="sp-table">
                <thead>
                <tr>
                    <th><i class="fa-solid fa-hashtag"></i> ID</th>
                    <th><i class="fa-solid fa-credit-card"></i> Account</th>
                    <th><i class="fa-solid fa-user"></i> Name</th>
                    <th><i class="fa-solid fa-map-marker-alt"></i> Address</th>
                    <th><i class="fa-solid fa-phone"></i> Telephone</th>
                    <th><i class="fa-solid fa-envelope"></i> Email</th>
                    <th><i class="fa-solid fa-bolt"></i> Units</th>
                    <th class="sp-col-actions"><i class="fa-solid fa-cogs"></i> Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (users != null && !users.isEmpty()) {
                        for (Userdto user : users) {
                            String formId = "f-" + user.getId();
                %>
                <tr data-user-id="<%= user.getId() %>">
                    <td><strong>#<%= user.getId() %></strong></td>
                    <td><%= user.getAccount_number() %></td>
                    <td>
                        <input class="sp-input sp-input--sm sp-input--locked editable-field"
                               type="text"
                               name="name"
                               value="<%= user.getName() %>"
                               form="<%= formId %>"
                               readonly
                               title="Double-click to edit" />
                    </td>
                    <td>
                        <input class="sp-input sp-input--sm sp-input--locked editable-field"
                               type="text"
                               name="address"
                               value="<%= user.getAddress() %>"
                               form="<%= formId %>"
                               readonly
                               title="Double-click to edit" />
                    </td>
                    <td>
                        <input class="sp-input sp-input--sm sp-input--locked editable-field"
                               type="text"
                               name="telephone"
                               value="<%= user.getTelephone() %>"
                               form="<%= formId %>"
                               readonly
                               title="Double-click to edit" />
                    </td>
                    <td>
                        <input class="sp-input sp-input--sm sp-input--locked editable-field"
                               type="email"
                               name="email"
                               value="<%= user.getEmail() %>"
                               form="<%= formId %>"
                               readonly
                               title="Double-click to edit" />
                    </td>
                    <td><span class="sp-badge"><i class="fa-solid fa-bolt"></i> <%= user.getUnitsConsumed() %></span></td>
                    <td class="sp-actions">
                        <form id="<%= formId %>" action="${pageContext.request.contextPath}/manage-users" method="post" class="sp-row-form">
                            <input type="hidden" name="id" value="<%= user.getId() %>">
                            <input type="hidden" name="user_type" value="<%= user.getUser_type() %>">
                            <button class="sp-btn sp-btn--outline sp-btn--sm update-btn" type="submit" name="action" value="update" disabled>
                                <i class="fa-solid fa-save"></i> Update
                            </button>
                            <button class="sp-btn sp-btn--danger sp-btn--sm delete-btn" type="button" data-user-id="<%= user.getId() %>" data-user-name="<%= user.getName() %>">
                                <i class="fa-solid fa-trash"></i> Delete
                            </button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="8" class="sp-empty">
                        <i class="fa-regular fa-users"></i>
                        <div>No users found</div>
                        <small>Try adjusting your search criteria or add a new user</small>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</main>

<footer class="sp-footer">
    <p>© <span id="sp-year"></span> Pahana Edu. All rights reserved.</p>
</footer>

<!-- Lock/Unlock hint -->
<div class="lock-hint" id="lockHint">
    <i class="fa-solid fa-info-circle"></i> Double-click any field to edit, double-click again to lock
</div>

<script>
    // Set current year
    document.getElementById('sp-year').textContent = new Date().getFullYear();

    // Create floating particles
    function createParticles() {
        const particles = document.getElementById('particles');
        const particleCount = 20;

        for (let i = 0; i < particleCount; i++) {
            const particle = document.createElement('div');
            particle.className = 'particle';
            particle.style.left = Math.random() * 100 + '%';
            particle.style.top = Math.random() * 100 + '%';
            particle.style.animationDelay = Math.random() * 6 + 's';
            particle.style.animationDuration = (Math.random() * 3 + 3) + 's';
            particles.appendChild(particle);
        }
    }

    createParticles();

    // Show notifications if any
    <% if (message != null && messageType != null) { %>
    const messageType = '<%= messageType %>';
    const message = '<%= message %>';

    let icon = 'info';
    let title = 'Notification';

    switch(messageType.toLowerCase()) {
        case 'success':
            icon = 'success';
            title = 'Success!';
            break;
        case 'error':
            icon = 'error';
            title = 'Error!';
            break;
        case 'warning':
            icon = 'warning';
            title = 'Warning!';
            break;
    }

    Swal.fire({
        icon: icon,
        title: title,
        text: message,
        confirmButtonText: 'Got it!',
        timer: 5000,
        timerProgressBar: true,
        showCloseButton: true,
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        background: 'rgba(255,255,255,0.95)',
        backdrop: 'rgba(0,0,0,0.1)'
    });
    <% } %>

    // Lock/Unlock functionality
    document.addEventListener('DOMContentLoaded', function() {
        const editableFields = document.querySelectorAll('.editable-field');
        const lockHint = document.getElementById('lockHint');
        let hintTimeout;

        // Show hint initially
        setTimeout(() => {
            lockHint.classList.add('show');
            setTimeout(() => {
                lockHint.classList.remove('show');
            }, 4000);
        }, 1000);

        editableFields.forEach(field => {
            let clickCount = 0;
            let clickTimer = null;

            field.addEventListener('click', function() {
                clickCount++;

                if (clickCount === 1) {
                    clickTimer = setTimeout(() => {
                        clickCount = 0;
                    }, 300);
                } else if (clickCount === 2) {
                    clearTimeout(clickTimer);
                    clickCount = 0;

                    // Toggle lock/unlock
                    if (this.readOnly) {
                        // Unlock
                        this.readOnly = false;
                        this.classList.remove('sp-input--locked');
                        this.classList.add('sp-input--unlocked');
                        this.focus();
                        this.select();

                        // Enable update button for this row
                        const form = this.closest('tr').querySelector('.sp-row-form');
                        const updateBtn = form.querySelector('.update-btn');
                        updateBtn.disabled = false;
                        updateBtn.classList.add('sp-btn--primary');
                        updateBtn.classList.remove('sp-btn--outline');

                        // Show unlock notification
                        this.title = 'Double-click to lock';

                        // Show hint
                        lockHint.innerHTML = '<i class="fa-solid fa-unlock"></i> Field unlocked! You can now edit this field.';
                        lockHint.classList.add('show');
                        clearTimeout(hintTimeout);
                        hintTimeout = setTimeout(() => {
                            lockHint.classList.remove('show');
                        }, 2000);

                    } else {
                        // Lock
                        this.readOnly = true;
                        this.classList.remove('sp-input--unlocked');
                        this.classList.add('sp-input--locked');
                        this.blur();

                        // Check if all fields in row are locked
                        const row = this.closest('tr');
                        const unlockedFields = row.querySelectorAll('.editable-field:not([readonly])');

                        if (unlockedFields.length === 0) {
                            // All fields locked, disable update button
                            const form = row.querySelector('.sp-row-form');
                            const updateBtn = form.querySelector('.update-btn');
                            updateBtn.disabled = true;
                            updateBtn.classList.remove('sp-btn--primary');
                            updateBtn.classList.add('sp-btn--outline');
                        }

                        // Show lock notification
                        this.title = 'Double-click to edit';

                        // Show hint
                        lockHint.innerHTML = '<i class="fa-solid fa-lock"></i> Field locked! Double-click to edit again.';
                        lockHint.classList.add('show');
                        clearTimeout(hintTimeout);
                        hintTimeout = setTimeout(() => {
                            lockHint.classList.remove('show');
                        }, 2000);
                    }
                }
            });

            // Handle Enter key to lock field
            field.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' && !this.readOnly) {
                    this.click();
                    this.click(); // Double click to lock
                }
            });
        });

        // Handle delete confirmations with SweetAlert
        const deleteButtons = document.querySelectorAll('.delete-btn');

        deleteButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();

                const userId = this.getAttribute('data-user-id');
                const userName = this.getAttribute('data-user-name');
                const form = this.closest('form');

                Swal.fire({
                    title: 'Delete User?',
                    html: `Are you sure you want to delete <strong>${userName}</strong>?<br><small style="color: #6b7280; font-size: 0.875rem;">This action cannot be undone.</small>`,
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: '<i class="fa-solid fa-trash"></i> Yes, delete!',
                    cancelButtonText: '<i class="fa-solid fa-times"></i> Cancel',
                    confirmButtonColor: '#ef4444',
                    cancelButtonColor: '#6b7280',
                    focusCancel: true,
                    background: 'rgba(255,255,255,0.95)',
                    backdrop: 'rgba(0,0,0,0.4)',
                    customClass: {
                        confirmButton: 'swal2-confirm',
                        cancelButton: 'swal2-cancel'
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Add loading state
                        this.classList.add('sp-loading');
                        this.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Deleting...';

                        // Create hidden input for delete action
                        const deleteInput = document.createElement('input');
                        deleteInput.type = 'hidden';
                        deleteInput.name = 'action';
                        deleteInput.value = 'delete';
                        form.appendChild(deleteInput);

                        // Submit form
                        form.submit();
                    }
                });
            });
        });

        // Handle form submissions with loading states
        const forms = document.querySelectorAll('.sp-row-form');
        forms.forEach(form => {
            form.addEventListener('submit', function(e) {
                const submitButton = this.querySelector('button[type="submit"]');
                if (submitButton && submitButton.name === 'action' && submitButton.value === 'update') {
                    submitButton.classList.add('sp-loading');
                    submitButton.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Updating...';

                    // Show updating notification
                    Swal.fire({
                        title: 'Updating User...',
                        text: 'Please wait while we update the user information.',
                        icon: 'info',
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        showConfirmButton: false,
                        timer: 2000,
                        timerProgressBar: true,
                        background: 'rgba(255,255,255,0.95)',
                        backdrop: 'rgba(0,0,0,0.4)'
                    });
                }
            });
        });

        // Auto-focus search input on page load
        const searchInput = document.querySelector('input[name="q"]');
        if (searchInput && !searchInput.value) {
            searchInput.focus();
        }

        // Enhanced search experience
        const searchForm = document.querySelector('.sp-toolbar');
        const searchButton = searchForm?.querySelector('button[type="submit"]');

        if (searchForm && searchButton) {
            searchForm.addEventListener('submit', function() {
                searchButton.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Searching...';
                searchButton.disabled = true;
            });
        }

        // Auto-submit search after typing (debounced)
        if (searchInput) {
            let searchTimeout;
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    if (this.value.length > 2 || this.value.length === 0) {
                        searchForm.submit();
                    }
                }, 1000);
            });
        }

        // Add keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl/Cmd + K to focus search
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                if (searchInput) {
                    searchInput.focus();
                    searchInput.select();
                }
            }

            // Escape to clear search
            if (e.key === 'Escape' && document.activeElement === searchInput) {
                searchInput.value = '';
                searchForm.submit();
            }
        });
    });

    // Utility function for showing custom alerts
    window.showAlert = function(type, title, message) {
        Swal.fire({
            icon: type,
            title: title,
            text: message,
            confirmButtonText: 'OK',
            background: 'rgba(255,255,255,0.95)',
            backdrop: 'rgba(0,0,0,0.4)',
            customClass: {
                confirmButton: 'swal2-confirm'
            }
        });
    };

    // Add smooth scrolling
    document.documentElement.style.scrollBehavior = 'smooth';
</script>

<%
    String flashMsg = (String) request.getAttribute("message");
    String flashType = (String) request.getAttribute("messageType");

    // Prepare safe JS strings
    String safeType = flashType == null ? "info" : flashType;
    String safeMsg = flashMsg == null ? "" :
            flashMsg.replace("\\", "\\\\")
                    .replace("'", "\\'")
                    .replace("\r", "\\r")
                    .replace("\n", "\\n");
    String title;
    if ("success".equalsIgnoreCase(safeType)) {
        title = "Success!";
    } else if ("error".equalsIgnoreCase(safeType) || "danger".equalsIgnoreCase(safeType)) {
        title = "Error!";
    } else if ("warning".equalsIgnoreCase(safeType)) {
        title = "Warning!";
    } else {
        title = "Notification";
    }
%>
<% if (flashMsg != null) { %>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        Swal.fire({
            icon: '<%= safeType %>',
            title: '<%= title %>',
            text: '<%= safeMsg %>',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 5000,
            timerProgressBar: true,
            showCloseButton: true,
            background: 'rgba(255,255,255,0.95)',
            backdrop: 'rgba(0,0,0,0.1)',
            customClass: {
                confirmButton: 'swal2-confirm',
                cancelButton: 'swal2-cancel'
            }
        });
    });
</script>
<% } %>

</body>
</html>