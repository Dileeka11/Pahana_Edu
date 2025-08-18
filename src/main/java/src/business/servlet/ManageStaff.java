package src.business.servlet;

import com.google.gson.Gson;
import src.business.staff.dto.Staffdto;
import src.business.staff.service.StaffService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/ManageStaff")
public class ManageStaff extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StaffService staffService;
    private final Gson gson;

    public ManageStaff() {
        this.staffService = new StaffService();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get all staff members
        request.setAttribute("staffList", staffService.getAllStaff());
        request.getRequestDispatcher("/admin/managestaff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        Map<String, Object> result = new HashMap<>();
        
        try {
            if ("update".equals(action)) {
                handleUpdate(request, result);
            } else if ("delete".equals(action)) {
                handleDelete(request, result);
            } else {
                result.put("success", false);
                result.put("message", "Invalid action");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(result));
            out.flush();
        }
    }
    
    private void handleUpdate(HttpServletRequest request, Map<String, Object> result) {
        Staffdto staff = new Staffdto();
        staff.setId(Integer.parseInt(request.getParameter("id")));
        staff.setUsername(request.getParameter("username"));
        staff.setEmail(request.getParameter("email"));
        
        // Only update password if provided
        String password = request.getParameter("password");
        if (password != null && !password.trim().isEmpty()) {
            staff.setPassword(password); // In a real app, hash this password
        }
        
        staff.setUser_type(request.getParameter("user_type"));
        
        boolean success = staffService.updateStaff(staff);
        result.put("success", success);
        result.put("message", success ? "Staff updated successfully" : "Failed to update staff");
    }
    
    private void handleDelete(HttpServletRequest request, Map<String, Object> result) {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = staffService.deleteStaff(id);
        result.put("success", success);
        result.put("message", success ? "Staff deleted successfully" : "Failed to delete staff");
    }
}
