<%@ page import="src.business.user.model.UserModel" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="src.business.book.model.BookModel" %>
<%
    // Get user from request (set by CheckoutServlet)
    UserModel user = (UserModel) request.getAttribute("user");
    if (user == null) {
        // Fallback: try from session
        user = (UserModel) session.getAttribute("currentUser");
    }

    if (user == null) {
        // No user context; redirect back to lookup
        response.sendRedirect(request.getContextPath() + "/staff/user-lookup.jsp");
        return;
    }

    // Prepare cart summary
    @SuppressWarnings("unchecked")
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
        session.setAttribute("cart", cart);
    }

    // Use pre-fetched data from servlet to avoid DB calls in JSP
    Map<Integer, BookModel> bookDetails = (Map<Integer, BookModel>) request.getAttribute("bookDetails");
    if (bookDetails == null) {
        bookDetails = new HashMap<>();
    }
    double total = 0.0;
    Object totalAttr = request.getAttribute("total");
    if (totalAttr instanceof Double) {
        total = (Double) totalAttr;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Pahana Edu</title>
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="${pageContext.request.contextPath}/assets/img/logo.png" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico" />

    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css" />
</head>
<body>
<% request.setAttribute("activePage", "checkout"); %>
<%@ include file="/staff/includes/navbar.jsp" %>

<div class="container">
    <div class="header">
        <h2><i class="fas fa-shopping-cart"></i> Checkout</h2>
    </div>

    <div class="content">
        <div class="card">
            <h3><i class="fas fa-user-circle"></i> Customer Details</h3>
            <div class="row">
                <label>Customer ID:</label>
                <span><%= user.getId() %></span>
            </div>
            <div class="row">
                <label>Name:</label>
                <span><%= user.getName() %></span>
            </div>
            <div class="row">
                <label>Email:</label>
                <span><%= user.getEmail() %></span>
            </div>
            <div class="row">
                <label>Phone:</label>
                <span><%= user.getTelephone() %></span>
            </div>
            <div class="row">
                <label>Address:</label>
                <span><%= user.getAddress() %></span>
            </div>
            <div class="row">
                <label>User Type:</label>
                <span><%= user.getUser_type() %></span>
            </div>
            <div class="row">
                <label>Account No:</label>
                <span><%= user.getAccount_number() %></span>
            </div>
            <div class="row">
                <label>Units Used:</label>
                <span><%= user.getUnitsConsumed() %></span>
            </div>
        </div>

        <div class="card">
            <h3><i class="fas fa-receipt"></i> Order Summary</h3>
            <% if (cart.isEmpty()) { %>
                <p class="empty"><i class="fas fa-shopping-cart"></i> Your cart is empty. Please add items before checkout.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Book</th>
                            <th>Qty</th>
                            <th>Price (Rs.)</th>
                            <th>Line Total (Rs.)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                            int bookId = entry.getKey();
                            int qty = entry.getValue();
                            BookModel b = bookDetails.get(bookId);
                            if (b != null) {
                                double line = b.getPrice() * qty;
                        %>
                        <tr>
                            <td><i class="fas fa-book"></i> <%= b.getName() %></td>
                            <td><%= qty %></td>
                            <td><%= String.format("%.2f", b.getPrice()) %></td>
                            <td><%= String.format("%.2f", line) %></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
                <div class="total">
                    Total: Rs. <span id="totalSpan"><%= String.format("%.2f", total) %></span>
                </div>
            <% } %>
        </div>
    </div>

    <div class="actions">
        <a href="<%= request.getContextPath() %>/staff/select_books.jsp?customerId=<%= user.getId() %>"
           class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Books
        </a>

        <% if (!cart.isEmpty()) { %>
        <form method="post"
              action="<%= request.getContextPath() %>/checkout"
              target="_blank"
              onsubmit="setTimeout(function(){ window.location.href = '<%= request.getContextPath() %>/checkout?customerId=<%= user.getId() %>'; }, 300);"
              class="checkout-form">
            <div class="field">
                <label for="discount">Discount (Rs.)</label>
                <input type="number" id="discount" name="discount" value="0" min="0" step="0.01"
                       placeholder="0.00" oninput="recalculateTotals()">
            </div>
            <div class="field">
                <label for="paid">Paid (Rs.)</label>
                <input type="number" id="paid" name="paid" value="0" min="0" step="0.01"
                       placeholder="0.00" oninput="recalculateTotals()">
            </div>
            <div class="field">
                <label for="balance">Balance (Rs.)</label>
                <input type="number" id="balance" name="balance_display" value="0" readonly>
            </div>
            <div class="field">
                <label for="change">Change (Rs.)</label>
                <input type="number" id="change" name="change_display" value="0" readonly>
            </div>
            <input type="hidden" name="customerId" value="<%= user.getId() %>">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-print"></i> Print Bill
            </button>
        </form>
        <% } %>
    </div>

    <% if (request.getAttribute("message") != null) { %>
    <div class="alert-container">
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> <%= request.getAttribute("message") %>
        </div>
    </div>
    <% } %>
</div>

<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Custom JavaScript -->
<script src="${pageContext.request.contextPath}/assets/js/checkout.js"></script>

</body>
</html>