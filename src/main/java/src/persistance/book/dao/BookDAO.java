package src.persistance.book.dao;

import src.business.book.model.BookModel;
import src.persistance.dbconnection.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    public boolean insertBook(BookModel book) {
        System.out.println("BookDAO: Inserting new book into database...");
        String sql = "INSERT INTO books (category_id, name, description, price, photo, qty) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, book.getCategoryId());
            stmt.setString(2, book.getName());
            stmt.setString(3, book.getDescription());
            stmt.setDouble(4, book.getPrice());
            stmt.setString(5, book.getPhoto());
            stmt.setInt(6, book.getQty());

            System.out.println("BookDAO: Successfully connected to database");
            System.out.println("BookDAO: Inserting book - ID: " + book.getCategoryId() + 
                               ", Name: " + book.getName() + 
                               ", Qty: " + book.getQty());
            int rowsAffected = stmt.executeUpdate();
            System.out.println("BookDAO: Insertion result: " + rowsAffected + " rows affected");
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("BookDAO: Error executing query: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to insert book into database", e);
        } catch (Exception e) {
            System.err.println("BookDAO: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Unexpected error in BookDAO", e);
        }
    }

    public List<BookModel> getAllBooks() {
        System.out.println("BookDAO: Getting all books from database...");
        List<BookModel> books = new ArrayList<>();
        String sql = "SELECT * FROM books";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            System.out.println("BookDAO: Successfully connected to database");
            
            int count = 0;
            while (rs.next()) {
                count++;
                BookModel book = new BookModel(
                    rs.getInt("id"),
                    rs.getInt("category_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("photo"),
                    rs.getInt("qty")
                );
                System.out.println("BookDAO: Found book - ID: " + book.getId() + 
                               ", Name: " + book.getName() + 
                               ", Qty: " + book.getQty());
                books.add(book);
            }
            
            System.out.println("BookDAO: Total books found: " + count);
            if (count == 0) {
                System.out.println("BookDAO: No books found in the database");
            }
            
        } catch (SQLException e) {
            System.err.println("BookDAO: Error executing query: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve books from database", e);
        } catch (Exception e) {
            System.err.println("BookDAO: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Unexpected error in BookDAO", e);
        }
        
        return books;
    }

    public boolean updateBook(BookModel book) {
        System.out.println("BookDAO: Updating existing book in database...");
        String sql = "UPDATE books SET category_id=?, name=?, description=?, price=?, photo=?, qty=? WHERE id=?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, book.getCategoryId());
            stmt.setString(2, book.getName());
            stmt.setString(3, book.getDescription());
            stmt.setDouble(4, book.getPrice());
            stmt.setString(5, book.getPhoto());
            stmt.setInt(6, book.getQty());
            stmt.setInt(7, book.getId());

            System.out.println("BookDAO: Successfully connected to database");
            System.out.println("BookDAO: Updating book - ID: " + book.getId() + 
                               ", Name: " + book.getName() + 
                               ", Qty: " + book.getQty());
            int rowsAffected = stmt.executeUpdate();
            System.out.println("BookDAO: Update result: " + rowsAffected + " rows affected");
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("BookDAO: Error executing query: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to update book in database", e);
        } catch (Exception e) {
            System.err.println("BookDAO: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Unexpected error in BookDAO", e);
        }
    }

    public boolean deleteBook(int id) {
        System.out.println("BookDAO: Deleting book from database...");
        String sql = "DELETE FROM books WHERE id=?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            System.out.println("BookDAO: Successfully connected to database");
            System.out.println("BookDAO: Deleting book - ID: " + id);
            int rowsAffected = stmt.executeUpdate();
            System.out.println("BookDAO: Deletion result: " + rowsAffected + " rows affected");
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("BookDAO: Error executing query: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to delete book from database", e);
        } catch (Exception e) {
            System.err.println("BookDAO: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Unexpected error in BookDAO", e);
        }
    }

    public BookModel getBookById(int id) {
        System.out.println("BookDAO: Getting book by ID from database...");
        String sql = "SELECT * FROM books WHERE id=?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            System.out.println("BookDAO: Successfully connected to database");
            System.out.println("BookDAO: Retrieving book - ID: " + id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    BookModel book = new BookModel(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("photo"),
                        rs.getInt("qty")
                    );
                    System.out.println("BookDAO: Found book - ID: " + book.getId() + 
                                   ", Name: " + book.getName() + 
                                   ", Qty: " + book.getQty());
                    return book;
                } else {
                    System.out.println("BookDAO: No book found with ID: " + id);
                }
            }
        } catch (SQLException e) {
            System.err.println("BookDAO: Error executing query: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve book from database", e);
        } catch (Exception e) {
            System.err.println("BookDAO: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Unexpected error in BookDAO", e);
        }
        return null;
    }

    public Object[] getTopSellingBook() {
        System.out.println("BookDAO: Getting top selling book...");
        String sql = "SELECT b.id, b.name, b.price, b.photo, SUM(bi.quantity) as total_sold " +
                "FROM books b " +
                "JOIN bill_items bi ON b.id = bi.book_id " +
                "GROUP BY b.id, b.name, b.price, b.photo " +
                "ORDER BY total_sold DESC " +
                "LIMIT 1";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            System.out.println("BookDAO: Successfully connected to database");

            if (rs.next()) {
                Object[] result = new Object[5];
                result[0] = rs.getInt("id");
                result[1] = rs.getString("name");
                result[2] = rs.getDouble("price");
                result[3] = rs.getString("photo");
                result[4] = rs.getInt("total_sold");

                System.out.println("BookDAO: Found top selling book: " + result[1]);
                return result;
            } else {
                System.out.println("BookDAO: No sales data found, returning default values");
                // Return an array with default values when no sales data exists
                Object[] defaultResult = new Object[5];
                defaultResult[1] = "No sales data";  // name
                defaultResult[4] = 0;  // total_sold
                return defaultResult;
            }

        } catch (SQLException e) {
            System.err.println("BookDAO: Error executing query: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to retrieve top selling book", e);
        } catch (Exception e) {
            System.err.println("BookDAO: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Unexpected error in BookDAO", e);
        }
    }
}
