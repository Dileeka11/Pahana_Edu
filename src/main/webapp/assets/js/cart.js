/**
 * Cart Page Interactivity
 * Handles cart item interactions, quantity updates, and form submission
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize cart functionality
    initCart();
    
    // Update cart totals on page load
    updateCartTotals();
});

/**
 * Initialize cart event listeners and functionality
 */
function initCart() {
    // Quantity controls
    document.addEventListener('click', function(e) {
        // Handle plus button click
        if (e.target.closest('.quantity-btn.plus')) {
            const input = e.target.closest('.quantity-btn').previousElementSibling.previousElementSibling;
            input.stepUp();
            updateItem(input);
        }
        
        // Handle minus button click
        if (e.target.closest('.quantity-btn.minus')) {
            const input = e.target.closest('.quantity-btn').nextElementSibling;
            if (input.value > 1) {
                input.stepDown();
                updateItem(input);
            }
        }
        
        // Handle remove button click
        if (e.target.closest('.btn-remove')) {
            const button = e.target.closest('.btn-remove');
            const cartItem = button.closest('.cart-item');
            const bookId = cartItem.dataset.bookId;
            removeItem(bookId);
        }
    });
    
    // Quantity input validation
    document.addEventListener('change', function(e) {
        if (e.target.classList.contains('quantity-input')) {
            validateQuantityInput(e.target);
            updateItem(e.target);
        }
    });
    
    // Prevent non-numeric input
    document.addEventListener('keydown', function(e) {
        if (e.target.classList.contains('quantity-input')) {
            preventNonNumericInput(e);
        }
    });
    
    // Handle form submission
    const cartForm = document.getElementById('cart-form');
    if (cartForm) {
        cartForm.addEventListener('submit', handleFormSubmit);
    }
}

/**
 * Update cart item when quantity changes
 * @param {HTMLElement} input - The quantity input element
 */
function updateItem(input) {
    const cartItem = input.closest('.cart-item');
    const price = parseFloat(cartItem.querySelector('.item-price').textContent.replace('$', ''));
    const quantity = parseInt(input.value);
    const total = price * quantity;
    
    // Update item total
    const totalElement = cartItem.querySelector('.item-total .total-amount');
    totalElement.textContent = total.toFixed(2);
    
    // Update cart totals
    updateCartTotals();
    
    // Add visual feedback
    cartItem.classList.add('updating');
    setTimeout(() => cartItem.classList.remove('updating'), 300);
}

/**
 * Remove item from cart
 * @param {number} bookId - The ID of the book to remove
 */
function removeItem(bookId) {
    if (!confirm('Are you sure you want to remove this item from your cart?')) {
        return;
    }
    
    const cartItem = document.querySelector(`.cart-item[data-book-id="${bookId}"]`);
    if (!cartItem) return;
    
    // Add removal animation
    cartItem.style.animation = 'fadeOut 0.3s ease-out forwards';
    
    // Remove from DOM after animation
    setTimeout(() => {
        cartItem.remove();
        
        // Update cart totals
        updateCartTotals();
        
        // Show empty cart message if cart is empty
        if (document.querySelectorAll('.cart-item').length === 0) {
            showEmptyCartMessage();
        }
    }, 300);
    
    // Submit form to update server-side cart
    const form = document.createElement('form');
    form.method = 'post';
    form.action = 'view_cart.jsp';
    
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'removeFromCart';
    input.value = 'true';
    form.appendChild(input);
    
    const bookInput = document.createElement('input');
    bookInput.type = 'hidden';
    bookInput.name = 'bookId';
    bookInput.value = bookId;
    form.appendChild(bookInput);
    
    document.body.appendChild(form);
    form.submit();
}

/**
 * Update cart totals based on current items
 */
