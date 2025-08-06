<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="src.business.bookcategory.dto.BookCategoryDto" %>
<%
    List<BookCategoryDto> categories = (List<BookCategoryDto>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Book Categories</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        form { display: inline; }
    </style>
</head>
<body>
<h2>Manage Book Categories</h2>

<!-- Add Category Form -->
<h3>Add New Category</h3>
<form method="post" action="manage-categories">
    <input type="hidden" name="action" value="add">
    <input type="text" name="name" placeholder="Category Name" required>
    <input type="text" name="description" placeholder="Description">
    <button type="submit">Add</button>
</form>

<hr>

<!-- Category Table -->
<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Description</th>
        <th>Actions</th>
    </tr>
    <%
        if (categories != null) {
            for (BookCategoryDto cat : categories) {
    %>
    <tr>
        <form method="post" action="manage-categories">
            <td><%= cat.getId() %></td>
            <td><input type="text" name="name" value="<%= cat.getName() %>"></td>
            <td><input type="text" name="description" value="<%= cat.getDescription() %>"></td>
            <td>
                <input type="hidden" name="id" value="<%= cat.getId() %>">
                <button type="submit" name="action" value="update">Update</button>
                <button type="submit" name="action" value="delete" onclick="return confirm('Delete this category?')">Delete</button>
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
