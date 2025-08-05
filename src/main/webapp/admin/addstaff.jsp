<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Staff</title>
</head>
<body>
<h2>Staff Registration</h2>
<form action="addstaff" method="post">
    <label>Username:</label>
    <input type="text" name="username" required><br><br>

    <label>Email:</label>
    <input type="email" name="email" required><br><br>

    <label>Password:</label>
    <input type="password" name="password" required><br><br>

    <input type="hidden" name="user_type" value="Staff">

    <button type="submit">Add Staff</button>
</form>

<%
    if (request.getParameter("success") != null) {
%>
<p style="color:green;">Staff added successfully!</p>
<%
} else if (request.getParameter("error") != null) {
%>
<p style="color:red;">Failed to add staff. Please try again.</p>
<%
    }
%>
</body>
</html>
