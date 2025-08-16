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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookStore - Your Cart</title>
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
            --shadow-strong: 0 8px 32px rgba(52, 152, 219, 0.2);
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .header {
            text-align: center;
            margin-bottom: 3rem;
            padding: 2rem 0;
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark-blue);
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(52, 152, 219, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .header p {
            font-size: 1.1rem;
            color: var(--text-light);
            font-weight: 300;
        }

        .breadcrumb {
            background: var(--white);
            padding: 1rem 1.5rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-light);
            margin-bottom: 2rem;
            border: 1px solid rgba(52, 152, 219, 0.1);
        }

        .breadcrumb a {
            color: var(--primary-blue);
            text-decoration: none;
            transition: var(--transition);
        }

        .breadcrumb a:hover {
            color: var(--dark-blue);
            text-decoration: underline;
        }

        .breadcrumb .current {
            color: var(--text-dark);
            font-weight: 600;
        }

        .cart-container {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-medium);
            overflow: hidden;
            border: 1px solid rgba(52, 152, 219, 0.1);
        }

        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
            background: linear-gradient(135deg, var(--white) 0%, var(--light-blue) 100%);
        }

        .empty-cart-icon {
            font-size: 5rem;
            color: var(--medium-blue);
            margin-bottom: 2rem;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }

        .empty-cart h2 {
            font-size: 2rem;
            color: var(--text-dark);
            margin-bottom: 1rem;
        }

        .empty-cart p {
            font-size: 1.1rem;
            color: var(--text-light);
            margin-bottom: 2rem;
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
            box-shadow: var(--shadow-light);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--accent-blue) 100%);
            color: var(--white);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
            background: linear-gradient(135deg, var(--dark-blue) 0%, var(--primary-blue) 100%);
        }

        .btn-success {
            background: linear-gradient(135deg, var(--success-green) 0%, #45a049 100%);
            color: var(--white);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--error-red) 0%, #d32f2f 100%);
            color: var(--white);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .btn-secondary {
            background: var(--white);
            color: var(--text-dark);
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

        .cart-table-wrapper {
            overflow-x: auto;
        }

        .cart-table {
            width: 100%;
            border-collapse: collapse;
        }

        .cart-table thead {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--dark-blue) 100%);
        }

        .cart-table th {
            padding: 1.5rem 1rem;
            color: var(--white);
            font-weight: 600;
            text-align: left;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .cart-table td {
            padding: 1.5rem 1rem;
            border-bottom: 1px solid rgba(52, 152, 219, 0.1);
            vertical-align: middle;
        }

        .cart-table tbody tr {
            transition: var(--transition);
            background: var(--white);
        }

        .cart-table tbody tr:nth-child(even) {
            background: rgba(52, 152, 219, 0.02);
        }

        .cart-table tbody tr:hover {
            background: var(--light-blue);
            transform: scale(1.01);
            box-shadow: var(--shadow-light);
        }

        .book-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .book-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--medium-blue) 0%, var(--primary-blue) 100%);
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--white);
            font-size: 1.5rem;
            flex-shrink: 0;
        }

        .book-details h4 {
            font-size: 1.1rem;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
            font-weight: 600;
        }

        .book-details p {
            font-size: 0.875rem;
            color: var(--text-light);
        }

        .price-display {
            font-weight: 700;
            color: var(--success-green);
            font-size: 1.1rem;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--bg-light);
            border-radius: var(--border-radius);
            padding: 0.25rem;
            width: fit-content;
        }

        .quantity-btn {
            width: 32px;
            height: 32px;
            border: none;
            background: var(--primary-blue);
            color: var(--white);
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
            font-size: 0.875rem;
        }

        .quantity-btn:hover {
            background: var(--dark-blue);
            transform: scale(1.1);
        }

        .quantity-input {
            width: 60px;
            padding: 0.5rem;
            border: 2px solid var(--light-blue);
            border-radius: 6px;
            text-align: center;
            font-weight: 600;
            background: var(--white);
            transition: var(--transition);
        }

        .quantity-input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .total-price {
            font-weight: 700;
            color: var(--dark-blue);
            font-size: 1.2rem;
        }

        .cart-summary {
            background: linear-gradient(135deg, var(--light-blue) 0%, rgba(144, 202, 249, 0.3) 100%);
            padding: 2rem;
            border-top: 1px solid rgba(52, 152, 219, 0.1);
        }

        .summary-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1.5rem;
        }

        .total-section {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .grand-total {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--dark-blue);
            padding: 1rem 2rem;
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-light);
            border: 2px solid rgba(52, 152, 219, 0.2);
        }

        .actions-section {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .remove-btn {
            background: linear-gradient(135deg, var(--error-red) 0%, #d32f2f 100%);
            color: var(--white);
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.875rem;
            font-weight: 500;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .remove-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .slide-in {
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .header h1 {
                font-size: 2rem;
                flex-direction: column;
                gap: 0.5rem;
            }

            .cart-table th,
            .cart-table td {
                padding: 0.75rem 0.5rem;
                font-size: 0.875rem;
            }

            .book-info {
                flex-direction: column;
                text-align: center;
                gap: 0.5rem;
            }

            .book-icon {
                width: 50px;
                height: 50px;
                font-size: 1.25rem;
            }

            .summary-content {
                flex-direction: column;
                text-align: center;
            }

            .total-section {
                flex-direction: column;
                gap: 1rem;
            }

            .actions-section {
                justify-content: center;
                width: 100%;
            }

            .btn {
                flex: 1;
                justify-content: center;
            }
        }

        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .success-message {
            background: linear-gradient(135deg, #d4edda 0%, #a8e6cf 100%);
            color: #155724;
            padding: 1rem 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            border: 1px solid #c3e6cb;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: slideIn 0.3s ease-out;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header fade-in">
        <h1>
            <i class="fas fa-shopping-cart"></i>
            Your Shopping Cart
        </h1>
        <p>Review and manage your selected items</p>
    </div>

    <div class="breadcrumb slide-in">
        <nav>
            <a href="select_books.jsp"><i class="fas fa-book"></i> Books</a>
            <span> / </span>
            <span class="current"><i class="fas fa-shopping-cart"></i> Cart</span>
        </nav>
    </div>

    <div class="cart-container fade-in">
        <% if (cart.isEmpty()) { %>
        <div class="empty-cart">
            <div class="empty-cart-icon">
                <i class="fas fa-shopping-cart"></i>
            </div>
            <h2>Your cart is empty</h2>
            <p>Looks like you haven't added any items to your cart yet.</p>
            <a href="select_books.jsp" class="btn btn-primary">
                <i class="fas fa-book"></i>
                Continue Shopping
            </a>
        </div>
        <% } else { %>
        <form method="post" action="view_cart.jsp" id="cartForm">
            <div class="cart-table-wrapper">
                <table class="cart-table">
                    <thead>
                    <tr>
                        <th><i class="fas fa-book"></i> Book</th>
                        <th><i class="fas fa-tag"></i> Price</th>
                        <th><i class="fas fa-sort-numeric-up"></i> Quantity</th>
                        <th><i class="fas fa-calculator"></i> Total</th>
                        <th><i class="fas fa-cogs"></i> Actions</th>
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
                    <tr class="cart-item" data-book-id="<%= bookId %>">
                        <td>
                            <div class="book-info">
                                <div class="book-icon">
                                    <i class="fas fa-book"></i>
                                </div>
                                <div class="book-details">
                                    <h4><%= book.getName() %></h4>
                                    <p>Available: <%= book.getQty() %> items</p>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="price-display">Rs. <%= String.format("%.2f", book.getPrice()) %></span>
                        </td>
                        <td>
                            <div class="quantity-controls">
                                <button type="button" class="quantity-btn" onclick="updateQuantity(<%= bookId %>, -1)">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <input type="number"
                                       name="quantity"
                                       class="quantity-input"
                                       min="1"
                                       max="<%= book.getQty() %>"
                                       value="<%= quantity %>"
                                       data-book-id="<%= bookId %>"
                                       onchange="updateItemTotal(<%= bookId %>, <%= book.getPrice() %>)">
                                <button type="button" class="quantity-btn" onclick="updateQuantity(<%= bookId %>, 1)">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                            <input type="hidden" name="bookId" value="<%= bookId %>">
                        </td>
                        <td>
                                    <span class="total-price" id="total-<%= bookId %>">
                                        Rs. <%= String.format("%.2f", itemTotal) %>
                                    </span>
                        </td>
                        <td>
                            <button type="button"
                                    class="remove-btn"
                                    onclick="removeItem(<%= bookId %>, '<%= book.getName() %>')">
                                <i class="fas fa-trash"></i>
                                Remove
                            </button>
                        </td>
                    </tr>
                    <% }
                    } %>
                    </tbody>
                </table>
            </div>

            <div class="cart-summary">
                <div class="summary-content">
                    <a href="select_books.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Continue Shopping
                    </a>

                    <div class="total-section">
                        <div class="grand-total pulse">
                            Total: <span id="grandTotal">Rs. <%= String.format("%.2f", total) %></span>
                        </div>

                        <div class="actions-section">

                            <a href="<%= request.getContextPath() %>/checkout" class="btn btn-success">
                                <i class="fas fa-credit-card"></i>
                                Proceed to Checkout
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <% } %>
    </div>
</div>

<script>
    // Global variables
    let cartData = {};

    // Initialize cart data
    <% for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
        int bookId = entry.getKey();
        int quantity = entry.getValue();
        BookModel book = bookDetails.get(bookId);
        if (book != null) { %>
    cartData[<%= bookId %>] = {
        price: <%= book.getPrice() %>,
        maxQty: <%= book.getQty() %>,
        name: '<%= book.getName() %>'
    };
    <% } } %>

    // Update quantity function
    function updateQuantity(bookId, change) {
        const input = document.querySelector(`input[data-book-id="${bookId}"]`);
        const currentValue = parseInt(input.value);
        const newValue = currentValue + change;
        const maxQty = cartData[bookId].maxQty;

        if (newValue >= 1 && newValue <= maxQty) {
            input.value = newValue;
            updateItemTotal(bookId, cartData[bookId].price);

            // Add visual feedback
            input.style.transform = 'scale(1.1)';
            setTimeout(() => {
                input.style.transform = 'scale(1)';
            }, 200);
        }
    }

    // Update item total
    function updateItemTotal(bookId, price) {
        const quantityInput = document.querySelector(`input[data-book-id="${bookId}"]`);
        const quantity = parseInt(quantityInput.value);
        const totalElement = document.getElementById(`total-${bookId}`);
        const itemTotal = price * quantity;

        totalElement.textContent = `Rs. ${itemTotal.toFixed(2)}`;
        updateGrandTotal();

        // Add animation to total
        totalElement.style.color = '#4caf50';
        setTimeout(() => {
            totalElement.style.color = '#1976d2';
        }, 500);

        // Trigger change event to ensure form knows about the update
        quantityInput.dispatchEvent(new Event('change', { bubbles: true }));
    }

    // Update grand total
    function updateGrandTotal() {
        let grandTotal = 0;
        document.querySelectorAll('.quantity-input').forEach(input => {
            const bookId = input.getAttribute('data-book-id');
            const quantity = parseInt(input.value);
            const price = cartData[bookId].price;
            grandTotal += price * quantity;
        });

        const grandTotalElement = document.getElementById('grandTotal');
        grandTotalElement.textContent = `Rs. ${grandTotal.toFixed(2)}`;

        // Add pulse animation
        grandTotalElement.parentElement.classList.add('pulse');
        setTimeout(() => {
            grandTotalElement.parentElement.classList.remove('pulse');
        }, 1000);
    }

    // Remove item function
    function removeItem(bookId, bookName) {
        if (confirm(`Are you sure you want to remove "${bookName}" from your cart?`)) {
            const form = document.createElement('form');
            form.method = 'post';
            form.action = 'view_cart.jsp';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'removeFromCart';
            input.value = bookId;

            const bookIdInput = document.createElement('input');
            bookIdInput.type = 'hidden';
            bookIdInput.name = 'bookId';
            bookIdInput.value = bookId;

            form.appendChild(input);
            form.appendChild(bookIdInput);
            document.body.appendChild(form);

            // Add loading state
            const row = document.querySelector(`tr[data-book-id="${bookId}"]`);
            row.style.opacity = '0.5';
            row.style.transform = 'scale(0.95)';

            setTimeout(() => {
                form.submit();
            }, 300);
        }
    }

    // Add loading state to form submission and debug
    document.getElementById('cartForm')?.addEventListener('submit', function(e) {
        console.log('Form submitting...');

        // Debug: Log all form data
        const formData = new FormData(this);
        for (let [key, value] of formData.entries()) {
            console.log(key + ': ' + value);
        }

        const submitBtn = this.querySelector('button[name="updateCart"]');
        if (submitBtn) {
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            submitBtn.disabled = true;
            this.classList.add('loading');
        }
    });

    // Add input validation and ensure form submission works correctly
    document.querySelectorAll('.quantity-input').forEach(input => {
        input.addEventListener('input', function() {
            const bookId = this.getAttribute('data-book-id');
            const maxQty = cartData[bookId].maxQty;
            let value = parseInt(this.value);

            if (isNaN(value) || value < 1) {
                this.value = 1;
            } else if (value > maxQty) {
                this.value = maxQty;
                // Show warning
                this.style.borderColor = '#ff9800';
                setTimeout(() => {
                    this.style.borderColor = '#3498db';
                }, 2000);
            }

            updateItemTotal(bookId, cartData[bookId].price);
        });

        input.addEventListener('change', function() {
            const bookId = this.getAttribute('data-book-id');
            if (this.value === '' || parseInt(this.value) < 1) {
                this.value = 1;
                updateItemTotal(bookId, cartData[bookId].price);
            }
        });

        input.addEventListener('blur', function() {
            if (this.value === '' || parseInt(this.value) < 1) {
                this.value = 1;
                const bookId = this.getAttribute('data-book-id');
                updateItemTotal(bookId, cartData[bookId].price);
            }
        });
    });

    // Add fade-in animation on page load
    window.addEventListener('load', function() {
        document.querySelectorAll('.fade-in').forEach((el, index) => {
            el.style.animationDelay = `${index * 0.1}s`;
        });

        document.querySelectorAll('.slide-in').forEach((el, index) => {
            el.style.animationDelay = `${(index + 1) * 0.1}s`;
        });
    });

    // Add smooth scroll to top when cart updates
    function scrollToTop() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    }

    // Keyboard navigation
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && e.target.classList.contains('quantity-input')) {
            e.preventDefault();
            const bookId = e.target.getAttribute('data-book-id');
            updateItemTotal(bookId, cartData[bookId].price);
        }
    });
</script>
</body>
</html>