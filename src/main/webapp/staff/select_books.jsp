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
                request.setAttribute("messageType", "error");
            } else {
                cart.put(bookId, inCart + quantity);
                session.setAttribute("cart", cart);
                request.setAttribute("message", "Added " + quantity + " x '" + _book.getName() + "' to cart.");
                request.setAttribute("messageType", "success");
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

    // Get cart size for the badge
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    int cartSize = cart != null ? cart.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Books - Pahana Edu</title>

    <!-- Favicon -->
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/select_books.css">

    <style>
        /* Inline styles for critical content only */
        .fade-in {
            animation: fadeIn 0.3s ease-out forwards;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-out {
            animation: fadeOut 0.3s ease-out forwards;
        }

        @keyframes fadeOut {
            from { opacity: 1; }
            to { opacity: 0; }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <h1><i class="fas fa-book-open"></i> Select Books</h1>
        </header>

        <!-- Alert Messages -->
        <% if (request.getAttribute("message") != null) {
            String messageType = (String) request.getAttribute("messageType") != null ?
                (String) request.getAttribute("messageType") : "info";
        %>
            <div class="alert-message alert-<%= messageType %> fade-in">
                <%= request.getAttribute("message") %>
                <button class="close-alert" aria-label="Close">&times;</button>
            </div>
        <% } %>

        <!-- Search Bar -->
        <div class="search-container">
            <form method="get" action="" class="search-form">
                <div class="search-box">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text"
                           name="searchTerm"
                           class="search-input"
                           placeholder="Search by ID or book name..."
                           value="<%= searchTerm != null ? searchTerm : "" %>"
                           aria-label="Search books">
                    <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
                        <a href="select_books.jsp" class="clear-search" title="Clear search">
                            <i class="fas fa-times"></i>
                        </a>
                    <% } %>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Search
                </button>
            </form>
        </div>

        <!-- Books Table -->
        <div class="table-container">
            <% if (bookList != null && !bookList.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Book</th>
                            <th>Details</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Quantity</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (BookModel book : bookList) {
                            int available = book.getQty();
                            boolean isOutOfStock = available <= 0;
                        %>
                            <tr data-book-id="<%= book.getId() %>" data-available="<%= available %>">
                                <td class="book-info">

                                    <div class="book-meta">
                                        <h3><%= book.getName() %></h3>
                                        <p class="text-muted">ID: <%= book.getId() %></p>
                                    </div>
                                </td>
                                <td class="book-description">
                                    <p><%= book.getDescription() %></p>
                                </td>
                                <td class="book-price">
                                    <span class="price">Rs. <%= String.format("%.2f", book.getPrice()) %></span>
                                </td>
                                <td class="book-status">
                                    <% if (isOutOfStock) { %>
                                        <span class="status-badge status-out-of-stock">Out of Stock</span>
                                    <% } else { %>
                                        <span class="status-badge status-available">In Stock</span>
                                        <p class="stock-available"><%= available %> available</p>
                                    <% } %>
                                </td>
                                <td class="book-quantity">
                                    <input type="number"
                                           class="quantity-input"
                                           name="quantity"
                                           min="1"
                                           max="<%= available %>"
                                           value="1"
                                           <%= isOutOfStock ? "disabled" : "" %>>
                                </td>
                                <td class="book-actions">
                                    <form method="post" action="" class="add-to-cart-form">
                                        <input type="hidden" name="bookId" value="<%= book.getId() %>">
                                        <input type="hidden" name="quantity" value="1" class="quantity-field">
                                        <button type="submit"
                                                name="addToCart"
                                                class="btn btn-primary add-to-cart"
                                                <%= isOutOfStock ? "disabled" : "" %>
                                                data-tooltip="<%= isOutOfStock ? "Out of stock" : "Add to cart" %>">
                                            <i class="fas fa-cart-plus"></i> Add to Cart
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="no-books">
                    <i class="fas fa-book-open fa-3x"></i>
                    <h3>No books found</h3>
                    <p>No books match your search criteria. Try a different search term.</p>
                    <a href="select_books.jsp" class="btn btn-outline">
                        <i class="fas fa-undo"></i> Clear Search
                    </a>
                </div>
            <% } %>
        </div>

        <!-- Cart Summary -->
        <div class="cart-summary">
            <div class="cart-info">
                <div class="cart-count"><%= cartSize %></div>
                <div>
                    <h3>Your Shopping Cart</h3>
                    <p class="text-muted"><%= cartSize == 0 ? "Your cart is empty" : (cartSize + (cartSize > 1 ? " items" : " item") + " in cart") %></p>
                </div>
            </div>
            <div class="cart-actions">
                <% if (cartSize > 0) { %>
                    <a href="view_cart.jsp" class="btn btn-outline">
                        <i class="fas fa-shopping-cart"></i> View Cart
                    </a>
                    <a href="<%= request.getContextPath() %>/checkout?customerId=<%= request.getParameter("customerId") %>"
                       class="btn btn-primary">
                        <i class="fas fa-credit-card"></i> Proceed to Checkout
                    </a>
                <% } else { %>
                    <p class="text-muted mb-0">Add items to your cart to continue</p>
                <% } %>
            </div>
        </div>
    </div>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/select_books.js"></script>

    <script>
        // Close alert button
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.close-alert').forEach(button => {
                button.addEventListener('click', function() {
                    this.closest('.alert-message').remove();
                });
            });

            // Auto-hide success messages after 5 seconds
            const successAlert = document.querySelector('.alert-success');
            if (successAlert) {
                setTimeout(() => {
                    successAlert.classList.add('fade-out');
                    setTimeout(() => successAlert.remove(), 300);
                }, 5000);
            }
        });
    </script>
</body>
</html>