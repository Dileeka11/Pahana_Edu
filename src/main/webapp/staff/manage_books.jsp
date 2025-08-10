<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="src.business.book.dto.BookDto" %>
<%@ page import="src.business.bookcategory.dto.BookCategoryDto" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    List<BookDto> books = (List<BookDto>) request.getAttribute("books");
    List<BookCategoryDto> categories = (List<BookCategoryDto>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Books</title>
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/img/favicon-32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/img/favicon-16.png" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage_books.css?v=1" />
    <script src="${pageContext.request.contextPath}/assets/js/manage_books.js?v=1" defer></script>
</head>
<body>
<c:set var="activePage" value="books" />
<%@ include file="/staff/includes/navbar.jsp" %>

<div class="container">
  <h1 class="page-title">Manage Books</h1>

  <div class="card">
    <div class="card-header">
      <div class="card-title">Add New Book</div>
    </div>

    <form method="post" action="manage-books" enctype="multipart/form-data">
      <input type="hidden" name="action" value="add">

      <div class="form-grid">
        <div class="field">
          <label for="category_id">Category</label>
          <select id="category_id" name="category_id" required>
            <option value="">-- Select Category --</option>
            <% for (BookCategoryDto cat : categories) { %>
              <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
            <% } %>
          </select>
        </div>

        <div class="field-wide">
          <label for="name">Book Name</label>
          <input id="name" type="text" name="name" placeholder="Book Name" required>
        </div>

        <div class="field-wide">
          <label for="description">Description</label>
          <input id="description" type="text" name="description" placeholder="Description">
        </div>

        <div class="field">
          <label for="price">Price</label>
          <input id="price" type="number" step="0.01" name="price" placeholder="Price" required>
        </div>

        <div class="field">
          <label for="qty">Quantity</label>
          <input id="qty" type="number" name="qty" value="1" min="0" required>
        </div>

        <div class="field-full">
          <label for="photo">Photo</label>
          <input id="photo" type="file" name="photo">
        </div>
      </div>

      <div class="spacer"></div>
      <button class="btn btn-primary" type="submit">Add Book</button>
    </form>
  </div>

  <div class="card">
    <div class="card-header">
      <div class="card-title">Books</div>
    </div>

    <div class="table-wrap">
      <table class="table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Category</th>
            <th>Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Qty</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
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
              <td><input type="number" name="qty" value="<%= book.getQty() %>" min="0"></td>
              <td class="actions">
                <input type="hidden" name="id" value="<%= book.getId() %>">
                <button class="btn btn-outline" type="submit" name="action" value="update">Update</button>
                <button class="btn btn-danger" type="submit" name="action" value="delete" data-confirm="Are you sure to delete this book?">Delete</button>
              </td>
            </form>
          </tr>
        <% }} %>
        </tbody>
      </table>
    </div>
  </div>
</div>

</body>
</html>
