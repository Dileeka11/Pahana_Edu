<%@ page import="java.util.List" %>
<%@ page import="src.persistance.book.dao.BookDAO" %>
<%@ page import="src.business.book.model.BookModel" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%
    // Initialize cart in session if it doesn't exist
    if (session.getAttribute("cart") == null) {
        session.setAttribute("cart", new HashMap<Integer, Integer>());
    }

    // Handle add to cart action (with stock validation against current DB and cart)
    if (request.getParameter("addToCart") != null) {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        BookDAO _bookDAO = new BookDAO();
        BookModel _book = _bookDAO.getBookById(bookId);
        if (_book != null) {
            int inCart = cart.getOrDefault(bookId, 0);
            int available = _book.getQty() - inCart;
            if (available <= 0 || quantity > available) {
                request.setAttribute("message", "Insufficient stock for '" + _book.getName() + "'. Requested " + quantity + ", available " + Math.max(available, 0) + ".");
            } else {
                cart.put(bookId, inCart + quantity);
                session.setAttribute("cart", cart);
                request.setAttribute("message", "Added " + quantity + " x '" + _book.getName() + "' to cart.");
            }
        }
    }

    // Get search parameter
    String searchTerm = request.getParameter("searchTerm");

    // Get books based on search criteria
    BookDAO bookDAO = new BookDAO();
    List<BookModel> bookList = bookDAO.getAllBooks();

    // Apply filter if search term exists
    if (searchTerm != null && !searchTerm.isEmpty()) {
        try {
            // Try to parse as ID first
            int searchId = Integer.parseInt(searchTerm);
            bookList.removeIf(book -> book.getId() != searchId);
        } catch (NumberFormatException e) {
            // If not a number, search by name
            String searchLower = searchTerm.toLowerCase();
            bookList.removeIf(book -> !book.getName().toLowerCase().contains(searchLower));
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Select Books</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .search-container {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .search-container input[type="text"] {
            padding: 10px;
            margin-right: 10px;
            width: 300px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .search-container button {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .search-container button:hover {
            background-color: #45a049;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e9e9e9;
        }
        .quantity-input {
            width: 60px;
            padding: 6px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .add-to-cart {
            background-color: #2196F3;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .add-to-cart:hover {
            background-color: #0b7dda;
        }
        .cart-summary {
            margin-top: 30px;
            padding: 20px;
            background-color: #e9f7ef;
            border-radius: 5px;
        }
        .cart-summary h3 {
            margin-top: 0;
            color: #2c3e50;
        }
        .cart-summary a {
            color: #2196F3;
            text-decoration: none;
            font-weight: bold;
            margin-right: 15px;
        }
        .cart-summary a:hover {
            text-decoration: underline;
        }
        .clear-search {
            margin-left: 10px;
            color: #666;
            text-decoration: none;
        }
        .clear-search:hover {
            text-decoration: underline;
        }
        .alert {
            margin: 10px 0 0;
            padding: 10px 14px;
            border-radius: 4px;
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }
        .muted { color: #888; font-size: 12px; }
        .disabled { opacity: 0.6; pointer-events: none; }
    </style>
</head>
<body>
<div class="container">
    <h1>Available Books</h1>

    <% if (request.getAttribute("message") != null) { %>
        <div class="alert"><%= request.getAttribute("message") %></div>
    <% } %>

    <!-- Search Form -->
    <div class="search-container">
        <form method="get" action="">
            <input type="text"
                   name="searchTerm"
                   placeholder="Search by ID or Book Name"
                   value="<%= searchTerm != null ? searchTerm : "" %>"
                   aria-label="Search books">
            <button type="submit">Search</button>
            <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
            <a href="select_books.jsp" class="clear-search">Clear Search</a>
            <% } %>
        </form>
    </div>

    <!-- Books Table -->
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Description</th>
            <th>Price (Rs.)</th>
            <th>Available</th>
            <th>Quantity</th>
            <th>Action</th>
            <th>Photo</th>
        </tr>
        </thead>
        <tbody>
        <% if (bookList != null && !bookList.isEmpty()) {
            for (BookModel book : bookList) {
        %>
        <tr data-book-id="<%= book.getId() %>" data-available="<%= book.getQty() %>">
            <td><%= book.getId() %></td>
            <td><%= book.getName() %></td>
            <td><%= book.getDescription() %></td>
            <td><%= String.format("%.2f", book.getPrice()) %></td>
            <td>
                <%= book.getQty() %>
                <% if (book.getQty() <= 0) { %>
                    <div class="muted">Out of stock</div>
                <% } %>
            </td>
            <td>
                <input type="number"
                       class="quantity-input"
                       name="quantity"
                       min="1"
                       max="<%= book.getQty() %>"
                       value="1" <%= book.getQty() <= 0 ? "disabled" : "" %>>
            </td>
            <td>
                <form method="post" action="" style="margin: 0;" class="add-to-cart-form">
                    <input type="hidden" name="bookId" value="<%= book.getId() %>">
                    <input type="hidden" name="quantity" value="1" class="quantity-field">
                    <button type="submit" name="addToCart" class="add-to-cart" <%= book.getQty() <= 0 ? "disabled" : "" %>>Add to Cart</button>
                </form>
            </td>
            <td>
                <img src="${pageContext.request.contextPath}/uploads/<%= book.getPhoto() %>"
                     alt="<%= book.getName() %>"
                     width="50"
                     style="border-radius: 4px;">
            </td>
        </tr>
        <% }
        } else {
        %>
        <tr>
            <td colspan="8" style="text-align: center; padding: 20px;">
                No books found matching your criteria.
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <!-- Cart Summary -->
    <div class="cart-summary">
        <h3>Your Cart</h3>
        <%
            @SuppressWarnings("unchecked")
            Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
            if (cart != null && !cart.isEmpty()) {
        %>
        <p>You have <%= cart.size() %> item(s) in your cart.</p>
        <a href="view_cart.jsp">View Cart</a>
        <a href="<%= request.getContextPath() %>/checkout?customerId=<%= request.getParameter("customerId") %>">Proceed to Checkout</a>
        <%
        } else {
        %>
        <p>Your cart is empty.</p>
        <%
            }
        %>
    </div>
</div>

<script>
    // Update and clamp the visible quantity input and sync hidden field
    document.querySelectorAll('.quantity-input').forEach(input => {
        input.addEventListener('change', function() {
            const max = parseInt(this.getAttribute('max')) || 1;
            let val = parseInt(this.value) || 1;
            if (val < 1) val = 1;
            if (val > max) val = max;
            this.value = val;
            const form = this.closest('tr').querySelector('form.add-to-cart-form');
            if (form) form.querySelector('.quantity-field').value = this.value;
        });
    });

    // Validate quantity against available stock on submit
    document.querySelectorAll('form.add-to-cart-form').forEach(form => {
        form.addEventListener('submit', function(e) {
            const row = this.closest('tr');
            const available = parseInt(row.dataset.available || '0');
            const qtyInput = row.querySelector('.quantity-input');
            const hidden = row.querySelector('.quantity-field');
            const qty = parseInt(qtyInput ? qtyInput.value : hidden.value) || 1;
            if (qty < 1 || qty > available) {
                e.preventDefault();
                alert('Insufficient stock. Requested ' + qty + ', available ' + available + '.');
            } else {
                // ensure hidden field matches
                hidden.value = qty;
            }
        });
    });
</script>
</body>
</html>