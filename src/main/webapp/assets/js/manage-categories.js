/*******************************
 Modern Category Management JS
 *******************************/
(function() {
    'use strict';

    // Toast notification system
    const toast = (msg, type = 'success', timeout = 3000) => {
        let el = document.querySelector('.toast');
        if (!el) {
            el = document.createElement('div');
            el.className = 'toast';
            document.body.appendChild(el);
        }

        el.textContent = msg;
        el.className = `toast ${type}`;
        el.classList.add('show');

        setTimeout(() => {
            el.classList.remove('show');
        }, timeout);
    };

    // Enhanced delete confirmation with custom styling
    const confirmDelete = (categoryName) => {
        return confirm(`⚠️ Delete Category: "${categoryName}"?\n\nThis action cannot be undone. Are you sure you want to proceed?`);
    };

    // Form validation
    const validateForm = (form) => {
        const nameInput = form.querySelector('input[name="name"]');
        const name = nameInput.value.trim();

        if (!name) {
            toast('Category name is required!', 'error');
            nameInput.focus();
            return false;
        }

        if (name.length < 2) {
            toast('Category name must be at least 2 characters long!', 'error');
            nameInput.focus();
            return false;
        }

        if (name.length > 50) {
            toast('Category name must be less than 50 characters!', 'error');
            nameInput.focus();
            return false;
        }

        return true;
    };

    // Initialize edit functionality for inline editing
    const initializeInlineEdit = () => {
        document.querySelectorAll('.category-item').forEach(item => {
            const editBtn = item.querySelector('.edit-btn');
            const cancelBtn = item.querySelector('.cancel-btn');
            const editForm = item.querySelector('.edit-form');
            const displayContent = item.querySelector('.category-content');

            if (editBtn && editForm) {
                editBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    item.classList.add('editing');
                    editForm.style.display = 'block';
                    displayContent.style.display = 'none';

                    // Focus on name input
                    const nameInput = editForm.querySelector('input[name="name"]');
                    if (nameInput) {
                        nameInput.focus();
                        nameInput.select();
                    }
                });

                if (cancelBtn) {
                    cancelBtn.addEventListener('click', (e) => {
                        e.preventDefault();
                        item.classList.remove('editing');
                        editForm.style.display = 'none';
                        displayContent.style.display = 'block';
                    });
                }
            }
        });
    };

    // Handle form submissions with loading states
    const handleFormSubmission = (form, button) => {
        const originalText = button.textContent;
        const action = button.getAttribute('name') === 'action' ? button.value : 'submit';

        // Set loading state
        button.disabled = true;
        switch(action) {
            case 'add':
                button.textContent = '➕ Adding...';
                break;
            case 'update':
                button.textContent = '💾 Updating...';
                break;
            case 'delete':
                button.textContent = '🗑️ Deleting...';
                break;
            default:
                button.textContent = '⏳ Processing...';
        }

        // Restore button after delay (in case form doesn't redirect)
        setTimeout(() => {
            button.disabled = false;
            button.textContent = originalText;
        }, 5000);
    };

    // Update category count display
    const updateCategoryCount = () => {
        const categories = document.querySelectorAll('.category-item');
        const countElement = document.querySelector('.category-count');
        if (countElement) {
            countElement.textContent = categories.length;
        }
    };

    // Search/filter functionality
    const initializeSearch = () => {
        const searchInput = document.querySelector('#category-search');
        if (!searchInput) return;

        searchInput.addEventListener('input', (e) => {
            const searchTerm = e.target.value.toLowerCase().trim();
            const categories = document.querySelectorAll('.category-item');
            let visibleCount = 0;

            categories.forEach(item => {
                const name = item.querySelector('.category-content h4').textContent.toLowerCase();
                const description = item.querySelector('.category-content p').textContent.toLowerCase();

                if (name.includes(searchTerm) || description.includes(searchTerm)) {
                    item.style.display = 'block';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });

            // Show/hide empty state
            const emptyState = document.querySelector('.empty-search-state');
            if (emptyState) {
                emptyState.style.display = visibleCount === 0 && searchTerm ? 'block' : 'none';
            }
        });
    };

    // Keyboard shortcuts
    const initializeKeyboardShortcuts = () => {
        document.addEventListener('keydown', (e) => {
            // Ctrl/Cmd + K to focus search
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                const searchInput = document.querySelector('#category-search');
                if (searchInput) {
                    searchInput.focus();
                }
            }

            // Escape to cancel editing
            if (e.key === 'Escape') {
                const editingItems = document.querySelectorAll('.category-item.editing');
                editingItems.forEach(item => {
                    const cancelBtn = item.querySelector('.cancel-btn');
                    if (cancelBtn) {
                        cancelBtn.click();
                    }
                });
            }
        });
    };

    // Auto-save functionality for forms
    const initializeAutoSave = () => {
        const forms = document.querySelectorAll('form[data-autosave]');
        forms.forEach(form => {
            const inputs = form.querySelectorAll('input, textarea, select');
            inputs.forEach(input => {
                input.addEventListener('input', () => {
                    // Save to localStorage
                    const formData = new FormData(form);
                    const data = Object.fromEntries(formData.entries());
                    localStorage.setItem(`autosave_${form.id || 'form'}`, JSON.stringify(data));
                });
            });

            // Restore from localStorage
            const savedData = localStorage.getItem(`autosave_${form.id || 'form'}`);
            if (savedData) {
                try {
                    const data = JSON.parse(savedData);
                    Object.keys(data).forEach(key => {
                        const input = form.querySelector(`[name="${key}"]`);
                        if (input) {
                            input.value = data[key];
                        }
                    });
                } catch (e) {
                    console.warn('Could not restore autosaved data:', e);
                }
            }
        });
    };

    // Initialize drag and drop reordering (future enhancement)
    const initializeDragDrop = () => {
        // This would be for future drag-and-drop reordering functionality
        // Placeholder for now
    };

    // Main initialization
    const init = () => {
        console.log('📚 Initializing Category Management...');

        // Update category count on load
        updateCategoryCount();

        // Initialize inline editing
        initializeInlineEdit();

        // Initialize search functionality
        initializeSearch();

        // Initialize keyboard shortcuts
        initializeKeyboardShortcuts();

        // Initialize auto-save
        initializeAutoSave();

        // Handle all form submissions
        document.addEventListener('submit', (e) => {
            const form = e.target;
            if (!form.matches('form')) return;

            const action = form.querySelector('[name="action"]')?.value;
            const submitButton = document.activeElement;

            // Validate forms
            if (action === 'add' || action === 'update') {
                if (!validateForm(form)) {
                    e.preventDefault();
                    return;
                }
            }

            // Handle delete confirmation
            if (action === 'delete') {
                const categoryName = form.querySelector('input[name="name"]')?.value || 'this category';
                if (!confirmDelete(categoryName)) {
                    e.preventDefault();
                    return;
                }
            }

            // Handle form submission UI
            if (submitButton && submitButton.matches('button[type="submit"]')) {
                handleFormSubmission(form, submitButton);
            }

            // Clear autosave data on successful submission
            if (form.id) {
                localStorage.removeItem(`autosave_${form.id}`);
            }

            // Show success message
            const successMessages = {
                'add': 'Category added successfully! 🎉',
                'update': 'Category updated successfully! ✅',
                'delete': 'Category deleted successfully! 🗑️'
            };

            if (successMessages[action]) {
                setTimeout(() => {
                    toast(successMessages[action]);
                }, 100);
            }
        });

        // Handle click events for various actions
        document.addEventListener('click', (e) => {
            // Delete confirmation for buttons with data-confirm
            const confirmBtn = e.target.closest('[data-confirm]');
            if (confirmBtn) {
                const msg = confirmBtn.getAttribute('data-confirm') || 'Are you sure?';
                if (!confirm(msg)) {
                    e.preventDefault();
                    e.stopPropagation();
                    return;
                }
            }

            // Handle edit button clicks
            if (e.target.matches('.edit-btn') || e.target.closest('.edit-btn')) {
                e.preventDefault();
                // Handled by initializeInlineEdit
            }

            // Handle cancel button clicks
            if (e.target.matches('.cancel-btn') || e.target.closest('.cancel-btn')) {
                e.preventDefault();
                // Handled by initializeInlineEdit
            }
        });

        console.log('✅ Category Management initialized successfully!');
    };

    // Auto-initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    // Expose useful functions globally
    window.CategoryManager = {
        toast,
        confirmDelete,
        validateForm,
        updateCategoryCount
    };

})();