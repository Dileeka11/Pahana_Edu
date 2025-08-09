package src.business.bill.dto;

public class BillDto {
    private int id;
    private int userId;
    private int staffId;
    private String date;
    private double discount;
    private int qty;
    private double total;
    private double paid;
    private double balance;
    private double change;

    public BillDto() {
    }

    public BillDto(int id, int userId, int staffId, String date, double discount, int qty, double total, double paid, double balance, double change) {

        this.id = id;
        this.userId = userId;
        this.staffId = staffId;
        this.date = date;
        this.discount = discount;
        this.qty = qty;
        this.total = total;
        this.paid = paid;
        this.balance = balance;
        this.change = change;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public double getPaid() {
        return paid;
    }

    public void setPaid(double paid) {
        this.paid = paid;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }

    public double getChange() {
        return change;
    }

    public void setChange(double change) {
        this.change = change;
    }
}
