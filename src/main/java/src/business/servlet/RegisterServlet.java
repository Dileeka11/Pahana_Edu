package src.business.servlet;

import src.business.user.dto.Userdto;
import src.business.user.service.UserService;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    /**
     * Handles GET - Show Registration Form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userType = request.getParameter("user_type");
        if (userType == null || userType.trim().isEmpty()) {
            userType = "customer";
        }

        UserService userService = new UserService();
        String nextAccountNumber = userService.generateNextAccountNumber(userType);

        request.setAttribute("account_number", nextAccountNumber);
        request.setAttribute("user_type", userType);

        RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
        dispatcher.forward(request, response);
    }



    /**
     * Handles POST - Register User
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");
        String userType = request.getParameter("user_type");

        if (userType == null || userType.trim().isEmpty()) {
            userType = "customer";
        }

        Userdto userDto = new Userdto();
        userDto.setName(name);
        userDto.setAddress(address);
        userDto.setTelephone(telephone);
        userDto.setEmail(email);
        userDto.setUser_type(userType);

        String result = userService.registerUser(userDto);

        if (result == null) {
            response.sendRedirect("register.jsp?error=unknown");
        } else if (result.startsWith("error:")) {
            // ⬇️ This is where you add the prefix logic for error case
            String prefix = userDto.getUser_type().equalsIgnoreCase("staff") ? "STF00" : "CUS00";
            String redirectParams = "register.jsp?error=" + result.substring(6) + "&account_number=" + prefix + "AUTO";
            response.sendRedirect(redirectParams);
        } else {
            // Get the redirectTo parameter if it exists
            String redirectTo = request.getParameter("redirectTo");
            if (redirectTo != null && !redirectTo.isEmpty()) {
                // Extract the user ID from the result (assuming result is the account number)
                // You might need to adjust this based on your actual account number format
                String userId = result.replaceAll("[^0-9]", "");
                response.sendRedirect(redirectTo + "?userId=" + userId);
            } else {
                // Redirect to manage_users.jsp after successful registration
                response.sendRedirect("manage-users");
            }
        }
    }



}
