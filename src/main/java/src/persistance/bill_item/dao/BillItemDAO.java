package src.persistance.bill_item.dao;

import src.business.bill_item.model.BillItemModel;
import src.persistance.dbconnection.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillItemDAO {

    public boolean insertBillItem(BillItemModel item) {
        String sql = "INSERT INTO bill_items (bill_id, book_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, item.getBillId());
            stmt.setInt(2, item.getBookId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertMultiple(List<BillItemModel> items) {
        String sql = "INSERT INTO bill_items (bill_id, book_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (BillItemModel item : items) {
                stmt.setInt(1, item.getBillId());
                stmt.setInt(2, item.getBookId());
                stmt.addBatch();
            }

            int[] result = stmt.executeBatch();
            // In JDBC, SUCCESS_NO_INFO (-2) is still success; only EXECUTE_FAILED (-3) indicates failure
            for (int r : result) {
                if (r == Statement.EXECUTE_FAILED) {
                    return false;
                }
            }

            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<BillItemModel> getItemsByBillId(int billId) {
        List<BillItemModel> list = new ArrayList<>();
        String sql = "SELECT * FROM bill_items WHERE bill_id = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                BillItemModel item = new BillItemModel(
                        rs.getInt("id"),
                        rs.getInt("bill_id"),
                        rs.getInt("book_id")
                );
                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
