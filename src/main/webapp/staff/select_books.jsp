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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookStore - Select Books</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-blue: #3498db;
            --light-blue: #e3f2fd;
            --medium-blue: #90caf9;
            --dark-blue: #1976d2;
            --accent-blue: #2196f3;
            --success-green: #4caf50;
            --warning-orange: #ff9800;
            --error-red: #f44336;
            --text-dark: #2c3e50;
            --text-light: #546e7a;
            --bg-light: #f8fafc;
            --white: #ffffff;
            --shadow-light: 0 2px 10px rgba(52, 152, 219, 0.1);
            --shadow-medium: 0 4px 20px rgba(52, 152, 219, 0.15);
            --border-radius: 12px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--light-blue) 0%, var(--bg-light) 100%);
            color: var(--text-dark);
            line-height: 1.6;
            min-height: 100vh;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            text-align: center;
            margin-bottom: 3rem;
            padding: 2rem 0;
        }

        .header h1 {
            font-size: 3rem;
            font-weight: 700;
            color: var(--dark-blue);
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(52, 152, 219, 0.1);
        }

        .header p {
            font-size: 1.2rem;
            color: var(--text-light);
            font-weight: 300;
        }

        .alert {
            margin-bottom: 2rem;
            padding: 1rem 1.5rem;
            border-radius: var(--border-radius);
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 1px solid var(--warning-orange);
            color: #856404;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            box-shadow: var(--shadow-light);
            animation: slideIn 0.3s ease-out;
        }

        .alert.success {
            background: linear-gradient(135deg, #d4edda 0%, #a8e6cf 100%);
            border-color: var(--success-green);
            color: #155724;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .search-section {
            background: var(--white);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-medium);
            margin-bottom: 2rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(52, 152, 219, 0.1);
        }

        .search-form {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .search-input-wrapper {
            position: relative;
            flex: 1;
            min-width: 300px;
        }

        .search-input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid var(--light-blue);
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: var(--transition);
            background: var(--bg-light);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background: var(--white);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            font-size: 1.1rem;
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: var(--border-radius);
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-align: center;
            white-space: nowrap;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--accent-blue) 100%);
            color: var(--white);
            box-shadow: var(--shadow-light);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
            background: linear-gradient(135deg, var(--dark-blue) 0%, var(--primary-blue) 100%);
        }

        .btn-secondary {
            background: var(--white);
            color: var(--primary-blue);
            border: 2px solid var(--primary-blue);
        }

        .btn-secondary:hover {
            background: var(--primary-blue);
            color: var(--white);
            transform: translateY(-2px);
        }

        .btn-small {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }

        .clear-search {
            color: var(--text-light);
            text-decoration: none;
            font-size: 0.875rem;
            transition: var(--transition);
        }

        .clear-search:hover {
            color: var(--primary-blue);
            text-decoration: underline;
        }

        .books-section {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-medium);
            overflow: hidden;
            border: 1px solid rgba(52, 152, 219, 0.1);
        }

        .table-wrapper {
            overflow-x: auto;
        }

        .books-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--white);
        }

        .books-table thead {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--dark-blue) 100%);
        }

        .books-table th {
            padding: 1.5rem 1rem;
            color: var(--white);
            font-weight: 600;
            text-align: left;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .books-table td {
            padding: 1.25rem 1rem;
            border-bottom: 1px solid rgba(52, 152, 219, 0.1);
            vertical-align: middle;
        }

        .books-table tbody tr {
            transition: var(--transition);
        }

        .books-table tbody tr:hover {
            background: var(--light-blue);
            transform: scale(1.01);
        }

        .book-id {
            font-weight: 600;
            color: var(--primary-blue);
            font-family: monospace;
        }

        .book-name {
            font-weight: 600;
            color: var(--text-dark);
            max-width: 200px;
        }

        .book-description {
            color: var(--text-light);
            font-size: 0.875rem;
            max-width: 250px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .book-price {
            font-weight: 700;
            color: var(--success-green);
            font-size: 1.1rem;
        }

        .stock-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .stock-count {
            font-weight: 600;
            color: var(--text-dark);
        }

        .stock-status {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            text-align: center;
            font-weight: 500;
        }

        .stock-available {
            background: rgba(76, 175, 80, 0.1);
            color: var(--success-green);
        }

        .stock-low {
            background: rgba(255, 152, 0, 0.1);
            color: var(--warning-orange);
        }

        .stock-out {
            background: rgba(244, 67, 54, 0.1);
            color: var(--error-red);
        }

        .quantity-wrapper {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .quantity-input {
            width: 70px;
            padding: 0.5rem;
            border: 2px solid var(--light-blue);
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            transition: var(--transition);
        }

        .quantity-input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .quantity-input:disabled {
            background: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }

        .add-to-cart-form {
            margin: 0;
        }

        .add-to-cart {
            background: linear-gradient(135deg, var(--success-green) 0%, #45a049 100%);
            color: var(--white);
        }

        .add-to-cart:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .add-to-cart:disabled {
            background: #cccccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-light);
        }

        .empty-state i {
            font-size: 4rem;
            color: var(--medium-blue);
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
        }

        .cart-summary {
            margin-top: 3rem;
            background: linear-gradient(135deg, var(--light-blue) 0%, rgba(144, 202, 249, 0.3) 100%);
            padding: 2rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-medium);
            border: 1px solid rgba(52, 152, 219, 0.2);
        }

        .cart-summary h3 {
            color: var(--dark-blue);
            font-size: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .cart-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }

        .cart-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-dark);
            font-weight: 500;
        }

        .disabled-row {
            opacity: 0.6;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .header h1 {
                font-size: 2rem;
            }

            .search-form {
                flex-direction: column;
                align-items: stretch;
            }

            .search-input-wrapper {
                min-width: auto;
            }

            .cart-actions {
                flex-direction: column;
            }

            .btn {
                justify-content: center;
            }

            .books-table {
                font-size: 0.875rem;
            }

            .books-table th,
            .books-table td {
                padding: 0.75rem 0.5rem;
            }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<%@ include file="/staff/includes/navbar.jsp" %>
<div class="container">
    <div class="header fade-in">
        <h1><i class="fas fa-book-open"></i> BookStore</h1>
        <p>Discover your next favorite read</p>
    </div>

    <% if (request.getAttribute("message") != null) { %>
    <div class="alert <%= request.getAttribute("message").toString().contains("Added") ? "success" : "" %>">
        <i class="fas fa-<%= request.getAttribute("message").toString().contains("Added") ? "check-circle" : "exclamation-triangle" %>"></i>
        <%= request.getAttribute("message") %>
    </div>
    <% } %>

    <div class="search-section fade-in">
        <form method="get" action="" class="search-form">
            <div class="search-input-wrapper">
                <i class="fas fa-search search-icon"></i>
                <input type="text"
                       name="searchTerm"
                       class="search-input"
                       placeholder="Search by ID or Book Name"
                       value="<%= searchTerm != null ? searchTerm : "" %>"
                       aria-label="Search books">
            </div>
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-search"></i>
                Search
            </button>
            <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
            <a href="select_books.jsp" class="btn btn-secondary btn-small">
                <i class="fas fa-times"></i>
                Clear
            </a>
            <% } %>
        </form>
    </div>

    <div class="books-section fade-in">
        <div class="table-wrapper">
            <table class="books-table">
                <thead>
                <tr>
                    <th><i class="fas fa-hashtag"></i> ID</th>
                    <th><i class="fas fa-book"></i> Name</th>
                    <th><i class="fas fa-align-left"></i> Description</th>
                    <th><i class="fas fa-tag"></i> Price (Rs.)</th>
                    <th><i class="fas fa-boxes"></i> Available</th>
                    <th><i class="fas fa-sort-numeric-up"></i> Quantity</th>
                    <th><i class="fas fa-shopping-cart"></i> Action</th>
                </tr>
                </thead>
                <tbody>
                <% if (bookList != null && !bookList.isEmpty()) {
                    for (BookModel book : bookList) {
                        boolean isOutOfStock = book.getQty() <= 0;
                        boolean isLowStock = book.getQty() > 0 && book.getQty() <= 5;
                %>
                <tr data-book-id="<%= book.getId() %>" data-available="<%= book.getQty() %>" class="<%= isOutOfStock ? "disabled-row" : "" %>">
                    <td><span class="book-id">#<%= book.getId() %></span></td>
                    <td><div class="book-name"><%= book.getName() %></div></td>
                    <td><div class="book-description" title="<%= book.getDescription() %>"><%= book.getDescription() %></div></td>
                    <td><span class="book-price">Rs. <%= String.format("%.2f", book.getPrice()) %></span></td>
                    <td>
                        <div class="stock-info">
                            <span class="stock-count"><%= book.getQty() %></span>
                            <% if (isOutOfStock) { %>
                            <span class="stock-status stock-out">Out of Stock</span>
                            <% } else if (isLowStock) { %>
                            <span class="stock-status stock-low">Low Stock</span>
                            <% } else { %>
                            <span class="stock-status stock-available">In Stock</span>
                            <% } %>
                        </div>
                    </td>
                    <td>
                        <div class="quantity-wrapper">
                            <input type="number"
                                   class="quantity-input"
                                   name="quantity"
                                   min="1"
                                   max="<%= book.getQty() %>"
                                   value="1"
                                <%= isOutOfStock ? "disabled" : "" %>>
                        </div>
                    </td>
                    <td>
                        <form method="post" action="" class="add-to-cart-form">
                            <input type="hidden" name="bookId" value="<%= book.getId() %>">
                            <input type="hidden" name="quantity" value="1" class="quantity-field">
                            <button type="submit"
                                    name="addToCart"
                                    class="btn btn-small add-to-cart"
                                    <%= isOutOfStock ? "disabled" : "" %>>
                                <i class="fas fa-cart-plus"></i>
                                Add to Cart
                            </button>
                        </form>
                    </td>
                </tr>
                <% }
                } else {
                %>
                <tr>
                    <td colspan="7">
                        <div class="empty-state">
                            <i class="fas fa-search"></i>
                            <h3>No books found</h3>
                            <p>Try adjusting your search criteria</p>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="cart-summary fade-in">
        <h3><i class="fas fa-shopping-cart"></i> Your Cart</h3>
        <%
            @SuppressWarnings("unchecked")
            Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
            if (cart != null && !cart.isEmpty()) {
        %>
        <div class="cart-info">
            <i class="fas fa-info-circle"></i>
            You have <strong><%= cart.size() %></strong> item(s) in your cart
        </div>
        <div class="cart-actions">
            <a href="view_cart.jsp" class="btn btn-primary">
                <i class="fas fa-eye"></i>
                View Cart
            </a>
            <a href="<%= request.getContextPath() %>/checkout?customerId=<%= request.getParameter("customerId") %>" class="btn btn-secondary">
                <i class="fas fa-credit-card"></i>
                Proceed to Checkout
            </a>
        </div>
        <%
        } else {
        %>
        <div class="cart-info">
            <i class="fas fa-shopping-cart"></i>
            Your cart is empty
        </div>
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

        input.addEventListener('input', function() {
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

    // Add loading animation to buttons
    document.querySelectorAll('.btn').forEach(btn => {
        btn.addEventListener('click', function() {
            if (this.type === 'submit') {
                this.style.opacity = '0.7';
                setTimeout(() => {
                    this.style.opacity = '1';
                }, 1000);
            }
        });
    });

    // Add fade-in animation on page load
    window.addEventListener('load', function() {
        document.querySelectorAll('.fade-in').forEach((el, index) => {
            el.style.animationDelay = `${index * 0.1}s`;
        });
    });
</script>
</body>
</html>