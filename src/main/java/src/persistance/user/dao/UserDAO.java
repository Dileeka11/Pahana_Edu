package src.persistance.user.dao;

import src.business.user.model.UserModel;
import src.persistance.dbconnection.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public int insertUser(UserModel user) {
        String sql = "INSERT INTO user (name, address, telephone, email, user_type, units_consumed) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getAddress());
            stmt.setString(3, user.getTelephone());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getUser_type());
            stmt.setInt(6, user.getUnitsConsumed());

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    int userId = rs.getInt(1);
                    String prefix = user.getUser_type().equalsIgnoreCase("staff") ? "STF00" : "CUS00";
                    String accountNumber = prefix + userId;

                    String updateSql = "UPDATE user SET account_number=? WHERE id=?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setString(1, accountNumber);
                    updateStmt.setInt(2, userId);
                    updateStmt.executeUpdate();

                    return userId;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    // Get all users
    public List<UserModel> getAllUsers() {
        List<UserModel> users = new ArrayList<>();
        String sql = "SELECT * FROM user";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                UserModel user = new UserModel(
                        rs.getInt("id"),
                        rs.getString("account_number"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("telephone"),
                        rs.getString("email"),
                        rs.getString("user_type"),
                        rs.getInt("units_consumed")
                );
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Delete user
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM user WHERE id=?";
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update user
    public boolean updateUser(UserModel user) {
        String sql = "UPDATE user SET name=?, address=?, telephone=?, email=?, user_type=?, units_consumed=? WHERE id=?";
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getAddress());
            stmt.setString(3, user.getTelephone());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getUser_type());
            stmt.setInt(6, user.getUnitsConsumed());
            stmt.setInt(7, user.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT id FROM user WHERE email=?";
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true if email exists
        } catch (SQLException e) {
            e.printStackTrace();
            return true; // treat as existing if DB error
        }
    }

    public boolean isTelephoneExists(String telephone) {
        String sql = "SELECT id FROM user WHERE telephone=?";
        try {
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, telephone);
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // true if tp exists
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    public int getLastUserId() {
        String sql = "SELECT id FROM user ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getUserIdByEmail(String email) {
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT id FROM user WHERE email=?")) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt("id");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int getUserIdByTelephone(String phone) {
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT id FROM user WHERE telephone=?")) {
            stmt.setString(1, phone);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt("id");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public UserModel findUserByEmailOrPhone(String searchTerm) {
        String sql = "SELECT * FROM user WHERE email = ? OR telephone = ? LIMIT 1";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, searchTerm);
            stmt.setString(2, searchTerm);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserModel user = new UserModel();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setTelephone(rs.getString("telephone"));
                    user.setAddress(rs.getString("address"));
                    user.setUser_type(rs.getString("user_type"));
                    user.setAccount_number(rs.getString("account_number"));
                    user.setUnitsConsumed(rs.getInt("units_consumed"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean updateUserUnitsConsumed(int userId, int unitsToAdd) {
        String sql = "UPDATE user SET units_consumed = units_consumed + ? WHERE id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, unitsToAdd);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating user's units consumed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public UserModel getUserById(int id) {
        // Use explicit columns and quote table name to avoid reserved-word issues; map by index to avoid metadata NPE
        String sql = "SELECT id, name, address, telephone, email, user_type, account_number, units_consumed FROM `user` WHERE id = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserModel user = new UserModel();
                    // Map by index to avoid ResultSetImpl.findColumn on null metadata
                    user.setId(rs.getInt(1));
                    user.setName(rs.getString(2));
                    user.setAddress(rs.getString(3));
                    user.setTelephone(rs.getString(4));
                    user.setEmail(rs.getString(5));
                    user.setUser_type(rs.getString(6));
                    user.setAccount_number(rs.getString(7));
                    user.setUnitsConsumed(rs.getInt(8));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getTotalUsersCount() {
        String sql = "SELECT COUNT(*) as total FROM user";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
