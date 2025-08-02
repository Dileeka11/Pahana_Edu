package src.business.user.service;



import src.business.user.dto.Userdto;
import src.business.user.model.UserModel;
import src.business.user.mapper.UserMapper;
import src.persistance.user.dao.UserDAO;


public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public boolean registerUser(Userdto userDto) {
        UserModel userModel = UserMapper.toModel(userDto);
        return userDAO.insertUser(userModel);
    }
}

