package src.persistance.staff.dao;

import src.business.staff.model.StaffModel;
import src.persistance.dbconnection.DBConnection;

import java.sql.*;

public class StaffDAO {

    public boolean insertStaff(StaffModel staff) {
        String sql = "INSERT INTO staff (username, email, password, user_type) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

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

}

