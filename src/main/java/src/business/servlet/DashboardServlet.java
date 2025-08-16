package src.business.servlet;

import com.google.gson.Gson;
import src.business.dashboard.dto.DashboardStatsDto;
import src.business.dashboard.service.DashboardService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/dashboard/stats")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final DashboardService dashboardService;
    private final Gson gson;

    public DashboardServlet() {
        this.dashboardService = new DashboardService();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get dashboard statistics
            DashboardStatsDto stats = dashboardService.getDashboardStats();

            // Convert to JSON
            String jsonResponse = gson.toJson(stats);

            // Set response type and write JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Error fetching dashboard statistics\"}");
            e.printStackTrace();
        }
    }
}
