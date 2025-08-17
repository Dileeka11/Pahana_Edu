<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="src.business.book.dto.BookDto" %>
<%@ page import="src.business.bookcategory.dto.BookCategoryDto" %>
<%
    List<BookDto> books = (List<BookDto>) request.getAttribute("books");
    List<BookCategoryDto> categories = (List<BookCategoryDto>) request.getAttribute("categories");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Books</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #e0f7ff 0%, #b3e5fc 100%);
        }
        .card-shadow {
            box-shadow: 0 10px 25px rgba(3, 169, 244, 0.1);
        }
        .hover-lift {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .hover-lift:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(3, 169, 244, 0.15);
        }
        .input-focus {
            transition: all 0.3s ease;
        }
        .input-focus:focus {
            box-shadow: 0 0 0 3px rgba(3, 169, 244, 0.1);
            border-color: #03a9f4;
        }
        .btn-primary {
            background: linear-gradient(135deg, #03a9f4 0%, #0288d1 100%);
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #0288d1 0%, #0277bd 100%);
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(3, 169, 244, 0.3);
        }
        .btn-danger {
            background: linear-gradient(135deg, #f44336 0%, #d32f2f 100%);
            transition: all 0.3s ease;
        }
        .btn-danger:hover {
            background: linear-gradient(135deg, #d32f2f 0%, #c62828 100%);
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(244, 67, 54, 0.3);
        }
        .table-header {
            background: linear-gradient(135deg, #03a9f4 0%, #0288d1 100%);
        }
        .table-row:hover {
            background: rgba(3, 169, 244, 0.05);
        }
        .custom-file-input {
            position: relative;
            overflow: hidden;
            display: inline-block;
            cursor: pointer;
        }
        .custom-file-input input[type=file] {
            position: absolute;
            left: -9999px;
        }
        .file-label {
            background: linear-gradient(135deg, #e1f5fe 0%, #b3e5fc 100%);
            border: 2px dashed #03a9f4;
            transition: all 0.3s ease;
        }
        .file-label:hover {
            background: linear-gradient(135deg, #b3e5fc 0%, #81d4fa 100%);
            border-color: #0288d1;
        }
    </style>
</head>
<body class="gradient-bg min-h-screen p-6">
<%@ include file="/staff/includes/navbar.jsp" %>
<%-- SweetAlert Notifications --%>
<% if (successMessage != null && !successMessage.isEmpty()) { %>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        Swal.fire({
            icon: 'success',
            title: 'Success!',
            text: '<%= successMessage %>',
            confirmButtonColor: '#03a9f4',
            timer: 3000,
            timerProgressBar: true
        });
    });
</script>
<% } %>
<% if (errorMessage != null && !errorMessage.isEmpty()) { %>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        Swal.fire({
            icon: 'error',
            title: 'Error!',
            text: '<%= errorMessage %>',
            confirmButtonColor: '#f44336'
        });
    });
</script>
<% } %>

<div class="max-w-7xl mx-auto">
    <!-- Header Section -->
    <div class="bg-white card-shadow hover-lift rounded-xl p-8 mb-8">
        <div class="text-center">
            <div class="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-r from-blue-400 to-blue-600 rounded-full mb-4">
                <i class="fas fa-book text-2xl text-white"></i>
            </div>
            <h1 class="text-4xl font-bold bg-gradient-to-r from-blue-600 to-blue-800 bg-clip-text text-transparent mb-2">
                Book Management System
            </h1>
            <p class="text-gray-600">Manage your book inventory with ease</p>
        </div>
    </div>

    <!-- Add Book Form Section -->
    <div class="bg-white card-shadow hover-lift rounded-xl p-8 mb-8">
        <div class="flex items-center mb-6">
            <div class="w-8 h-8 bg-gradient-to-r from-green-400 to-green-600 rounded-full flex items-center justify-center mr-3">
                <i class="fas fa-plus text-white text-sm"></i>
            </div>
            <h2 class="text-2xl font-bold text-gray-800">Add New Book</h2>
        </div>

        <form id="addBookForm" method="post" action="manage-books" enctype="multipart/form-data"
              class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6">
            <input type="hidden" name="action" value="add">

            <!-- Category -->
            <div class="space-y-2">
                <label class="block text-sm font-semibold text-gray-700">
                    <i class="fas fa-tags text-blue-500 mr-2"></i>Category
                </label>
                <select name="category_id" required
                        class="w-full px-4 py-3 border border-gray-200 rounded-lg input-focus bg-white text-sm">
                    <option value="">Select Category</option>
                    <% for (BookCategoryDto cat : categories) { %>
                    <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                    <% } %>
                </select>
            </div>

            <!-- Name -->
            <div class="space-y-2">
                <label class="block text-sm font-semibold text-gray-700">
                    <i class="fas fa-book text-blue-500 mr-2"></i>Book Name
                </label>
                <input type="text" name="name" placeholder="Enter book name" required
                       class="w-full px-4 py-3 border border-gray-200 rounded-lg input-focus text-sm">
            </div>

            <!-- Description -->
            <div class="space-y-2">
                <label class="block text-sm font-semibold text-gray-700">
                    <i class="fas fa-align-left text-blue-500 mr-2"></i>Description
                </label>
                <input type="text" name="description" placeholder="Book description"
                       class="w-full px-4 py-3 border border-gray-200 rounded-lg input-focus text-sm">
            </div>

            <!-- Price -->
            <div class="space-y-2">
                <label class="block text-sm font-semibold text-gray-700">
                    <i class="fas fa-dollar-sign text-blue-500 mr-2"></i>Price
                </label>
                <input type="number" step="0.01" name="price" placeholder="0.00" required
                       class="w-full px-4 py-3 border border-gray-200 rounded-lg input-focus text-sm">
            </div>

            <!-- Quantity -->
            <div class="space-y-2">
                <label class="block text-sm font-semibold text-gray-700">
                    <i class="fas fa-boxes text-blue-500 mr-2"></i>Quantity
                </label>
                <input type="number" name="qty" value="1" min="0" required
                       class="w-full px-4 py-3 border border-gray-200 rounded-lg input-focus text-sm">
            </div>

            <!-- Photo Upload -->
            <div class="space-y-2">
                <label class="block text-sm font-semibold text-gray-700">
                    <i class="fas fa-image text-blue-500 mr-2"></i>Book Photo
                </label>
                <div class="custom-file-input">
                    <label for="photo-upload" class="file-label w-full px-4 py-3 rounded-lg cursor-pointer text-center block text-sm text-blue-600 font-medium">
                        <i class="fas fa-cloud-upload-alt mr-2"></i>Choose File
                    </label>
                    <input type="file" name="photo" id="photo-upload">
                </div>
            </div>

            <!-- Submit Button -->
            <div class="md:col-span-2 xl:col-span-2 flex items-end">
                <button type="submit" id="addBookBtn"
                        class="btn-primary text-white px-8 py-3 rounded-lg font-semibold text-sm w-full">
                    <i class="fas fa-plus mr-2"></i>Add Book
                </button>
            </div>
        </form>
    </div>

    <!-- Books Table Section -->
    <div class="bg-white card-shadow hover-lift rounded-xl p-8">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center">
                <div class="w-8 h-8 bg-gradient-to-r from-blue-400 to-blue-600 rounded-full flex items-center justify-center mr-3">
                    <i class="fas fa-list text-white text-sm"></i>
                </div>
                <h2 class="text-2xl font-bold text-gray-800">Book Inventory</h2>
            </div>
            <div class="text-sm text-gray-600">
                <span class="font-semibold"><%= books != null ? books.size() : 0 %></span> books total
            </div>
        </div>

        <div class="overflow-x-auto rounded-lg">
            <table class="w-full border-collapse">
                <thead>
                <tr class="table-header text-white">
                    <th class="px-6 py-4 text-left font-semibold">
                        <i class="fas fa-hashtag mr-2"></i>ID
                    </th>
                    <th class="px-6 py-4 text-left font-semibold">
                        <i class="fas fa-tags mr-2"></i>Category
                    </th>
                    <th class="px-6 py-4 text-left font-semibold">
                        <i class="fas fa-book mr-2"></i>Name
                    </th>
                    <th class="px-6 py-4 text-left font-semibold">
                        <i class="fas fa-align-left mr-2"></i>Description
                    </th>
                    <th class="px-6 py-4 text-left font-semibold">
                        <i class="fas fa-dollar-sign mr-2"></i>Price
                    </th>
                    <th class="px-6 py-4 text-left font-semibold">
                        <i class="fas fa-boxes mr-2"></i>Qty
                    </th>
                    <th class="px-6 py-4 text-left font-semibold">
                        <i class="fas fa-image mr-2"></i>Photo
                    </th>
                    <th class="px-6 py-4 text-center font-semibold">
                        <i class="fas fa-cogs mr-2"></i>Actions
                    </th>
                </tr>
                </thead>
                <tbody>
                <% if (books != null) {
                    for (BookDto book : books) { %>
                <tr class="border-b border-gray-100 table-row">
                    <form method="post" action="manage-books" enctype="multipart/form-data" class="contents update-form">
                        <td class="px-6 py-4 font-medium text-gray-900">
                            <span class="bg-blue-50 text-blue-700 px-3 py-1 rounded-full text-sm font-semibold">
                                #<%= book.getId() %>
                            </span>
                        </td>

                        <!-- Category -->
                        <td class="px-6 py-4">
                            <select name="category_id"
                                    class="w-full px-3 py-2 border border-gray-200 rounded-lg input-focus text-sm bg-white">
                                <% for (BookCategoryDto cat : categories) { %>
                                <option value="<%= cat.getId() %>" <%= (cat.getId() == book.getCategoryId() ? "selected" : "") %>>
                                    <%= cat.getName() %>
                                </option>
                                <% } %>
                            </select>
                        </td>

                        <!-- Name -->
                        <td class="px-6 py-4">
                            <input type="text" name="name" value="<%= book.getName() %>"
                                   class="w-full px-3 py-2 border border-gray-200 rounded-lg input-focus text-sm font-medium">
                        </td>

                        <!-- Description -->
                        <td class="px-6 py-4">
                            <input type="text" name="description" value="<%= book.getDescription() %>"
                                   class="w-full px-3 py-2 border border-gray-200 rounded-lg input-focus text-sm">
                        </td>

                        <!-- Price -->
                        <td class="px-6 py-4">
                            <div class="relative">
                                <span class="absolute left-3 top-2.5 text-gray-500 text-sm">$</span>
                                <input type="number" step="0.01" name="price" value="<%= book.getPrice() %>"
                                       class="w-full pl-8 pr-3 py-2 border border-gray-200 rounded-lg input-focus text-sm font-medium">
                            </div>
                        </td>

                        <!-- Qty -->
                        <td class="px-6 py-4">
                            <input type="number" name="qty" value="<%= book.getQty() %>" min="0"
                                   class="w-full px-3 py-2 border border-gray-200 rounded-lg input-focus text-sm text-center font-medium">
                        </td>

                        <!-- Photo -->
                        <td class="px-6 py-4">
                            <div class="space-y-3">
                                <% if (book.getPhoto() != null && !book.getPhoto().isEmpty()) { %>
                                <div class="relative">
                                    <img src="<%= book.getPhoto() %>" class="w-16 h-16 object-cover rounded-lg border-2 border-gray-200 shadow-sm">
                                    <div class="absolute -top-1 -right-1 w-4 h-4 bg-green-500 rounded-full border-2 border-white"></div>
                                </div>
                                <% } else { %>
                                <div class="w-16 h-16 bg-gray-100 rounded-lg border-2 border-dashed border-gray-300 flex items-center justify-center">
                                    <i class="fas fa-image text-gray-400"></i>
                                </div>
                                <% } %>
                                <div class="custom-file-input">
                                    <label for="photo-update-<%= book.getId() %>" class="file-label px-3 py-2 rounded-lg cursor-pointer text-center block text-xs text-blue-600 font-medium">
                                        <i class="fas fa-edit mr-1"></i>Update
                                    </label>
                                    <input type="file" name="photo" id="photo-update-<%= book.getId() %>">
                                </div>
                                <input type="hidden" name="existingPhoto" value="<%= book.getPhoto() %>">
                            </div>
                        </td>

                        <!-- Actions -->
                        <td class="px-6 py-4">
                            <div class="flex items-center justify-center space-x-3">
                                <input type="hidden" name="id" value="<%= book.getId() %>">

                                <button type="submit" name="action" value="update"
                                        class="btn-primary text-white px-4 py-2 rounded-lg text-sm font-medium flex items-center update-btn">
                                    <i class="fas fa-save mr-1"></i>Update
                                </button>

                                <button type="button" onclick="confirmDelete('<%= book.getId() %>','<%= book.getName() %>')"
                                        class="btn-danger text-white px-4 py-2 rounded-lg text-sm font-medium flex items-center">
                                    <i class="fas fa-trash mr-1"></i>Delete
                                </button>
                            </div>
                        </td>
                    </form>
                </tr>
                <% }} %>
                </tbody>
            </table>
        </div>

        <% if (books == null || books.isEmpty()) { %>
        <div class="text-center py-12">
            <div class="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <i class="fas fa-book text-2xl text-gray-400"></i>
            </div>
            <h3 class="text-lg font-semibold text-gray-600 mb-2">No books found</h3>
            <p class="text-gray-500">Add your first book using the form above.</p>
        </div>
        <% } %>
    </div>
</div>

<script>
    // Add Book Form Submission Handler (Keep with fetch for add operation)
    document.getElementById('addBookForm').addEventListener('submit', function(e) {
        e.preventDefault();

        // Show loading state
        const submitBtn = document.getElementById('addBookBtn');
        const originalBtnText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Adding...';
        submitBtn.disabled = true;

        // Submit form data
        const formData = new FormData(this);

        fetch('manage-books', {
            method: 'POST',
            body: formData
        })
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.text();
            })
            .then(() => {
                // Show success message and reload after user clicks OK or timer ends
                return Swal.fire({
                    icon: 'success',
                    title: 'Success!',
                    text: 'Book has been added successfully!',
                    confirmButtonColor: '#03a9f4',
                    timer: 3000,
                    timerProgressBar: true
                });
            })
            .then((result) => {
                // This will run after the alert is closed or timer ends
                window.location.reload();
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: 'Failed to add book. Please try again.',
                    confirmButtonColor: '#f44336'
                });
            })
            .finally(() => {
                // Reset button state
                submitBtn.innerHTML = originalBtnText;
                submitBtn.disabled = false;
            });
    });

    // Function to confirm book deletion
    function confirmDelete(bookId, bookTitle) {
        Swal.fire({
            title: 'Are you sure?',
            text: `You are about to delete "${bookTitle}". This action cannot be undone!`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#03a9f4',
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                // Show loading state
                const loadingSwal = Swal.fire({
                    title: 'Deleting...',
                    text: 'Please wait while we delete the book',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                // Submit the delete form using fetch
                const formData = new FormData();
                formData.append('action', 'delete');
                formData.append('id', bookId);

                fetch('manage-books', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => {
                        if (!response.ok) throw new Error('Network response was not ok');
                        return response.text();
                    })
                    .then(() => {
                        // Close loading dialog first
                        loadingSwal.close();

                        // Show success message
                        return Swal.fire({
                            icon: 'success',
                            title: 'Deleted!',
                            text: `"${bookTitle}" has been deleted successfully!`,
                            confirmButtonColor: '#03a9f4',
                            timer: 3000,
                            timerProgressBar: true
                        });
                    })
                    .then(() => {
                        // Reload the page after success message is dismissed or timer ends
                        window.location.reload();
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        loadingSwal.close();
                        Swal.fire({
                            icon: 'error',
                            title: 'Error!',
                            text: 'Failed to delete book. Please try again.',
                            confirmButtonColor: '#f44336'
                        });
                    });
            }
        });
    }

    // Handle update form submissions with traditional form submission
    document.querySelectorAll('.update-form').forEach(form => {
        form.addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('.update-btn');
            if (!submitBtn) return;

            // Show loading state
            const originalBtnText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i>Updating...';
            submitBtn.disabled = true;

            // Allow traditional form submission to proceed
            // The page will reload and show success message via JSP
        });
    });

    // File upload visual feedback
    document.querySelectorAll('input[type="file"]').forEach(input => {
        input.addEventListener('change', function() {
            const label = this.parentElement.querySelector('.file-label');
            if (this.files && this.files[0]) {
                label.innerHTML = '<i class="fas fa-check mr-2"></i>File Selected';
                label.classList.add('bg-green-50', 'border-green-400', 'text-green-600');
            }
        });
    });
</script>
</body>
</html>