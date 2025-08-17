<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="src.business.bookcategory.dto.BookCategoryDto" %>
<%
    List<BookCategoryDto> categories = (List<BookCategoryDto>) request.getAttribute("categories");
    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Categories Management</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert2/11.10.1/sweetalert2.all.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #87ceeb 0%, #b0e0e6 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #4da6ff 0%, #66b3ff 100%);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: shimmer 3s ease-in-out infinite;
        }

        @keyframes shimmer {
            0%, 100% { transform: rotate(0deg); }
            50% { transform: rotate(180deg); }
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            position: relative;
            z-index: 2;
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
            position: relative;
            z-index: 2;
        }

        .content {
            padding: 40px;
        }

        .add-form {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 30px;
            border-radius: 16px;
            margin-bottom: 40px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .add-form h3 {
            color: #1e293b;
            font-size: 1.5rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .form-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: end;
        }

        .form-field {
            flex: 1;
            min-width: 200px;
        }

        .form-field label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-input:focus {
            outline: none;
            border-color: #4da6ff;
            box-shadow: 0 0 0 3px rgba(77, 166, 255, 0.1);
            transform: translateY(-1px);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            font-size: 0.95rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4da6ff 0%, #66b3ff 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(77, 166, 255, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(77, 166, 255, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #33ccff 0%, #1ab3e6 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(51, 204, 255, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(51, 204, 255, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4);
        }

        .categories-table {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .table-header {
            background: linear-gradient(135deg, #4da6ff 0%, #66b3ff 100%);
            color: white;
            padding: 20px 30px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table-header h3 {
            font-size: 1.3rem;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        th, td {
            padding: 16px 20px;
            text-align: left;
            border-bottom: 1px solid #f1f5f9;
        }

        th {
            background: #f8fafc;
            color: #374151;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        tr {
            transition: all 0.3s ease;
        }

        tr:hover {
            background: #f8fafc;
            transform: scale(1.001);
        }

        .table-input {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 8px 12px;
            width: 100%;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            background-color: #f8fafc;
            cursor: pointer;
        }

        .table-input:focus {
            outline: none;
            border-color: #4da6ff;
            box-shadow: 0 0 0 2px rgba(77, 166, 255, 0.1);
        }

        .table-input.editable {
            background-color: white;
            border-color: #4da6ff;
            cursor: text;
        }

        .table-input.editable:focus {
            box-shadow: 0 0 0 3px rgba(77, 166, 255, 0.2);
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 0.85rem;
        }

        .id-badge {
            background: linear-gradient(135deg, #4da6ff 0%, #66b3ff 100%);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
            display: inline-block;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .divider {
            height: 1px;
            background: linear-gradient(90deg, transparent 0%, #e5e7eb 50%, transparent 100%);
            margin: 40px 0;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 16px;
            }

            .content {
                padding: 20px;
            }

            .form-group {
                flex-direction: column;
            }

            .form-field {
                min-width: 100%;
            }

            .action-buttons {
                flex-direction: column;
            }

            .header h1 {
                font-size: 2rem;
            }

            table {
                font-size: 0.9rem;
            }

            th, td {
                padding: 12px 16px;
            }
        }
    </style>
</head>
<body>
<%@ include file="/staff/includes/navbar.jsp" %>
<div class="container">
    <div class="header">
        <h1><i class="fas fa-book-open"></i> Book Categories</h1>
        <p>Manage your library's book categories efficiently</p>
    </div>

    <div class="content">
        <!-- Add Category Form -->
        <div class="add-form">
            <h3><i class="fas fa-plus-circle"></i> Add New Category</h3>
            <form method="post" action="manage-categories">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <div class="form-field">
                        <label for="categoryName">Category Name</label>
                        <input type="text" id="categoryName" name="name" class="form-input" placeholder="Enter category name" required>
                    </div>
                    <div class="form-field">
                        <label for="categoryDesc">Description</label>
                        <input type="text" id="categoryDesc" name="description" class="form-input" placeholder="Enter description (optional)">
                    </div>
                    <div class="form-field" style="flex: 0;">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add Category
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <div class="divider"></div>

        <!-- Categories Table -->
        <div class="categories-table">
            <div class="table-header">
                <i class="fas fa-table"></i>
                <h3>Manage Categories</h3>
            </div>

            <% if (categories != null && !categories.isEmpty()) { %>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Category Name</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (BookCategoryDto cat : categories) { %>
                <tr>
                    <form method="post" action="manage-categories">
                        <td>
                            <span class="id-badge">#<%= cat.getId() %></span>
                        </td>
                        <td>
                            <input type="text" name="name" value="<%= cat.getName() %>" class="table-input" readonly ondblclick="makeEditable(this)">
                        </td>
                        <td>
                            <input type="text" name="description" value="<%= cat.getDescription() %>" class="table-input" readonly ondblclick="makeEditable(this)">
                        </td>
                        <td>
                            <input type="hidden" name="id" value="<%= cat.getId() %>">
                            <div class="action-buttons">
                                <button type="submit" name="action" value="update" class="btn btn-success btn-sm">
                                    <i class="fas fa-save"></i> Update
                                </button>
                                <button type="submit" name="action" value="delete" class="btn btn-danger btn-sm" onclick="return confirm('Delete this category?')">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </div>
                        </td>
                    </form>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <i class="fas fa-folder-open"></i>
                <h3>No Categories Found</h3>
                <p>Start by adding your first book category above.</p>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    // Make input field editable on double click
    function makeEditable(input) {
        input.readOnly = false;
        input.classList.add('editable');
        input.focus();
        input.select();

        // Show tooltip
        Swal.fire({
            icon: 'info',
            title: 'Edit Mode',
            text: 'Field is now editable. Click Update to save changes.',
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true
        });
    }

    // Make input readonly when clicking outside or pressing Enter
    document.addEventListener('click', function(e) {
        const editableInputs = document.querySelectorAll('.table-input.editable');
        editableInputs.forEach(input => {
            if (e.target !== input) {
                input.readOnly = true;
                input.classList.remove('editable');
            }
        });
    });

    // Handle Enter key to save
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && e.target.classList.contains('table-input')) {
            e.target.readOnly = true;
            e.target.classList.remove('editable');
            e.target.blur();
        }
    });

    // Show server-side notifications only
    <% if (message != null && !message.trim().isEmpty()) { %>
    document.addEventListener('DOMContentLoaded', function() {
        const messageType = '<%= messageType != null ? messageType : "info" %>';
        const messageText = `<%= message.replace("\"", "\\\"").replace("'", "\\'") %>`;

        let icon = 'info';
        let title = 'Notification';

        switch(messageType.toLowerCase()) {
            case 'success':
                icon = 'success';
                title = 'Success!';
                break;
            case 'error':
            case 'danger':
                icon = 'error';
                title = 'Error!';
                break;
            case 'warning':
                icon = 'warning';
                title = 'Warning!';
                break;
        }

        if (typeof Swal !== 'undefined') {
            Swal.fire({
                icon: icon,
                title: title,
                text: messageText,
                confirmButtonColor: '#4da6ff',
                timer: 4000,
                timerProgressBar: true
            });
        }
    });
    <% } %>
</script>

<% if (message != null && !message.trim().isEmpty()) { %>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        Swal.fire({
            icon: '<%= messageType != null ? messageType : "info" %>',
            title: '<%= messageType != null && messageType.equalsIgnoreCase("success") ? "Success!" :
                  messageType != null && (messageType.equalsIgnoreCase("error") || messageType.equalsIgnoreCase("danger")) ? "Error!" :
                  messageType != null && messageType.equalsIgnoreCase("warning") ? "Warning!" : "Info" %>',
            text: '<%= message.replace("'", "\\'") %>',
            confirmButtonColor: '#4da6ff',
            timer: 4000,
            timerProgressBar: true
        });
    });
</script>
<% } %>

</body>
</html>