package src.business.servlet;

import src.business.bookcategory.dto.BookCategoryDto;
import src.business.bookcategory.service.BookCategoryService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manage-categories")
public class ManageBookCategoryServlet extends HttpServlet {

    private BookCategoryService categoryService;

    @Override
    public void init() throws ServletException {
        categoryService = new BookCategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<BookCategoryDto> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("staff/manage_categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            categoryService.addCategory(new BookCategoryDto(0, name, description));
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            categoryService.updateCategory(new BookCategoryDto(id, name, description));
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            categoryService.deleteCategory(id);
        }

        response.sendRedirect("manage-categories");
    }
}
