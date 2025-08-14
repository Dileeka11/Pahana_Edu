/**
 * Select Books Page - Interactive Functionality
 * Handles quantity input, cart interactions, and form validations
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    initializeTooltips();

    // Initialize quantity inputs
    initializeQuantityInputs();

    // Initialize cart forms
    initializeCartForms();

    // Initialize search functionality
    initializeSearch();

    // Add animation to table rows
    animateTableRows();
});

/**
 * Initialize tooltips using the browser's built-in title attribute
 */
function initializeTooltips() {
    const tooltipElements = document.querySelectorAll('[data-tooltip]');

    tooltipElements.forEach(element => {
        element.setAttribute('title', element.getAttribute('data-tooltip'));
    });
}

/**
 * Initialize quantity input controls
 */
function initializeQuantityInputs() {
    document.querySelectorAll('.quantity-input').forEach(input => {
        // Handle input changes
        input.addEventListener('change', function() {
            const max = parseInt(this.getAttribute('max')) || 1;
            const min = parseInt(this.getAttribute('min')) || 1;
            let value = parseInt(this.value) || min;

            // Clamp the value between min and max
            value = Math.min(Math.max(value, min), max);

            // Update the value
            this.value = value;

            // Update the hidden field if it exists
            const form = this.closest('tr')?.querySelector('form.add-to-cart-form');
            if (form) {
                const hiddenInput = form.querySelector('.quantity-field');
                if (hiddenInput) {
                    hiddenInput.value = value;
                }
            }

            // Update button state
            updateAddToCartButton(this);
        });

        // Prevent invalid input
        input.addEventListener('keydown', function(e) {
            // Allow: backspace, delete, tab, escape, enter
            if ([46, 8, 9, 27, 13].includes(e.keyCode) ||
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
        });
    });
}

/**
 * Initialize cart form submissions
 */
function initializeCartForms() {
    document.querySelectorAll('form.add-to-cart-form').forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            const row = this.closest('tr');
            const bookId = row.dataset.bookId;
            const available = parseInt(row.dataset.available || '0');
            const qtyInput = row.querySelector('.quantity-input');
            const hiddenQty = row.querySelector('.quantity-field');
            const qty = parseInt(qtyInput ? qtyInput.value : (hiddenQty ? hiddenQty.value : '1')) || 1;

            // Validate quantity
            if (qty < 1 || qty > available) {
                showAlert(`Insufficient stock. Requested ${qty}, available ${available}.`, 'error');
                return false;
            }

            // Ensure hidden field has the correct value
            if (hiddenQty) {
                hiddenQty.value = qty;
            }

            // Submit the form
            this.submit();
        });
    });
}

/**
 * Initialize search functionality
 */
function initializeSearch() {
    const searchForm = document.querySelector('.search-form');
    if (!searchForm) return;

    const searchInput = searchForm.querySelector('input[type="text"]');
    const clearButton = searchForm.querySelector('.clear-search');

    // Focus search input on page load if it's empty
    if (searchInput && !searchInput.value.trim()) {
        searchInput.focus();
    }

    // Show/hide clear button based on input
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            if (clearButton) {
                clearButton.style.display = this.value.trim() ? 'inline-block' : 'none';
            }
        });
    }
}

/**
 * Update Add to Cart button state based on quantity
 * @param {HTMLElement} input - The quantity input element
 */
function updateAddToCartButton(input) {
    const row = input.closest('tr');
    if (!row) return;

    const button = row.querySelector('.add-to-cart');
    const available = parseInt(row.dataset.available || '0');
    const value = parseInt(input.value) || 0;

    if (button) {
        if (available <= 0 || value > available) {
            button.disabled = true;
            button.classList.add('disabled');
        } else {
            button.disabled = false;
            button.classList.remove('disabled');
        }
    }
}

/**
 * Show an alert message
 * @param {string} message - The message to display
 * @param {string} type - The type of alert (success, error, warning, info)
 */
function showAlert(message, type = 'info') {
    // Remove any existing alerts
    const existingAlert = document.querySelector('.alert-message');
    if (existingAlert) {
        existingAlert.remove();
    }

    // Create alert element
    const alert = document.createElement('div');
    alert.className = `alert-message alert-${type} fade-in`;
    alert.textContent = message;

    // Add to the page
    const container = document.querySelector('.container');
    if (container) {
        container.insertBefore(alert, container.firstChild);

        // Auto-remove after 5 seconds
        setTimeout(() => {
            alert.classList.add('fade-out');
            setTimeout(() => alert.remove(), 300);
        }, 5000);
    }
}

/**
 * Add fade-in animation to table rows
 */
function animateTableRows() {
    const rows = document.querySelectorAll('tbody tr');
    rows.forEach((row, index) => {
        // Add a slight delay to each row for a staggered effect
        setTimeout(() => {
            row.style.opacity = '0';
            row.style.animation = 'fadeIn 0.3s ease-out forwards';
            row.style.animationDelay = `${index * 0.05}s`;
        }, 0);
    });
}

// Handle browser back/forward navigation
window.addEventListener('popstate', function() {
    // Refresh the page to reflect any URL changes
    window.location.reload();
});
