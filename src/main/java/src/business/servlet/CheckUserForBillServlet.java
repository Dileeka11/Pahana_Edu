package src.business.servlet;

import src.business.user.service.UserService;
import src.business.user.model.UserModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/check-user-bill")
public class CheckUserForBillServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("searchTerm");
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            // Search for user by email or phone
            UserModel user = userService.findUserByEmailOrPhone(searchTerm.trim());
            
            if (user != null) {
                // Store user in session for later use
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                
                // Redirect to book selection page with user ID
                response.sendRedirect(String.format("%s/staff/select_books.jsp?customerId=%d", 
                    request.getContextPath(), 
                    user.getId()));
                return;
            } else {
                // User not found, set error message and forward back to lookup page
                request.setAttribute("searchTerm", searchTerm);
                request.setAttribute("error", "No user found with the provided email or phone number. " +
                        "Please check the details or register as a new user.");
            }
        } else {
            request.setAttribute("error", "Please enter a valid email or phone number.");
        }
        
        // Show the user lookup form with error message if any
        request.getRequestDispatcher("/staff/user-lookup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
