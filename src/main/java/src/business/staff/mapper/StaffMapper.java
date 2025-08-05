package src.business.staff.mapper;

import src.business.staff.dto.Staffdto;
import src.business.staff.model.StaffModel;

public class StaffMapper {
    public static StaffModel toModel(Staffdto dto) {
        return new StaffModel(dto.getId(), dto.getUsername(), dto.getEmail(), dto.getPassword(), dto.getUser_type());
    }

    public static Staffdto toDto(StaffModel model) {
        return new Staffdto(model.getId(), model.getUsername(), model.getEmail(), model.getPassword(), model.getUser_type());
    }
}
