/**
 * User Lookup Page - Interactive Features
 * Handles form validation, animations, and user feedback
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Form validation
    const form = document.querySelector('form');
    if (form) {
        form.addEventListener('submit', function(event) {
            const searchTerm = document.getElementById('searchTerm').value.trim();

            // Clear previous error messages
            const existingError = document.querySelector('.error-message');
            if (existingError) {
                existingError.remove();
            }

            // Validate search term (email or phone number)
            if (!searchTerm) {
                showError('Please enter an email or phone number');
                event.preventDefault();
                return false;
            }

            // Optional: Add more specific validation for email/phone format
            // if (!isValidEmail(searchTerm) && !isValidPhone(searchTerm)) {
            //     showError('Please enter a valid email or phone number');
            //     event.preventDefault();
            //     return false;
            // }

            // Add loading state to submit button
            const submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Searching...';
            }
        });
    }

    // Function to show error message
    function showError(message) {
        const searchTermInput = document.getElementById('searchTerm');
        const errorElement = document.createElement('div');
        errorElement.className = 'error-message';
        errorElement.textContent = message;

        // Add animation class
        errorElement.style.opacity = '0';
        errorElement.style.transform = 'translateY(-10px)';
        errorElement.style.transition = 'opacity 0.3s ease, transform 0.3s ease';

        // Insert after the input field
        searchTermInput.parentNode.insertBefore(errorElement, searchTermInput.nextSibling);

        // Trigger reflow and animate in
        setTimeout(() => {
            errorElement.style.opacity = '1';
            errorElement.style.transform = 'translateY(0)';
        }, 10);

        // Focus the input field
        searchTermInput.focus();
    }

    // Helper function to validate email format
    function isValidEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(String(email).toLowerCase());
    }

    // Helper function to validate phone number format (simple validation)
    function isValidPhone(phone) {
        const re = /^[0-9\-\+\(\)\s]{8,20}$/;
        return re.test(phone);
    }

    // Add animation to form elements on page load
    const formGroups = document.querySelectorAll('.form-group');
    formGroups.forEach((group, index) => {
        group.style.animationDelay = `${index * 0.1}s`;
    });

    // Add hover effect to card
    const card = document.querySelector('.card');
    if (card) {
        card.style.transition = 'transform 0.3s ease, box-shadow 0.3s ease';
    }
});

// Function to show toast notification
function showToast(message, type = 'info') {
    const toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) return;

    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type} border-0`;
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');

    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    `;

    toastContainer.appendChild(toast);

    const bsToast = new bootstrap.Toast(toast, {
        autohide: true,
        delay: 5000
    });

    bsToast.show();

    // Remove toast from DOM after it's hidden
    toast.addEventListener('hidden.bs.toast', function () {
        toast.remove();
    });
}
