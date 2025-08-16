package src.business.staff.service;

import src.business.staff.dto.Staffdto;
import src.business.staff.model.StaffModel;
import src.business.staff.mapper.StaffMapper;
import src.persistance.staff.dao.StaffDAO;

public class StaffService {
    private StaffDAO staffDAO;

    public StaffService() {
        this.staffDAO = new StaffDAO();
    }

    public boolean registerStaff(Staffdto staffDto) {
        StaffModel staffModel = StaffMapper.toModel(staffDto);
        return staffDAO.insertStaff(staffModel);
    }

    public Staffdto authenticateStaff(String email) {
        StaffModel staff = staffDAO.findByEmail(email);
        return staff != null ? StaffMapper.toDto(staff) : null;
    }

    // In StaffService.java
    public int getTotalStaffCount() {
        return staffDAO.getTotalStaffCount();
    }

}
