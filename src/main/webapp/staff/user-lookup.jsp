<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Lookup - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .error-message {
            color: #dc3545;
            margin-top: 5px;
        }
        .register-link {
            margin-top: 10px;
            display: block;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">User Lookup</h4>
                    </div>
                    <div class="card-body">
                        <%-- Check for error message --%>
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger" role="alert">
                                <%= request.getAttribute("error") %>
                                <a href="<%= request.getContextPath() %>/register?user_type=customer&redirectTo=<%= request.getContextPath() %>/staff/user-lookup.jsp" class="alert-link">Register as new user</a>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/check-user-bill" method="GET">
                            <div class="mb-3">
                                <label for="searchTerm" class="form-label">Enter Email or Phone Number</label>
                                <input type="text" class="form-control" id="searchTerm" name="searchTerm"
                                       value="<%= request.getParameter("searchTerm") != null ? request.getParameter("searchTerm") : "" %>" required>
                            </div>
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Search User</button>
                                <a href="<%= request.getContextPath() %>/staff" class="btn btn-secondary">Back to Dashboard</a>
                            </div>
                        </form>

                        <div class="mt-3 text-center">
                            <p>New user? <a href="<%= request.getContextPath() %>/register?user_type=customer&redirectTo=<%= request.getContextPath() %>/staff/user-lookup.jsp">Register here</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
