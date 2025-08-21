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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookStore - Checkout</title>
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

        .checkout-container {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-medium);
            overflow: hidden;
            border: 1px solid rgba(52, 152, 219, 0.1);
        }

        .checkout-header {
            background: linear-gradient(135deg, var(--success-green) 0%, #45a049 100%);
            color: var(--white);
            padding: 2rem;
            text-align: center;
        }

        .checkout-header h2 {
            font-size: 1.8rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
        }

        .checkout-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0;
            min-height: 600px;
        }

        .customer-section {
            padding: 2rem;
            background: var(--white);
            border-right: 1px solid rgba(52, 152, 219, 0.1);
        }

        .order-section {
            padding: 2rem;
            background: linear-gradient(135deg, var(--light-blue) 0%, rgba(227, 242, 253, 0.5) 100%);
        }

        .section-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--dark-blue);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--light-blue);
        }

        .customer-info {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .info-row {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            background: rgba(52, 152, 219, 0.03);
            border-radius: 8px;
            border-left: 4px solid var(--primary-blue);
            transition: var(--transition);
        }

        .info-row:hover {
            background: rgba(52, 152, 219, 0.08);
            transform: translateX(5px);
        }

        .info-label {
            font-weight: 600;
            color: var(--text-dark);
            min-width: 140px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-value {
            color: var(--text-light);
            flex: 1;
            font-weight: 500;
        }

        .order-table-wrapper {
            background: var(--white);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-light);
            margin-bottom: 1.5rem;
        }

        .order-table {
            width: 100%;
            border-collapse: collapse;
        }

        .order-table thead {
            background: linear-gradient(135deg, var(--primary-blue) 0%, var(--dark-blue) 100%);
        }

        .order-table th {
            padding: 1rem;
            color: var(--white);
            font-weight: 600;
            text-align: left;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .order-table td {
            padding: 1rem;
            border-bottom: 1px solid rgba(52, 152, 219, 0.1);
            vertical-align: middle;
        }

        .order-table tbody tr {
            transition: var(--transition);
        }

        .order-table tbody tr:hover {
            background: var(--light-blue);
        }

        .book-name {
            font-weight: 600;
            color: var(--text-dark);
        }

        .quantity-badge {
            background: var(--primary-blue);
            color: var(--white);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.875rem;
            text-align: center;
            min-width: 40px;
            display: inline-block;
        }

        .price-cell {
            font-weight: 600;
            color: var(--success-green);
        }

        .total-row {
            background: linear-gradient(135deg, var(--success-green) 0%, #45a049 100%);
            color: var(--white);
            font-weight: 700;
            font-size: 1.1rem;
        }

        .total-row td {
            border: none;
            padding: 1.25rem 1rem;
        }

        .empty-cart {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--text-light);
        }

        .empty-cart i {
            font-size: 4rem;
            color: var(--medium-blue);
            margin-bottom: 1rem;
        }

        .empty-cart h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--text-dark);
        }

        .payment-section {
            background: var(--white);
            padding: 2rem;
            border-top: 1px solid rgba(52, 152, 219, 0.1);
        }

        .payment-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .payment-field {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .payment-field label {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .payment-field input {
            padding: 1rem;
            border: 2px solid var(--light-blue);
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            transition: var(--transition);
            background: var(--bg-light);
        }

        .payment-field input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background: var(--white);
        }

        .payment-field input[readonly] {
            background: rgba(52, 152, 219, 0.05);
            color: var(--text-dark);
            cursor: not-allowed;
        }

        .payment-field.highlight input {
            border-color: var(--success-green);
            background: rgba(76, 175, 80, 0.05);
        }

        .payment-field.warning input {
            border-color: var(--warning-orange);
            background: rgba(255, 152, 0, 0.05);
        }

        .actions-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1.5rem;
            flex-wrap: wrap;
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
            gap: 0.75rem;
            text-align: center;
            white-space: nowrap;
            box-shadow: var(--shadow-light);
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

        .btn-primary {
            background: linear-gradient(135deg, var(--success-green) 0%, #45a049 100%);
            color: var(--white);
            font-size: 1.1rem;
            padding: 1.25rem 2.5rem;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .btn-primary:disabled {
            background: #cccccc;
            cursor: not-allowed;
            transform: none;
        }

        .alert {
            margin: 2rem;
            padding: 1rem 1.5rem;
            border-radius: var(--border-radius);
            background: linear-gradient(135deg, #e7f3fe 0%, #cce7ff 100%);
            border: 1px solid var(--primary-blue);
            color: var(--dark-blue);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: slideIn 0.3s ease-out;
        }

        .calculation-display {
            background: linear-gradient(135deg, var(--light-blue) 0%, rgba(144, 202, 249, 0.3) 100%);
            padding: 1.5rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            border: 1px solid rgba(52, 152, 219, 0.2);
        }

        .calc-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid rgba(52, 152, 219, 0.1);
        }

        .calc-row:last-child {
            border-bottom: none;
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--dark-blue);
        }

        .calc-label {
            color: var(--text-dark);
            font-weight: 600;
        }

        .calc-value {
            color: var(--success-green);
            font-weight: 600;
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @media (max-width: 968px) {
            .checkout-content {
                grid-template-columns: 1fr;
            }

            .customer-section {
                border-right: none;
                border-bottom: 1px solid rgba(52, 152, 219, 0.1);
            }

            .payment-grid {
                grid-template-columns: 1fr;
            }

            .actions-section {
                flex-direction: column;
                text-align: center;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
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

            .checkout-content {
                min-height: auto;
            }

            .customer-section,
            .order-section {
                padding: 1.5rem;
            }

            .payment-section {
                padding: 1.5rem;
            }

            .order-table th,
            .order-table td {
                padding: 0.75rem 0.5rem;
                font-size: 0.875rem;
            }

            .info-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.25rem;
            }

            .info-label {
                min-width: auto;
            }
        }
    </style>
</head>
<body>
<%@ include file="/staff/includes/navbar.jsp" %>
<div class="container">
    <div class="header fade-in">
        <h1>
            <i class="fas fa-credit-card"></i>
            Checkout
        </h1>
        <p>Complete your purchase securely</p>
    </div>

    <div class="checkout-container fade-in">
        <div class="checkout-header">
            <h2>
                <i class="fas fa-shopping-bag"></i>
                Order Confirmation
            </h2>
        </div>

        <div class="checkout-content">
            <div class="customer-section">
                <h3 class="section-title">
                    <i class="fas fa-user"></i>
                    Customer Details
                </h3>
                <div class="customer-info">
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-id-card"></i>
                            Customer ID:
                        </div>
                        <div class="info-value"><%= user.getId() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-user"></i>
                            Name:
                        </div>
                        <div class="info-value"><%= user.getName() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-envelope"></i>
                            Email:
                        </div>
                        <div class="info-value"><%= user.getEmail() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-phone"></i>
                            Phone:
                        </div>
                        <div class="info-value"><%= user.getTelephone() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-map-marker-alt"></i>
                            Address:
                        </div>
                        <div class="info-value"><%= user.getAddress() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-user-tag"></i>
                            User Type:
                        </div>
                        <div class="info-value"><%= user.getUser_type() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-credit-card"></i>
                            Account No:
                        </div>
                        <div class="info-value"><%= user.getAccount_number() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-chart-line"></i>
                            Units Used:
                        </div>
                        <div class="info-value"><%= user.getUnitsConsumed() %></div>
                    </div>
                </div>
            </div>

            <div class="order-section">
                <h3 class="section-title">
                    <i class="fas fa-receipt"></i>
                    Order Summary
                </h3>

                <% if (cart.isEmpty()) { %>
                <div class="empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Your cart is empty</h3>
                    <p>Please add items before checkout.</p>
                </div>
                <% } else { %>
                <div class="order-table-wrapper">
                    <table class="order-table">
                        <thead>
                        <tr>
                            <th><i class="fas fa-book"></i> Book</th>
                            <th><i class="fas fa-sort-numeric-up"></i> Qty</th>
                            <th><i class="fas fa-tag"></i> Price (Rs.)</th>
                            <th><i class="fas fa-calculator"></i> Total (Rs.)</th>
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
                            <td><span class="book-name"><%= b.getName() %></span></td>
                            <td><span class="quantity-badge"><%= qty %></span></td>
                            <td><span class="price-cell"><%= String.format("%.2f", b.getPrice()) %></span></td>
                            <td><span class="price-cell"><%= String.format("%.2f", line) %></span></td>
                        </tr>
                        <% } } %>
                        <tr class="total-row">
                            <td colspan="3"><strong>Grand Total</strong></td>
                            <td><strong>Rs. <span id="totalSpan"><%= String.format("%.2f", total) %></span></strong></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
        </div>

        <div class="payment-section">
            <h3 class="section-title">
                <i class="fas fa-money-bill-wave"></i>
                Payment Details
            </h3>

            <div class="calculation-display" id="calculationDisplay">
                <div class="calc-row">
                    <span class="calc-label">Subtotal:</span>
                    <span class="calc-value">Rs. <span id="subtotalDisplay"><%= String.format("%.2f", total) %></span></span>
                </div>
                <div class="calc-row">
                    <span class="calc-label">Discount:</span>
                    <span class="calc-value">- Rs. <span id="discountDisplay">0.00</span></span>
                </div>
                <div class="calc-row">
                    <span class="calc-label">Net Amount:</span>
                    <span class="calc-value">Rs. <span id="netDisplay"><%= String.format("%.2f", total) %></span></span>
                </div>
            </div>

            <form method="post"
                  action="<%= request.getContextPath() %>/checkout"
                  target="_blank"
                  id="checkoutForm"
                  onsubmit="setTimeout(function(){ window.location.href = '<%= request.getContextPath() %>/checkout?customerId=<%= user.getId() %>'; }, 300);">

                <div class="payment-grid">
                    <div class="payment-field">
                        <label for="discount">
                            <i class="fas fa-percentage"></i>
                            Discount (Rs.)
                        </label>
                        <input type="number"
                               id="discount"
                               name="discount"
                               value="0"
                               min="0"
                               step="0.01"
                               oninput="recalc()"
                               placeholder="Enter discount amount">
                    </div>
                    <div class="payment-field">
                        <label for="paid">
                            <i class="fas fa-money-bill"></i>
                            Paid (Rs.)
                        </label>
                        <input type="number"
                               id="paid"
                               name="paid"
                               value="0"
                               min="0"
                               step="0.01"
                               oninput="recalc()"
                               placeholder="Enter paid amount">
                    </div>
                    <div class="payment-field" id="balanceField">
                        <label for="balance">
                            <i class="fas fa-balance-scale"></i>
                            Balance Due (Rs.)
                        </label>
                        <input type="number"
                               id="balance"
                               name="balance_display"
                               value="0"
                               readonly>
                    </div>
                    <div class="payment-field" id="changeField">
                        <label for="change">
                            <i class="fas fa-hand-holding-usd"></i>
                            Change (Rs.)
                        </label>
                        <input type="number"
                               id="change"
                               name="change_display"
                               value="0"
                               readonly>
                    </div>
                </div>

                <input type="hidden" name="customerId" value="<%= user.getId() %>">

                <div class="actions-section">
                    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/staff/select_books.jsp?customerId=<%= user.getId() %>">
                        <i class="fas fa-arrow-left"></i>
                        Back to Books
                    </a>
                    <button type="submit" class="btn btn-primary" id="printBillBtn">
                        <i class="fas fa-print"></i>
                        Print Bill & Complete Order
                    </button>
                </div>
            </form>
        </div>

        <% if (request.getAttribute("message") != null) { %>
        <div class="alert">
            <i class="fas fa-info-circle"></i>
            <%= request.getAttribute("message") %>
        </div>
        <% } %>
    </div>
</div>

<script>
    const total = parseFloat('<%= String.format("%.2f", total) %>');

    function recalc() {
        const d = parseFloat(document.getElementById('discount').value || '0');
        const p = parseFloat(document.getElementById('paid').value || '0');
        const net = Math.max(0, total - d);
        let balance = Math.max(0, net - p);
        let change = Math.max(0, p - net);

        // Update display values
        document.getElementById('discountDisplay').textContent = d.toFixed(2);
        document.getElementById('netDisplay').textContent = net.toFixed(2);
        document.getElementById('balance').value = balance.toFixed(2);
        document.getElementById('change').value = change.toFixed(2);

        // Update field styling based on values
        const balanceField = document.getElementById('balanceField');
        const changeField = document.getElementById('changeField');
        const printBtn = document.getElementById('printBillBtn');

        // Reset classes
        balanceField.classList.remove('warning', 'highlight');
        changeField.classList.remove('warning', 'highlight');

        if (balance > 0) {
            balanceField.classList.add('warning');
            printBtn.disabled = true;
            printBtn.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Payment Required';
        } else {
            balanceField.classList.add('highlight');
            printBtn.disabled = false;
            printBtn.innerHTML = '<i class="fas fa-print"></i> Print Bill & Complete Order';
        }

        if (change > 0) {
            changeField.classList.add('highlight');
        }

        // Add animation to calculation display
        const calcDisplay = document.getElementById('calculationDisplay');
        calcDisplay.style.transform = 'scale(1.02)';
        setTimeout(() => {
            calcDisplay.style.transform = 'scale(1)';
        }, 200);
    }

    // Initialize calculations
    recalc();

    // Add loading state to form submission
    document.getElementById('checkoutForm').addEventListener('submit', function() {
        const submitBtn = document.getElementById('printBillBtn');
        if (!submitBtn.disabled) {
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            submitBtn.disabled = true;
        }
    });

    // Add fade-in animation on page load
    window.addEventListener('load', function() {
        document.querySelectorAll('.fade-in').forEach((el, index) => {
            el.style.animationDelay = `${index * 0.1}s`;
        });
    });

    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && (e.target.id === 'discount' || e.target.id === 'paid')) {
            e.preventDefault();
            recalc();
        }
    });

    // Auto-focus on discount field
    setTimeout(() => {
        document.getElementById('discount').focus();
    }, 500);
</script>
</body>
</html>