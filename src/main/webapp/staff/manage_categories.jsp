<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="src.business.bookcategory.dto.BookCategoryDto" %>
<%
    List<BookCategoryDto> categories = (List<BookCategoryDto>) request.getAttribute("categories");
    int categoryCount = categories != null ? categories.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Book Categories</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage-categories.css">
</head>
<body>
<%@ include file="/staff/includes/navbar.jsp" %>
<div class="container">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-title">Manage Categories</h1>
        <div class="stats-bar">
            <div class="stat-item">
                <span class="stat-number category-count"><%= categoryCount %></span>
                <span class="stat-label">Total Categories</span>
            </div>
        </div>
    </div>

    <!-- Add New Category Card -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title add-category">Add New Category</h2>
        </div>

        <div class="add-form">
            <form method="post" action="manage-categories" id="add-category-form" data-autosave="true">
                <input type="hidden" name="action" value="add">

                <div class="form-row">
                    <div class="form-group">
                        <label for="category-name">Category Name *</label>
                        <input type="text"
                               id="category-name"
                               name="name"
                               placeholder="Enter category name..."
                               required
                               maxlength="50"
                               autocomplete="off">
                    </div>

                    <div class="form-group">
                        <label for="category-description">Description</label>
                        <input type="text"
                               id="category-description"
                               name="description"
                               placeholder="Brief description of the category..."
                               maxlength="200"
                               autocomplete="off">
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            ➕ Add Category
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Search and Filter -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title manage-list">Category List</h2>
        </div>

        <div class="form-group" style="margin-bottom: 20px;">
            <label for="category-search">🔍 Search Categories</label>
            <input type="text"
                   id="category-search"
                   placeholder="Search by name or description... (Ctrl+K)"
                   autocomplete="off">
        </div>

        <!-- Categories Grid -->
        <div class="categories-grid">
            <%
                if (categories != null && !categories.isEmpty()) {
                    for (BookCategoryDto cat : categories) {
            %>
            <div class="category-item">
                <div class="category-header">
                    <div class="category-id">ID: <%= cat.getId() %></div>
                    <div class="category-actions">
                        <button type="button" class="btn btn-sm btn-outline edit-btn">
                            ✏️ Edit
                        </button>
                        <form method="post" action="manage-categories" style="display: inline;">
                            <input type="hidden" name="id" value="<%= cat.getId() %>">
                            <input type="hidden" name="name" value="<%= cat.getName() %>">
                            <button type="submit"
                                    name="action"
                                    value="delete"
                                    class="btn btn-sm btn-danger"
                                    data-confirm="Delete category '<%= cat.getName() %>'? This action cannot be undone.">
                                🗑️ Delete
                            </button>
                        </form>
                    </div>
                </div>

                <div class="category-content">
                    <h4><%= cat.getName() %></h4>
                    <p><%= cat.getDescription() != null ? cat.getDescription() : "" %></p>
                </div>

                <!-- Inline Edit Form (Hidden by default) -->
                <div class="edit-form">
                    <form method="post" action="manage-categories">
                        <input type="hidden" name="id" value="<%= cat.getId() %>">
                        <input type="hidden" name="action" value="update">

                        <div class="edit-form-row">
                            <div class="form-group">
                                <label>Category Name</label>
                                <input type="text"
                                       name="name"
                                       value="<%= cat.getName() %>"
                                       required
                                       maxlength="50">
                            </div>

                            <div class="form-group">
                                <label>Description</label>
                                <input type="text"
                                       name="description"
                                       value="<%= cat.getDescription() != null ? cat.getDescription() : "" %>"
                                       maxlength="200">
                            </div>
                        </div>

                        <div class="edit-actions">
                            <button type="button" class="btn btn-sm btn-outline cancel-btn">
                                ❌ Cancel
                            </button>
                            <button type="submit" class="btn btn-sm btn-success">
                                💾 Update
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <!-- Empty State -->
            <div class="empty-state">
                <div class="icon">📚</div>
                <h3>No Categories Found</h3>
                <p>Start by adding your first book category above.</p>
            </div>
            <%
                }
            %>
        </div>

        <!-- Empty Search State (Hidden by default) -->
        <div class="empty-state empty-search-state" style="display: none;">
            <div class="icon">🔍</div>
            <h3>No Categories Match Your Search</h3>
            <p>Try adjusting your search terms or browse all categories.</p>
        </div>
    </div>
</div>

<!-- Toast Container (Created dynamically by JS) -->

<script src="${pageContext.request.contextPath}/assets/js/manage-categories.js"></script>
</body>
</html>