function updateCartTotals() {
    let subtotal = 0;
    let totalItems = 0;
    
    document.querySelectorAll('.cart-item').forEach(item => {
        const price = parseFloat(item.querySelector('.item-price').textContent.replace('$', ''));
        const quantity = parseInt(item.querySelector('.quantity-input').value);
        subtotal += price * quantity;
        totalItems += quantity;
    });
    
    // Update item count in header
    const itemCountElement = document.querySelector('.item-count');
    if (itemCountElement) {
        itemCountElement.textContent = `${totalItems} ${totalItems === 1 ? 'item' : 'items'} in your cart`;
    }
    
    // Update subtotal and total
    const subtotalElements = document.querySelectorAll('.summary-row:not(.total) .summary-amount');
    subtotalElements.forEach(el => {
        el.textContent = subtotal.toFixed(2);
    });
    
    // Update total
    const totalElements = document.querySelectorAll('.summary-row.total .summary-amount');
    totalElements.forEach(el => {
        el.textContent = subtotal.toFixed(2);
    });
}

/**
 * Validate quantity input
 * @param {HTMLElement} input - The quantity input element
 */
function validateQuantityInput(input) {
    const value = parseInt(input.value);
    const min = parseInt(input.min) || 1;
    const max = parseInt(input.max) || 9999;
    
    if (isNaN(value) || value < min) {
        input.value = min;
    } else if (value > max) {
        input.value = max;
    }
}

/**
 * Prevent non-numeric input in quantity fields
 * @param {Event} e - The keydown event
 */
function preventNonNumericInput(e) {
    // Allow: backspace, delete, tab, escape, enter, decimal point
    if ([46, 8, 9, 27, 13, 110, 190].includes(e.keyCode) ||
        // Allow: Ctrl+A, Command+A
        (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) ||
        // Allow: home, end, left, right, down, up
        (e.keyCode >= 35 && e.keyCode <= 40)) {
        return;
    }
    
    // Ensure that it is a number and stop the keypress
    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
        e.preventDefault();
    }
}

/**
 * Show empty cart message
 */
function showEmptyCartMessage() {
    const cartContainer = document.querySelector('.cart-container');
    if (!cartContainer) return;
    
    const emptyCartHTML = `
        <div class="empty-cart">
            <div class="empty-cart-content">
                <i class="fas fa-shopping-cart"></i>
                <h2>Your cart is empty</h2>
                <p>Looks like you haven't added any books to your cart yet.</p>
                <a href="books.jsp" class="btn btn-primary">Continue Shopping</a>
            </div>
        </div>
    `;
    
    // Fade out cart items
    const cartItems = document.querySelector('.cart-items');
    if (cartItems) {
        cartItems.style.opacity = '0';
        cartItems.style.transition = 'opacity 0.3s ease';
    }
    
    // Remove cart form and show empty message
    setTimeout(() => {
        const cartForm = document.getElementById('cart-form');
        if (cartForm) {
            cartForm.remove();
        }
        
        cartContainer.insertAdjacentHTML('beforeend', emptyCartHTML);
    }, 300);
}

/**
 * Handle form submission
 * @param {Event} e - The form submission event
 */
function handleFormSubmit(e) {
    // Client-side validation can be added here if needed
    // The form will be submitted to the server for processing
    
    // Show loading state
    const submitButton = e.target.querySelector('button[type="submit"]');
    if (submitButton) {
        const originalText = submitButton.innerHTML;
        submitButton.disabled = true;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
        
        // Revert button state after a short delay
        setTimeout(() => {
            submitButton.disabled = false;
            submitButton.innerHTML = originalText;
        }, 2000);
    }
}

// Add fadeOut animation for removing items
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeOut {
        from { opacity: 1; transform: translateY(0); max-height: 200px; margin-bottom: 1.5rem; }
        to { opacity: 0; transform: translateY(-20px); max-height: 0; margin-bottom: 0; padding-top: 0; padding-bottom: 0; border: none; }
    }
    
    .cart-item.updating {
        background-color: rgba(52, 152, 219, 0.05);
        transition: background-color 0.3s ease;
    }
`;
document.head.appendChild(style);
