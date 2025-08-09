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
    <title>Checkout</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f6fa; margin: 0; padding: 20px; }
        .container { max-width: 1100px; margin: auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); overflow: hidden; }
        .header { background: #4CAF50; color: #fff; padding: 16px 24px; }
        .content { padding: 24px; display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .card { border: 1px solid #eee; border-radius: 6px; padding: 16px; }
        .card h3 { margin: 0 0 12px; color: #2c3e50; }
        .row { display: flex; margin-bottom: 8px; }
        .row label { width: 140px; color: #666; }
        .row span { flex: 1; color: #222; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #eee; text-align: left; }
        th { background: #f8f9fa; }
        .total { text-align: right; font-weight: bold; margin-top: 10px; }
        .actions { padding: 16px 24px; background: #f8f9fa; display: flex; justify-content: space-between; align-items: center; gap: 16px; }
        .btn { padding: 10px 18px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .btn-secondary { background: #6c757d; color: #fff; text-decoration: none; }
        .btn-primary { background: #28a745; color: #fff; }
        .alert { padding: 12px 16px; border-radius: 4px; margin-bottom: 12px; }
        .alert-info { background: #e7f3fe; color: #084298; border: 1px solid #b6d4fe; }
        .empty { color: #777; }
        .field { display: inline-flex; flex-direction: column; gap: 6px; }
        .field label { font-size: 12px; color: #555; }
        .field input { padding: 8px; width: 140px; border: 1px solid #ccc; border-radius: 4px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2 style="margin:0;">Checkout</h2>
    </div>

    <div class="content">
        <div class="card">
            <h3>Customer Details</h3>
            <div class="row"><label>Customer ID:</label><span><%= user.getId() %></span></div>
            <div class="row"><label>Name:</label><span><%= user.getName() %></span></div>
            <div class="row"><label>Email:</label><span><%= user.getEmail() %></span></div>
            <div class="row"><label>Phone:</label><span><%= user.getTelephone() %></span></div>
            <div class="row"><label>Address:</label><span><%= user.getAddress() %></span></div>
            <div class="row"><label>User Type:</label><span><%= user.getUser_type() %></span></div>
            <div class="row"><label>Account No:</label><span><%= user.getAccount_number() %></span></div>
            <div class="row"><label>Units Used:</label><span><%= user.getUnitsConsumed() %></span></div>
        </div>

        <div class="card">
            <h3>Order Summary</h3>
            <% if (cart.isEmpty()) { %>
            <p class="empty">Your cart is empty. Please add items before checkout.</p>
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
                    <td><%= b.getName() %></td>
                    <td><%= qty %></td>
                    <td><%= String.format("%.2f", b.getPrice()) %></td>
                    <td><%= String.format("%.2f", line) %></td>
                </tr>
                <% } } %>
                </tbody>
            </table>
            <div class="total">Total: Rs. <span id="totalSpan"><%= String.format("%.2f", total) %></span></div>
            <% } %>
        </div>
    </div>

    <div class="actions">
        <a class="btn btn-secondary" href="<%= request.getContextPath() %>/staff/select_books.jsp?customerId=<%= user.getId() %>">Back to Books</a>
        <form method="post"
              action="<%= request.getContextPath() %>/checkout"
              target="_blank"
              onsubmit="setTimeout(function(){ window.location.href = '<%= request.getContextPath() %>/checkout?customerId=<%= user.getId() %>'; }, 300);"
              style="margin:0; display: flex; align-items: end; gap: 12px;">
            <div class="field">
                <label for="discount">Discount (Rs.)</label>
                <input type="number" id="discount" name="discount" value="0" min="0" step="0.01" oninput="recalc()">
            </div>
            <div class="field">
                <label for="paid">Paid (Rs.)</label>
                <input type="number" id="paid" name="paid" value="0" min="0" step="0.01" oninput="recalc()">
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
            <button type="submit" class="btn btn-primary">Print Bill</button>
        </form>
    </div>

    <% if (request.getAttribute("message") != null) { %>
    <div style="padding: 0 24px 24px 24px;">
        <div class="alert alert-info"><%= request.getAttribute("message") %></div>
    </div>
    <% } %>
</div>

<script>
    const total = parseFloat('<%= String.format("%.2f", total) %>');
    function recalc() {
        const d = parseFloat(document.getElementById('discount').value || '0');
        const p = parseFloat(document.getElementById('paid').value || '0');
        const net = (total - d);
        let balance = net - p;           // amount due if positive
        let change = p - net;            // amount to return if positive
        if (isNaN(balance)) balance = 0;
        if (isNaN(change)) change = 0;
        document.getElementById('balance').value = Math.max(0, balance).toFixed(2);
        document.getElementById('change').value = Math.max(0, change).toFixed(2);
    }
    recalc();
</script>
</body>
</html>