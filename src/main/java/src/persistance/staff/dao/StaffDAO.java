package src.persistance.staff.dao;

import src.business.staff.model.StaffModel;
import src.persistance.dbconnection.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {

    public boolean insertStaff(StaffModel staff) {
        String sql = "INSERT INTO staff (username, email, password, user_type) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, staff.getUsername());
            stmt.setString(2, staff.getEmail());
            stmt.setString(3, staff.getPassword()); // store hashed password ideally
            stmt.setString(4, staff.getUser_type());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public StaffModel authenticate(String email, String password) {
        String sql = "SELECT * FROM staff WHERE email=? AND password=?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                StaffModel staff = new StaffModel();
                staff.setId(rs.getInt("id"));
                staff.setUsername(rs.getString("username"));
                staff.setEmail(rs.getString("email"));
                staff.setUser_type(rs.getString("user_type"));
                return staff;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public StaffModel findByEmail(String email) {
        String sql = "SELECT * FROM staff WHERE email=?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                StaffModel staff = new StaffModel();
                staff.setId(rs.getInt("id"));
                staff.setUsername(rs.getString("username"));
                staff.setEmail(rs.getString("email"));
                staff.setPassword(rs.getString("password")); // hashed password
                staff.setUser_type(rs.getString("user_type"));
                return staff;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getTotalStaffCount() {
        String sql = "SELECT COUNT(*) AS total FROM staff";
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean doesEmailExist(String email) {
        String sql = "SELECT COUNT(*) AS count FROM staff WHERE email = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            return false;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<StaffModel> getAllStaff() {
        List<StaffModel> staffList = new ArrayList<>();
        String sql = "SELECT id, username, email, user_type FROM staff";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                StaffModel staff = new StaffModel();
                staff.setId(rs.getInt("id"));
                staff.setUsername(rs.getString("username"));
                staff.setEmail(rs.getString("email"));
                staff.setUser_type(rs.getString("user_type"));
                staffList.add(staff);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return staffList;
    }
    
    public boolean updateStaff(StaffModel staff) {
        String sql;
        if (staff.getPassword() != null && !staff.getPassword().isEmpty()) {
            sql = "UPDATE staff SET username = ?, email = ?, password = ?, user_type = ? WHERE id = ?";
        } else {
            sql = "UPDATE staff SET username = ?, email = ?, user_type = ? WHERE id = ?";
        }
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            int paramIndex = 1;
            stmt.setString(paramIndex++, staff.getUsername());
            stmt.setString(paramIndex++, staff.getEmail());
            
            if (staff.getPassword() != null && !staff.getPassword().isEmpty()) {
                stmt.setString(paramIndex++, staff.getPassword());
            }
            
            stmt.setString(paramIndex++, staff.getUser_type());
            stmt.setInt(paramIndex, staff.getId());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteStaff(int id) {
        String sql = "DELETE FROM staff WHERE id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public StaffModel getStaffById(int id) {
        String sql = "SELECT id, username, email, user_type FROM staff WHERE id = ?";
        
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                StaffModel staff = new StaffModel();
                staff.setId(rs.getInt("id"));
                staff.setUsername(rs.getString("username"));
                staff.setEmail(rs.getString("email"));
                staff.setUser_type(rs.getString("user_type"));
                return staff;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}
