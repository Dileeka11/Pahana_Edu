package src.business.servlet;

import src.business.user.dto.Userdto;
import src.business.user.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manage-users")
public class ManageUserServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Userdto> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("staff/manage_users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userService.deleteUser(id);
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String telephone = request.getParameter("telephone");
            String email = request.getParameter("email");
            String userType = request.getParameter("user_type");

            Userdto dto = new Userdto(id, null, name, address, telephone, email, userType);
            userService.updateUser(dto);
        }

        response.sendRedirect("manage-users");
    }
}
