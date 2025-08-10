<%--
  Created by IntelliJ IDEA.
  User: Dileeka
  Date: 8/5/2025
  Time: 11:39 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Staff Panel - Pahana Edu</title>
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/logo.png" />

    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- App Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css" />
</head>
<body>
<% request.setAttribute("activePage", "dashboard"); %>
<%@ include file="/staff/includes/navbar.jsp" %>

<main class="sp-container">
    <header class="sp-header">
        <div class="sp-header__text">
            <h1 class="sp-title">Staff Dashboard</h1>
            <p class="sp-subtitle">Welcome back, <strong>${sessionScope.username}</strong></p>
        </div>
        <div class="sp-header__actions">
            <a class="sp-btn sp-btn--outline" href="${pageContext.request.contextPath}/staff/user-lookup.jsp">
                <i class="fa-solid fa-magnifying-glass"></i>
                Check User
            </a>
            <a class="sp-btn sp-btn--primary" href="${pageContext.request.contextPath}/register?user_type=customer&redirectTo=${pageContext.request.contextPath}/staff/user-lookup.jsp">
                <i class="fa-solid fa-user-plus"></i>
                Register User
            </a>
            <a class="sp-btn sp-btn--danger" href="${pageContext.request.contextPath}/logout.jsp">
                <i class="fa-solid fa-right-from-bracket"></i>
                Logout
            </a>
        </div>
    </header>

    <section class="sp-grid">
        <article class="sp-card">
            <div class="sp-card__icon sp-card__icon--blue"><i class="fa-solid fa-book"></i></div>
            <h3 class="sp-card__title">Manage Books</h3>
            <p class="sp-card__desc">Add, edit, and organize the library collection.</p>
            <a class="sp-link" href="${pageContext.request.contextPath}/manage-books">Go to Books <i class="fa-solid fa-arrow-right"></i></a>
        </article>

        <article class="sp-card">
            <div class="sp-card__icon sp-card__icon--teal"><i class="fa-solid fa-users"></i></div>
            <h3 class="sp-card__title">Manage Users</h3>
            <p class="sp-card__desc">View, update, and support user accounts.</p>
            <a class="sp-link" href="${pageContext.request.contextPath}/manage-users">Go to Users <i class="fa-solid fa-arrow-right"></i></a>
        </article>

        <article class="sp-card">
            <div class="sp-card__icon sp-card__icon--indigo"><i class="fa-solid fa-folder-tree"></i></div>
            <h3 class="sp-card__title">Manage Categories</h3>
            <p class="sp-card__desc">Create and maintain content categories.</p>
            <a class="sp-link" href="${pageContext.request.contextPath}/manage-categories">Go to Categories <i class="fa-solid fa-arrow-right"></i></a>
        </article>

        <article class="sp-card">
            <div class="sp-card__icon sp-card__icon--cyan"><i class="fa-solid fa-file-invoice-dollar"></i></div>
            <h3 class="sp-card__title">Billing</h3>
            <p class="sp-card__desc">Check user bills and manage payments.</p>
            <a class="sp-link" href="${pageContext.request.contextPath}/check-user-bill">Go to Billing <i class="fa-solid fa-arrow-right"></i></a>
        </article>
    </section>

    <section class="sp-quick">
        <h2 class="sp-section-title">Quick Actions</h2>
        <div class="sp-quick__actions">
            <a class="sp-pill" href="${pageContext.request.contextPath}/staff/user-lookup.jsp"><i class="fa-solid fa-id-card-clip"></i> Check User</a>
            <a class="sp-pill" href="${pageContext.request.contextPath}/register?user_type=customer&redirectTo=${pageContext.request.contextPath}/staff/user-lookup.jsp"><i class="fa-solid fa-user-plus"></i> Register User</a>
            <a class="sp-pill sp-pill--danger" href="${pageContext.request.contextPath}/logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </section>
</main>

<footer class="sp-footer">
    <p>© <span id="sp-year"></span> Pahana Edu. All rights reserved.</p>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/staff.js"></script>
</body>
</html>