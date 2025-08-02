package src.business.user.mapper;

import src.business.user.dto.Userdto;
import src.business.user.model.UserModel;

public class UserMapper {
    public static UserModel toModel(Userdto dto) {
        return new UserModel(dto.getId(), dto.getAccount_number(), dto.getName(),
                dto.getAddress(), dto.getTelephone(), dto.getEmail());
    }

    public static Userdto toDto(UserModel model) {
        return new Userdto(model.getId(), model.getAccount_number(), model.getName(),
                model.getAddress(), model.getTelephone(), model.getEmail());
    }
}

