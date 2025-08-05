<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page session="true" %>
<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel</title>
</head>
<body>
<h2>Welcome to the Admin Panel</h2>
<p>You are logged in as: <strong><%= session.getAttribute("user") %></strong></p>
<a href="../logout.jsp">Logout</a>
</body>
</html>
