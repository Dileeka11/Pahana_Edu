<%--
  Created by IntelliJ IDEA.
  User: Dileeka
  Date: 8/5/2025
  Time: 11:39 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.util.Enumeration" %>
<html>
<head>
    <title>Staff Panel - Pahana Edu</title>
</head>
<body>
    <h1>Staff Dashboard</h1>

    <div>
        <h2>Welcome, ${sessionScope.username}</h2>
    </div>

    <div>
        <h2>Navigation</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/manage-books">Manage Books</a></li>
            <li><a href="${pageContext.request.contextPath}/manage-users">Manage Users</a></li>
            <li><a href="${pageContext.request.contextPath}/manage-categories">Manage Categories</a></li>
            <li><a href="${pageContext.request.contextPath}/check-user-bill">Billing</a></li>

        </ul>
    </div>

    <div>
        <h2>Quick Actions</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/staff/check-user.jsp">Check User</a></li>
            <li><a href="${pageContext.request.contextPath}/logout.jsp">Logout</a></li>
        </ul>
    </div>
</body>
</html>
