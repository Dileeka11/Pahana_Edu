package src.business.servlet;

import src.business.user.dto.Userdto;
import src.business.user.service.UserService;
import src.business.user.model.UserModel;

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

        // --- FLASH MESSAGES (session -> request) ---
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object msg = session.getAttribute("message");
            Object type = session.getAttribute("messageType");
            if (msg != null) {
                request.setAttribute("message", msg);
                request.setAttribute("messageType", type != null ? type : "info");
                session.removeAttribute("message");
                session.removeAttribute("messageType");
            }
        }

        request.getRequestDispatcher("staff/manage_users.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(); // for flash

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                userService.deleteUser(id);

                session.setAttribute("message", "User deleted successfully!");
                session.setAttribute("messageType", "success");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String address = request.getParameter("address");
                String telephone = request.getParameter("telephone");
                String email = request.getParameter("email");
                String userType = request.getParameter("user_type");

                // ⚠️ Safer: fetch existing by ID (email/phone might be changing)
                // Add userService.getById(id) in your service if you don't have it yet.
                UserModel existingUser = userService.getUserById(id);
                int unitsConsumed = (existingUser != null) ? existingUser.getUnitsConsumed() : 0;

                Userdto dto = new Userdto(id, null, name, address, telephone, email, userType, unitsConsumed);
                userService.updateUser(dto);

                session.setAttribute("message", "User updated successfully!");
                session.setAttribute("messageType", "success");

            } else if ("add".equals(action)) {
                // If you add “create” here in the future:
                // userService.addUser(...);
                session.setAttribute("message", "User added successfully!");
                session.setAttribute("messageType", "success");
            }

        } catch (Exception e) {
            // Optional: log e for debugging
            session.setAttribute("message", "Operation failed. " +
                    "If this user is referenced elsewhere, resolve those links and try again.");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect("manage-users");
    }

}
