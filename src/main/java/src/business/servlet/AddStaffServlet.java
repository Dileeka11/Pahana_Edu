package src.business.servlet;

import org.mindrot.jbcrypt.BCrypt;
import src.business.staff.dto.Staffdto;
import src.business.staff.service.StaffService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/addstaff")
public class AddStaffServlet extends HttpServlet {
    private StaffService staffService;

    @Override
    public void init() throws ServletException {
        staffService = new StaffService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String userType = "Staff";

        try {
            // Check if email already exists
            if (staffService.doesEmailExist(email)) {
                response.sendRedirect("addstaff.jsp?error=email_exists");
                return;
            }

            // Hash the password before saving
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            Staffdto staffDto = new Staffdto();
            staffDto.setUsername(username);
            staffDto.setEmail(email);
            staffDto.setPassword(hashedPassword);
            staffDto.setUser_type(userType);

            boolean success = staffService.registerStaff(staffDto);

            if (success) {
                response.sendRedirect("addstaff.jsp?success=true");
            } else {
                response.sendRedirect("addstaff.jsp?error=general_error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addstaff.jsp?error=general_error");
        }
    }
}
