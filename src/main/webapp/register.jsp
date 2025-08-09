<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
</head>
<body>
<h2>User Registration</h2>

<%
    String error = request.getParameter("error");
    if ("empty".equals(error)) {
%>
<p style="color:red;">All fields are required.</p>
<%
} else if ("email".equals(error)) {
%>
<p style="color:red;">Email already exists.</p>
<%
} else if ("telephone".equals(error)) {
%>
<p style="color:red;">Telephone number already exists.</p>
<%
} else if ("unknown".equals(error)) {
%>
<p style="color:red;">An unknown error occurred.</p>
<%
    }
%>

<form action="register" method="post">
    <input type="hidden" name="user_type" value="<%= (request.getAttribute("user_type") != null ? request.getAttribute("user_type") : "customer") %>">

    <label>Account Number:</label>
    <input type="text" name="account_number" value="<%= request.getAttribute("account_number") %>" readonly ><br><br>

    <label>Name:</label>
    <input type="text" name="name" required><br><br>

    <label>Address:</label>
    <input type="text" name="address" required><br><br>

    <label>Telephone:</label>
    <input type="text" name="telephone" required><br><br>

    <label>Email:</label>
    <input type="email" name="email" required><br><br>

    <button type="submit">Register</button>
</form>
</body>
</html>
