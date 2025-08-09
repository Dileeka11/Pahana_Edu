package src.business.servlet;

import src.business.book.dto.BookDto;
import src.business.bookcategory.service.BookCategoryService;
import src.business.book.service.BookService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/manage-books")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10) // 10MB
public class ManageBookServlet extends HttpServlet {

    private BookService bookService;
    private BookCategoryService categoryService;

    @Override
    public void init() throws ServletException {
        bookService = new BookService();
        categoryService = new BookCategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("books", bookService.getAllBooks());
        request.setAttribute("categories", categoryService.getAllCategories());
        request.getRequestDispatcher("staff/manage_books.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            int categoryId = Integer.parseInt(request.getParameter("category_id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int qty = Integer.parseInt(request.getParameter("qty"));

            Part filePart = request.getPart("photo");
            String fileName = filePart.getSubmittedFileName();
            String photo = null;

            if (fileName != null && !fileName.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                photo = "uploads/" + fileName;
            }

            bookService.addBook(new BookDto(0, categoryId, name, description, price, photo, qty));

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            int categoryId = Integer.parseInt(request.getParameter("category_id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int qty = Integer.parseInt(request.getParameter("qty"));

            // Get existing book to preserve photo if not updated
            BookDto existingBook = bookService.getBookById(id);
            String photo = existingBook.getPhoto();

            Part filePart = request.getPart("photo");
            String fileName = filePart.getSubmittedFileName();

            if (fileName != null && !fileName.isEmpty()) {
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                photo = "uploads/" + fileName;
            }

            bookService.updateBook(new BookDto(id, categoryId, name, description, price, photo, qty));

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            bookService.deleteBook(id);
        }

        response.sendRedirect("manage-books");
    }
}
