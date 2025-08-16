package src.business.user.service;



import src.business.user.dto.Userdto;
import src.business.user.model.UserModel;
import src.business.user.mapper.UserMapper;
import src.persistance.user.dao.UserDAO;

import java.util.List;
import java.util.stream.Collectors;


public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public String registerUser(Userdto userDto) {
        if (userDto.getName() == null || userDto.getName().trim().isEmpty()
                || userDto.getAddress() == null || userDto.getAddress().trim().isEmpty()
                || userDto.getTelephone() == null || userDto.getTelephone().trim().isEmpty()
                || userDto.getEmail() == null || userDto.getEmail().trim().isEmpty()) {
            return "error:empty";
        }

        if (userDAO.isEmailExists(userDto.getEmail())) {
            return "error:email";
        }

        if (userDAO.isTelephoneExists(userDto.getTelephone())) {
            return "error:telephone";
        }

        UserModel userModel = UserMapper.toModel(userDto);
        int userId = userDAO.insertUser(userModel);

        if (userId > 0) {
            String prefix = userDto.getUser_type().equalsIgnoreCase("staff") ? "STF00" : "CUS00";
            return prefix + userId;
        }
        return null;
    }


    public List<Userdto> getAllUsers() {
        return userDAO.getAllUsers().stream()
                .map(UserMapper::toDto)
                .collect(Collectors.toList());
    }

    public boolean deleteUser(int id) {
        return userDAO.deleteUser(id);
    }

    public boolean updateUser(Userdto dto) {
        return userDAO.updateUser(UserMapper.toModel(dto));
    }

    public String generateNextAccountNumber(String userType) {
        int lastId = userDAO.getLastUserId();
        int nextId = lastId + 1;
        String prefix = userType.equalsIgnoreCase("staff") ? "STF/0" : "CUS/0";
        return prefix + nextId;
    }

    public UserModel findUserByEmailOrPhone(String searchTerm) {
        return userDAO.findUserByEmailOrPhone(searchTerm);
    }

    public boolean updateUnitsConsumed(int userId, int unitsToAdd) {
        return userDAO.updateUserUnitsConsumed(userId, unitsToAdd);
    }

    public UserModel getUserById(int id) {
        return userDAO.getUserById(id);
    }

    // In UserService.java
    public int getTotalUsersCount() {
        return userDAO.getTotalUsersCount();
    }

}
