/**
 * Checkout Page JavaScript
 * Handles form validation, calculations, and UI interactions
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize elements
    const discountInput = document.getElementById('discount');
    const paidInput = document.getElementById('paid');
    const balanceInput = document.getElementById('balance');
    const changeInput = document.getElementById('change');
    const checkoutForm = document.querySelector('form');
    const totalSpan = document.getElementById('totalSpan');

    // Get the total from the page
    const total = parseFloat(totalSpan ? totalSpan.textContent.replace(/,/g, '') : '0');

    // Initialize the calculation
    recalculateTotals();

    // Add event listeners for input changes
    if (discountInput) {
        discountInput.addEventListener('input', validateAndRecalculate);
        discountInput.addEventListener('blur', formatCurrencyInput);
    }

    if (paidInput) {
        paidInput.addEventListener('input', validateAndRecalculate);
        paidInput.addEventListener('blur', formatCurrencyInput);
    }

    // Form submission handler
    if (checkoutForm) {
        checkoutForm.addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
                return false;
            }
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            }

            // Continue with form submission
            return true;
        });
    }

    /**
     * Validates the form before submission
     */
    function validateForm() {
        // Validate discount
        const discount = parseFloat(discountInput.value) || 0;
        if (discount < 0) {
            showError('Discount cannot be negative');
            discountInput.focus();
            return false;
        }

        // Validate paid amount
        const paid = parseFloat(paidInput.value) || 0;
        if (paid < 0) {
            showError('Paid amount cannot be negative');
            paidInput.focus();
            return false;
        }

        // Check if paid is sufficient
        const balance = parseFloat(balanceInput.value) || 0;
        if (balance > 0) {
            const confirmProceed = confirm('The customer still has a balance. Are you sure you want to proceed?');
            if (!confirmProceed) {
                paidInput.focus();
                return false;
            }
        }

        return true;
    }

    /**
     * Validates input and recalculates totals
     */
    function validateAndRecalculate() {
        // Ensure values are positive
        if (this.value < 0) {
            this.value = Math.abs(this.value);
        }

        recalculateTotals();
    }

    /**
     * Recalculates all totals based on current inputs
     */
    function recalculateTotals() {
        const discount = parseFloat(discountInput.value) || 0;
        const paid = parseFloat(paidInput.value) || 0;

        // Calculate net total after discount
        const netTotal = Math.max(0, total - discount);

        // Calculate balance and change
        let balance = netTotal - paid;
        let change = 0;

        if (balance < 0) {
            change = Math.abs(balance);
            balance = 0;
        }

        // Update the UI
        if (balanceInput) balanceInput.value = balance.toFixed(2);
        if (changeInput) changeInput.value = change.toFixed(2);

        // Update visual feedback
        updateVisualFeedback();
    }

    /**
     * Updates visual feedback based on calculations
     */
    function updateVisualFeedback() {
        const balance = parseFloat(balanceInput.value) || 0;
        const change = parseFloat(changeInput.value) || 0;

        // Update balance and change colors
        if (balance > 0) {
            balanceInput.style.color = '#e74c3c'; // Red for balance due
            balanceInput.style.fontWeight = 'bold';
        } else {
            balanceInput.style.color = '';
            balanceInput.style.fontWeight = '';
        }

        if (change > 0) {
            changeInput.style.color = '#27ae60'; // Green for change due
            changeInput.style.fontWeight = 'bold';
        } else {
            changeInput.style.color = '';
            changeInput.style.fontWeight = '';
        }
    }

    /**
     * Formats currency input on blur
     */
    function formatCurrencyInput() {
        const value = parseFloat(this.value);
        if (!isNaN(value)) {
            this.value = value.toFixed(2);
        } else {
            this.value = '0.00';
        }
    }

    /**
     * Shows an error message to the user
     * @param {string} message - The error message to display
     */
    function showError(message) {
        // Remove any existing error messages
        const existingError = document.querySelector('.error-message');
        if (existingError) {
            existingError.remove();
        }

        // Create and show new error message
        const errorDiv = document.createElement('div');
        errorDiv.className = 'alert alert-error';
        errorDiv.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${message}`;
        errorDiv.style.margin = '0 0 20px 0';
        errorDiv.style.backgroundColor = '#fde8e8';
        errorDiv.style.color = '#9b2c2c';
        errorDiv.style.borderLeft = '4px solid #e53e3e';
        errorDiv.style.padding = '12px 16px';
        errorDiv.style.borderRadius = '4px';
        errorDiv.style.fontSize = '14px';
        errorDiv.style.display = 'flex';
        errorDiv.style.alignItems = 'center';
        errorDiv.style.gap = '10px';

        // Insert the error message at the top of the form
        const form = document.querySelector('form');
        if (form) {
            form.insertBefore(errorDiv, form.firstChild);

            // Auto-remove the error after 5 seconds
            setTimeout(() => {
                errorDiv.style.opacity = '0';
                errorDiv.style.transition = 'opacity 0.5s ease';
                setTimeout(() => errorDiv.remove(), 500);
            }, 5000);
        }
    }

    // Add animation to form fields on focus
    const formInputs = document.querySelectorAll('input[type="text"], input[type="number"], input[type="email"], input[type="tel"]');
    formInputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentNode.classList.add('focused');
        });

        input.addEventListener('blur', function() {
            if (!this.value) {
                this.parentNode.classList.remove('focused');
            }
        });
    });

    // Add animation to buttons
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
        button.addEventListener('mousedown', function() {
            this.style.transform = 'translateY(1px)';
        });

        button.addEventListener('mouseup', function() {
            this.style.transform = '';
        });

        button.addEventListener('mouseleave', function() {
            this.style.transform = '';
        });
    });
});
