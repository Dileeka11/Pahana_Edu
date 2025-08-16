package src.persistance.bill.dao;

import src.business.bill.model.BillModel;
import src.persistance.dbconnection.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    public int insertBill(BillModel bill) {
        String sql = "INSERT INTO bill (user_id, staff_id, discount, qty, total, amount_paid, balance, change_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, bill.getUserId());
            stmt.setInt(2, bill.getStaffId());
            stmt.setDouble(3, bill.getDiscount());
            stmt.setInt(4, bill.getQty());
            stmt.setDouble(5, bill.getTotal());
            stmt.setDouble(6, bill.getPaid());
            stmt.setDouble(7, bill.getBalance());
            stmt.setDouble(8, bill.getChange());

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Return bill_id
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    public List<BillModel> getAllBills() {
        List<BillModel> list = new ArrayList<>();
        String sql = "SELECT * FROM bill ORDER BY date DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                BillModel bill = new BillModel();
                bill.setId(rs.getInt("id"));
                bill.setUserId(rs.getInt("user_id"));
                bill.setStaffId(rs.getInt("staff_id"));
                bill.setDate(rs.getString("date"));
                bill.setDiscount(rs.getDouble("discount"));
                bill.setQty(rs.getInt("qty"));
                bill.setTotal(rs.getDouble("total"));
                bill.setPaid(rs.getDouble("amount_paid"));
                bill.setBalance(rs.getDouble("balance"));
                try {
                    bill.setChange(rs.getDouble("change_amount"));
                } catch (SQLException ignored) {
                    // Backward compatibility if column doesn't exist yet
                    bill.setChange(0.0);
                }
                list.add(bill);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countBillsForDate(String date) {
        String sql = "SELECT COUNT(*) as count FROM bill WHERE DATE(date) = ?";
        int count = 0;
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, date);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("count");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return count;
    }

    public double getTotalSalesForDate(String date) {
        String sql = "SELECT COALESCE(SUM(total), 0) as total_sales FROM bill WHERE DATE(date) = ?";
        double totalSales = 0.0;
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, date);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    totalSales = rs.getDouble("total_sales");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return totalSales;
    }
}
