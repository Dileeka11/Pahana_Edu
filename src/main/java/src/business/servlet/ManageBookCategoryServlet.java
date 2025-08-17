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

        HttpSession session = request.getSession();
        String message = (String) session.getAttribute("message");
        String messageType = (String) session.getAttribute("messageType");

        if (message != null) {
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);

            session.removeAttribute("message");
            session.removeAttribute("messageType");
        }

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

            request.getSession().setAttribute("message", "Category added successfully!");
            request.getSession().setAttribute("messageType", "success");

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            categoryService.updateCategory(new BookCategoryDto(id, name, description));

            request.getSession().setAttribute("message", "Category updated successfully!");
            request.getSession().setAttribute("messageType", "success");

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            categoryService.deleteCategory(id);

            request.getSession().setAttribute("message", "Category deleted successfully!");
            request.getSession().setAttribute("messageType", "success");
        }

        response.sendRedirect("manage-categories");

    }
}
