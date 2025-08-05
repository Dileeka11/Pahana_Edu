<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
<h2>Login Page</h2>

<form method="post" action="login">
    <label>Email:</label><br>
    <input type="text" name="email" required><br><br>

    <label>Password:</label><br>
    <input type="password" name="password" required><br><br>

    <button type="submit">Login</button>
</form>

<%
    if (request.getParameter("error") != null) {
%>
<p style="color:red;">Invalid credentials. Please try again.</p>
<%
    }
%>
</body>
</html>
