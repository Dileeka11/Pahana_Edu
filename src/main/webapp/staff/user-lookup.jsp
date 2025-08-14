<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Lookup - Pahana Edu</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <link href="<%= request.getContextPath() %>/staff/assets/css/user-lookup.css" rel="stylesheet">

    <style>
        /* Inline styles specific to this page */
        .card {
            max-width: 500px;
            margin: 0 auto;
        }

        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            pointer-events: none;
        }

        .input-group {
            position: relative;
        }
    </style>
</head>
<body>

<%@ include file="/staff/includes/navbar.jsp" %>
    <!-- Toast Container for Notifications -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
        <div id="toastContainer" class="toast-container"></div>
    </div>

    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-lg-6 col-md-8">
                <div class="card">
                    <div class="card-header text-center">
                        <h4 class="mb-0">
                            <i class="fas fa-user-search me-2"></i>User Lookup
                        </h4>
                    </div>
                    <div class="card-body">
                        <%-- Check for error message --%>
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <%= request.getAttribute("error") %>
                                <a href="<%= request.getContextPath() %>/register?user_type=customer&redirectTo=<%= request.getContextPath() %>/staff/user-lookup.jsp" class="alert-link ms-2">
                                    Register as new user <i class="fas fa-arrow-right"></i>
                                </a>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <% } %>

                        <form action="<%= request.getContextPath() %>/check-user-bill" method="GET" class="needs-validation" novalidate>
                            <div class="form-group mb-4">
                                <label for="searchTerm" class="form-label">
                                    <i class="fas fa-envelope me-1"></i> Email or Phone Number
                                </label>
                                <div class="input-group">
                                    <input type="text"
                                           class="form-control form-control-lg"
                                           id="searchTerm"
                                           name="searchTerm"
                                           placeholder="Enter email or phone number"
                                           value="<%= request.getParameter("searchTerm") != null ? request.getParameter("searchTerm") : "" %>"
                                           required>
                                    <span class="search-icon">
                                        <i class="fas fa-search"></i>
                                    </span>
                                    <div class="invalid-feedback">
                                        Please enter a valid email or phone number
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid gap-3 mt-4">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-search me-2"></i> Search User
                                </button>
                                <a href="<%= request.getContextPath() %>/staff" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
                                </a>
                            </div>
                        </form>

                        <div class="text-center mt-4">
                            <p class="mb-0">
                                New user?
                                <a href="<%= request.getContextPath() %>/register?user_type=customer&redirectTo=<%= request.getContextPath() %>/staff/user-lookup.jsp" class="fw-bold">
                                    Register here <i class="fas fa-arrow-right"></i>
                                </a>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4 text-muted small">
                    <p class="mb-0">
                        <i class="fas fa-info-circle me-1"></i>
                        Search for users by entering their email address or phone number
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="<%= request.getContextPath() %>/staff/assets/js/user-lookup.js"></script>

    <script>
        // Form validation
        (function () {
            'use strict'

            // Fetch the form to apply custom Bootstrap validation styles to
            var form = document.querySelector('.needs-validation')

            // Prevent submission if form is invalid
            if (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }

                    form.classList.add('was-validated')
                }, false)
            }
        })()
    </script>
</body>
</html>
