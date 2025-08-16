package src.business.dashboard.service;

import src.business.bill.service.BillService;
import src.business.book.service.BookService;
import src.business.user.service.UserService;
import src.business.staff.service.StaffService;
import src.business.dashboard.dto.DashboardStatsDto;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class DashboardService {
    private final BillService billService;
    private final BookService bookService;
    private final UserService userService;
    private final StaffService staffService;

    public DashboardService() {
        this.billService = new BillService();
        this.bookService = new BookService();
        this.userService = new UserService();
        this.staffService = new StaffService();
    }

    public DashboardStatsDto getDashboardStats() {
        DashboardStatsDto stats = new DashboardStatsDto();

        // Get today's date in the format used in the database
        String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        // Get total bills and sales for today
        int totalBillsToday = billService.countBillsForDate(today);
        double totalSalesToday = billService.getTotalSalesForDate(today);

        // Get top selling book
        Object[] topSellingBook = bookService.getTopSellingBook();

        // Get total counts
        long totalBooks = bookService.getAllBooks().size();
        long totalCustomers = userService.getTotalUsersCount();
        long totalStaff = staffService.getTotalStaffCount();

        // Set values in DTO
        stats.setTotalBillsToday(totalBillsToday);
        stats.setTotalSalesToday(totalSalesToday);

        if (topSellingBook != null && topSellingBook.length >= 2) {
            stats.setTopSellingBookTitle((String) topSellingBook[0]);
            stats.setTopSellingBookQty((int) topSellingBook[1]);
        } else {
            stats.setTopSellingBookTitle("N/A");
            stats.setTopSellingBookQty(0);
        }

        stats.setTotalBooks(totalBooks);
        stats.setTotalCustomers(totalCustomers);
        stats.setTotalStaff(totalStaff);

        return stats;
    }
}
