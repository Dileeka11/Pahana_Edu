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
}

