<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="src.business.book.dto.BookDto" %>
<%@ page import="src.business.bookcategory.dto.BookCategoryDto" %>
<%
    List<BookDto> books = (List<BookDto>) request.getAttribute("books");
    List<BookCategoryDto> categories = (List<BookCategoryDto>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Books</title>
    <style>
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 8px; }
    </style>
</head>
<body>
<h2>Manage Books</h2>

<!-- Add Book Form -->
<h3>Add New Book</h3>
<form method="post" action="manage-books" enctype="multipart/form-data">
    <input type="hidden" name="action" value="add">
    <select name="category_id" required>
        <option value="">-- Select Category --</option>
        <% for (BookCategoryDto cat : categories) { %>
        <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
        <% } %>
    </select>
    <input type="text" name="name" placeholder="Book Name" required>
    <input type="text" name="description" placeholder="Description">
    <input type="number" step="0.01" name="price" placeholder="Price">
    <input type="file" name="photo">
    <button type="submit">Add</button>
</form>

<hr>

<!-- Book Table -->
<table>
    <tr>
        <th>ID</th>
        <th>Category</th>
        <th>Name</th>
        <th>Description</th>
        <th>Price</th>
        <th>Photo</th>
        <th>Actions</th>
    </tr>
    <% if (books != null) {
        for (BookDto book : books) { %>
    <tr>
        <form method="post" action="manage-books" enctype="multipart/form-data">
            <td><%= book.getId() %></td>
            <td>
                <select name="category_id">
                    <% for (BookCategoryDto cat : categories) { %>
                    <option value="<%= cat.getId() %>" <%= (cat.getId() == book.getCategoryId() ? "selected" : "") %>>
                        <%= cat.getName() %>
                    </option>
                    <% } %>
                </select>
            </td>
            <td><input type="text" name="name" value="<%= book.getName() %>"></td>
            <td><input type="text" name="description" value="<%= book.getDescription() %>"></td>
            <td><input type="number" step="0.01" name="price" value="<%= book.getPrice() %>"></td>
            <td>
                <% if (book.getPhoto() != null) { %>
                <img src="<%= book.getPhoto() %>" width="50">
                <% } %>
                <input type="file" name="photo">
                <input type="hidden" name="existingPhoto" value="<%= book.getPhoto() %>">
            </td>
            <td>
                <input type="hidden" name="id" value="<%= book.getId() %>">
                <button type="submit" name="action" value="update">Update</button>
                <button type="submit" name="action" value="delete" onclick="return confirm('Delete this book?')">Delete</button>
            </td>
        </form>
    </tr>
    <% }} %>
</table>
</body>
</html>
