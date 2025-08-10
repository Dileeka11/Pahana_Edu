<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="src.business.user.dto.Userdto" %>
<%
    List<Userdto> users = (List<Userdto>) request.getAttribute("users");
    String q = request.getParameter("q");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Users - Pahana Edu</title>

    <!-- Icons & Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <!-- App Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/manage_users.css" />
</head>
<body>
<% request.setAttribute("activePage", "manage-users"); %>
<%@ include file="/staff/includes/navbar.jsp" %>

<main class="sp-container">
    <header class="sp-header">
        <div>
            <h1 class="sp-title">Manage Users</h1>
            <p class="sp-subtitle">View, edit, and remove user accounts</p>
        </div>
        <form class="sp-toolbar" method="get" action="${pageContext.request.contextPath}/manage-users">
            <div class="sp-input-wrap">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input class="sp-input" type="search" name="q" placeholder="Search by name, account, email..." value="<%= q != null ? q : "" %>" />
            </div>
            <button class="sp-btn sp-btn--outline" type="submit">Search</button>
            <a class="sp-btn sp-btn--primary" href="${pageContext.request.contextPath}/register?user_type=customer&redirectTo=${pageContext.request.contextPath}/manage-users">
                <i class="fa-solid fa-user-plus"></i> New User
            </a>
        </form>
    </header>

    <section class="sp-table-wrapper">
        <table class="sp-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Account</th>
                <th>Name</th>
                <th>Address</th>
                <th>Telephone</th>
                <th>Email</th>
                <th>Units</th>
                <th class="sp-col-actions">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (users != null && !users.isEmpty()) {
                    for (Userdto user : users) {
                        String formId = "f-" + user.getId();
            %>
            <tr>
                <td><%= user.getId() %></td>
                <td><%= user.getAccount_number() %></td>
                <td>
                    <input class="sp-input sp-input--sm" type="text" name="name" value="<%= user.getName() %>" form="<%= formId %>" />
                </td>
                <td>
                    <input class="sp-input sp-input--sm" type="text" name="address" value="<%= user.getAddress() %>" form="<%= formId %>" />
                </td>
                <td>
                    <input class="sp-input sp-input--sm" type="text" name="telephone" value="<%= user.getTelephone() %>" form="<%= formId %>" />
                </td>
                <td>
                    <input class="sp-input sp-input--sm" type="email" name="email" value="<%= user.getEmail() %>" form="<%= formId %>" />
                </td>
                <td class="units-cell"><span class="sp-badge"><%= user.getUnitsConsumed() %></span></td>
                <td class="sp-actions">
                    <form id="<%= formId %>" action="${pageContext.request.contextPath}/manage-users" method="post" class="sp-row-form">
                        <input type="hidden" name="id" value="<%= user.getId() %>">
                        <input type="hidden" name="user_type" value="<%= user.getUser_type() %>">
                        <button class="sp-btn sp-btn--outline" type="submit" name="action" value="update">
                            <i class="fa-solid fa-floppy-disk"></i>
                            Update
                        </button>
                        <button class="sp-btn sp-btn--danger" type="submit" name="action" value="delete" onclick="return confirm('Delete this user?')">
                            <i class="fa-solid fa-trash"></i>
                            Delete
                        </button>
                    </form>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="8" class="sp-empty">
                    <i class="fa-regular fa-face-frown"></i> No users found.
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </section>
</main>

<footer class="sp-footer">
    <p>© <span id="sp-year"></span> Pahana Edu. All rights reserved.</p>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/manage_users.js"></script>
</body>
</html>