package src.persistance.user.dao;

import src.business.user.model.UserModel;
import src.persistance.dbconnection.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserDAO {

    public boolean insertUser(UserModel user) {
        String sql = "INSERT INTO user (account_number, name, address, telephone, email) VALUES (?, ?, ?, ?, ?)";

        try {
            Connection conn = DBConnection.getInstance().getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, user.getAccount_number());
            stmt.setString(2, user.getName());
            stmt.setString(3, user.getAddress());
            stmt.setString(4, user.getTelephone());
            stmt.setString(5, user.getEmail());

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}


