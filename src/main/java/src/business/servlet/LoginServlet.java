package src.business.servlet;

import src.business.staff.service.StaffService;
import src.business.staff.dto.Staffdto;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final String hardcodedEmail = "admin@gmail.com";
    private final String hardcodedPassword = "123456";
    private StaffService staffService;

    @Override
    public void init() throws ServletException {
        staffService = new StaffService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // ✅ Admin login (hardcoded)
        if (email.equals(hardcodedEmail) && password.equals(hardcodedPassword)) {
            HttpSession session = request.getSession();
            session.setAttribute("user", "admin");
            response.sendRedirect("admin/adminpanel.jsp");
            return;
        }

        // ✅ Staff login with hashed password
        Staffdto staff = staffService.authenticateStaff(email);  // Fetch staff by email only
        if (staff != null && "Staff".equalsIgnoreCase(staff.getUser_type())) {
            // ✅ Verify hashed password
            if (BCrypt.checkpw(password, staff.getPassword())) {
                HttpSession session = request.getSession();
                session.setAttribute("staff", staff.getUsername());
                response.sendRedirect("staff/staffpanel.jsp");
                return;
            }
        }

        // If login fails
        response.sendRedirect("login.jsp?error=invalid");
    }
}
