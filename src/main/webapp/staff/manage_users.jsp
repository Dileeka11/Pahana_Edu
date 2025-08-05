<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="src.business.user.dto.Userdto" %>
<%
    List<Userdto> users = (List<Userdto>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        form { display: inline; }
    </style>
</head>
<body>
<h2>Manage Users</h2>
<table>
    <tr>
        <th>ID</th>
        <th>Account</th>
        <th>Name</th>
        <th>Address</th>
        <th>Telephone</th>
        <th>Email</th>
        <th>Actions</th>
    </tr>
    <%
        if (users != null) {
            for (Userdto user : users) {
    %>
    <tr>
        <form action="manage-users" method="post">
            <td><%= user.getId() %></td>
            <td><%= user.getAccount_number() %></td>
            <td><input type="text" name="name" value="<%= user.getName() %>"></td>
            <td><input type="text" name="address" value="<%= user.getAddress() %>"></td>
            <td><input type="text" name="telephone" value="<%= user.getTelephone() %>"></td>
            <td><input type="email" name="email" value="<%= user.getEmail() %>"></td>
            <td>
                <input type="hidden" name="id" value="<%= user.getId() %>">
                <button type="submit" name="action" value="update">Update</button>
                <button type="submit" name="action" value="delete" onclick="return confirm('Delete this user?')">Delete</button>
            </td>
        </form>
    </tr>
    <%
            }
        }
    %>
</table>
</body>
</html>
