<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="src.persistance.book.dao.BookDAO" %>
<%@ page import="src.business.book.model.BookModel" %>

<%
    // Handle remove from cart action
    if (request.getParameter("removeFromCart") != null) {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart != null) {
            cart.remove(bookId);
        }
    }

    // Handle update quantity action
    if (request.getParameter("updateCart") != null) {
        String[] bookIds = request.getParameterValues("bookId");
        String[] quantities = request.getParameterValues("quantity");

        if (bookIds != null && quantities != null) {
            @SuppressWarnings("unchecked")
            Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
            if (cart != null) {
                for (int i = 0; i < bookIds.length; i++) {
                    int bookId = Integer.parseInt(bookIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    if (quantity > 0) {
                        cart.put(bookId, quantity);
                    } else {
                        cart.remove(bookId);
                    }
                }
            }
        }
    }

    // Get cart from session
    @SuppressWarnings("unchecked")
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
        session.setAttribute("cart", cart);
    }

    // Get book details for items in cart
    BookDAO bookDAO = new BookDAO();
    Map<Integer, BookModel> bookDetails = new HashMap<>();
    double total = 0.0;
    int totalItems = 0;

    for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
        int bookId = entry.getKey();
        int quantity = entry.getValue();
        BookModel book = bookDAO.getBookById(bookId);
        if (book != null) {
            bookDetails.put(bookId, book);
            total += book.getPrice() * quantity;
            totalItems += quantity;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Shopping Cart | Pahana Edu</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/cart.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="cart-header">
            <h1>Your Shopping Cart</h1>
            <p><%= totalItems %> <%= totalItems == 1 ? "item" : "items" %> in your cart</p>
        </div>

        <% if (cart.isEmpty()) { %>
            <div class="empty-cart">
                <i class="fas fa-shopping-cart"></i>
                <h2>Your cart is empty</h2>
                <p>Looks like you haven't added any books to your cart yet.</p>
                <a href="books.jsp" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Continue Shopping
                </a>
            </div>
        <% } else { %>
            <div class="cart-layout">
                <form action="view_cart.jsp" method="post" id="cart-form" class="cart-items">
                    <input type="hidden" name="updateCart" value="true">

                    <% for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                        int bookId = entry.getKey();
                        int quantity = entry.getValue();
                        BookModel book = bookDetails.get(bookId);
                        if (book != null) {
                            double itemTotal = book.getPrice() * quantity;
                    %>
                        <div class="cart-item" data-book-id="<%= bookId %>">

                            <div class="item-details">
                                <h3 class="item-title"><%= book.getName() %></h3>
                                <p class="item-author">By <%= book.getDescription() %></p>
                                <p class="item-price">Rs. <%= String.format("%.2f", book.getPrice()) %></p>
                                <div class="item-actions">
                                    <button type="button" class="btn-remove" onclick="removeItem(<%= bookId %>)">
                                        <i class="fas fa-trash-alt"></i> Remove
                                    </button>
                                </div>
                            </div>
                            <div class="quantity-control">
                                <button type="button" class="quantity-btn minus" data-book-id="<%= bookId %>">-</button>
                                <input type="number"
                                       name="quantity"
                                       class="quantity-input"
                                       value="<%= quantity %>"
                                       min="1"
                                       data-book-id="<%= bookId %>">
                                <button type="button" class="quantity-btn plus" data-book-id="<%= bookId %>">+</button>
                            </div>
                            <input type="hidden" name="bookId" value="<%= bookId %>">
                        </div>
                    <% }
                    } %>
                </form>

                <div class="summary-card">
                    <h3>Order Summary</h3>
                    <div class="summary-row">
                        <span>Subtotal (<%= totalItems %> <%= totalItems == 1 ? "item" : "items" %>)</span>
                        <span>Rs. <%= String.format("%.2f", total) %></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span>Free</span>
                    </div>
                    <div class="summary-row total">
                        <span>Total</span>
                        <span>Rs. <%= String.format("%.2f", total) %></span>
                    </div>
                    <div class="summary-actions">
                        <button type="submit" form="cart-form" class="btn btn-primary">
                            <i class="fas fa-sync-alt"></i> Update Cart
                        </button>
                        <a href="checkout.jsp" class="btn btn-checkout">
                            Proceed to Checkout <i class="fas fa-arrow-right"></i>
                        </a>
                        <br/>
                        <a href="select_books.jsp" class="btn btn-outline">
                            <i class="fas fa-arrow-left"></i> Continue Shopping
                        </a>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <script src="<%= request.getContextPath() %>/assets/js/cart.js"></script>
</body>
</html>