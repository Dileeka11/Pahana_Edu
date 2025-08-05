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

        // Get user type from query param (staff or customer)
        String userType = request.getParameter("user_type");
        if (userType == null || userType.trim().isEmpty()) {
            userType = "customer"; // Default if not provided
        }

        // Set prefix for account number display
        String prefix = "CUS00";
        if ("staff".equalsIgnoreCase(userType)) {
            prefix = "STF00";
        }

        // Display placeholder account number
        String tempAccountNumber = prefix + "AUTO"; // Just for UI, real one will be generated after insert

        request.setAttribute("account_number", tempAccountNumber);
        request.setAttribute("user_type", userType);

        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles POST - Register User
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form fields
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        String email = request.getParameter("email");
        String userType = request.getParameter("user_type");

        // Default to customer if missing
        if (userType == null || userType.trim().isEmpty()) {
            userType = "customer";
        }

        // Create DTO
        Userdto userDto = new Userdto();
        userDto.setName(name);
        userDto.setAddress(address);
        userDto.setTelephone(telephone);
        userDto.setEmail(email);
        userDto.setUser_type(userType);

        // Register user via service
        String accountNumber = userService.registerUser(userDto);

        // Redirect based on success or failure
        if (accountNumber != null) {
            // Pass generated account number to success page
            response.sendRedirect("success.jsp?account=" + accountNumber);
        } else {
            response.sendRedirect("register.jsp?error=true");
        }
    }
}
