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

    for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
        int bookId = entry.getKey();
        int quantity = entry.getValue();
        BookModel book = bookDAO.getBookById(bookId);
        if (book != null) {
            bookDetails.put(bookId, book);
            total += book.getPrice() * quantity;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            margin-top: 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
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
        .action-button {
            background-color: #2196F3;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin: 2px;
        }
        .action-button.update {
            background-color: #4CAF50;
        }
        .action-button.remove {
            background-color: #f44336;
        }
        .action-button:hover {
            opacity: 0.9;
        }
        .cart-summary {
            margin-top: 30px;
            padding: 20px;
            background-color: #e9f7ef;
            border-radius: 5px;
            text-align: right;
        }
        .total-amount {
            font-size: 1.5em;
            font-weight: bold;
            color: #2c3e50;
        }
        .empty-cart {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .continue-shopping {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .continue-shopping:hover {
            background-color: #5a6268;
        }
        .checkout-btn {
            display: inline-block;
            margin-left: 10px;
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        .checkout-btn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Your Shopping Cart</h1>

    <% if (cart.isEmpty()) { %>
    <div class="empty-cart">
        <h2>Your cart is empty</h2>
        <p>Looks like you haven't added any items to your cart yet.</p>
        <a href="select_books.jsp" class="continue-shopping">Continue Shopping</a>
    </div>
    <% } else { %>
    <form method="post" action="view_cart.jsp">
        <table>
            <thead>
            <tr>
                <th>Book</th>
                <th>Title</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int bookId = entry.getKey();
                int quantity = entry.getValue();
                BookModel book = bookDetails.get(bookId);
                if (book != null) {
                    double itemTotal = book.getPrice() * quantity;
            %>
            <tr>
                <td>
                    <img src="${pageContext.request.contextPath}/uploads/<%= book.getPhoto() %>"
                         alt="<%= book.getName() %>"
                         width="50"
                         style="border-radius: 4px;">
                </td>
                <td><%= book.getName() %></td>
                <td>Rs. <%= String.format("%.2f", book.getPrice()) %></td>
                <td>
                    <input type="hidden" name="bookId" value="<%= bookId %>">
                    <input type="number"
                           name="quantity"
                           class="quantity-input"
                           min="1"
                           max="<%= book.getQty() %>"
                           value="<%= quantity %>">
                </td>
                <td>Rs. <%= String.format("%.2f", itemTotal) %></td>
                <td>
                    <button type="submit"
                            name="removeFromCart"
                            value="<%= bookId %>"
                            class="action-button remove"
                            onclick="return confirm('Are you sure you want to remove this item?')">
                        Remove
                    </button>
                </td>
            </tr>
            <% }
            } %>
            </tbody>
        </table>

        <div class="cart-summary">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <a href="select_books.jsp" class="continue-shopping">Continue Shopping</a>
                <div>
                    <span style="margin-right: 20px;">Total: <span class="total-amount">Rs. <%= String.format("%.2f", total) %></span></span>
                    <button type="submit" name="updateCart" class="action-button update">Update Cart</button>
                    <a href="<%= request.getContextPath() %>/checkout" class="checkout-btn">Proceed to Checkout</a>
                </div>
            </div>
        </div>
    </form>
    <% } %>
</div>

<script>
    // Add confirmation before removing item
    document.querySelectorAll('button[name="removeFromCart"]').forEach(button => {
        button.addEventListener('click', function(e) {
            if (!confirm('Are you sure you want to remove this item from your cart?')) {
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>