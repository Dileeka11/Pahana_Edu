package src.business.book.model;

public class BookModel {
    private int id;
    private int categoryId;
    private String name;
    private String description;
    private double price;
    private String photo;
    private int qty;

    public BookModel() {}

    public BookModel(int id, int categoryId, String name, String description, double price, String photo, int qty) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.photo = photo;
        this.qty = qty;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }
}
