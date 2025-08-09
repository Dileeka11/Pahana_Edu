package src.business.bill_item.model;

public class BillItemModel {
    private int id;
    private int billId;
    private int bookId;

    public BillItemModel() {}

    public BillItemModel(int id, int billId, int bookId) {
        this.id = id;
        this.billId = billId;
        this.bookId = bookId;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
}
