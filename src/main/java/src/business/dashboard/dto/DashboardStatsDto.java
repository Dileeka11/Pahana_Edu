package src.business.dashboard.dto;

public class DashboardStatsDto {
    private int totalBillsToday;
    private double totalSalesToday;
    private String topSellingBookTitle;
    private int topSellingBookQty;
    private long totalBooks;
    private long totalCustomers;
    private long totalStaff;

    // Getters and Setters
    public int getTotalBillsToday() {
        return totalBillsToday;
    }

    public void setTotalBillsToday(int totalBillsToday) {
        this.totalBillsToday = totalBillsToday;
    }

    public double getTotalSalesToday() {
        return totalSalesToday;
    }

    public void setTotalSalesToday(double totalSalesToday) {
        this.totalSalesToday = totalSalesToday;
    }

    public String getTopSellingBookTitle() {
        return topSellingBookTitle;
    }

    public void setTopSellingBookTitle(String topSellingBookTitle) {
        this.topSellingBookTitle = topSellingBookTitle;
    }

    public int getTopSellingBookQty() {
        return topSellingBookQty;
    }

    public void setTopSellingBookQty(int topSellingBookQty) {
        this.topSellingBookQty = topSellingBookQty;
    }

    public long getTotalBooks() {
        return totalBooks;
    }

    public void setTotalBooks(long totalBooks) {
        this.totalBooks = totalBooks;
    }

    public long getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(long totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public long getTotalStaff() {
        return totalStaff;
    }

    public void setTotalStaff(long totalStaff) {
        this.totalStaff = totalStaff;
    }
}
