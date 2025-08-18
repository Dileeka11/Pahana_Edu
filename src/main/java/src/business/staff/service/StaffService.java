package src.business.staff.service;

import src.business.staff.dto.Staffdto;
import src.business.staff.model.StaffModel;
import src.business.staff.mapper.StaffMapper;
import src.persistance.staff.dao.StaffDAO;

import java.util.List;
import java.util.stream.Collectors;

public class StaffService {
    private StaffDAO staffDAO;
    private StaffMapper staffMapper;

    public StaffService() {
        this.staffDAO = new StaffDAO();
        this.staffMapper = new StaffMapper();
    }

    public boolean registerStaff(Staffdto staffDto) {
        StaffModel staffModel = StaffMapper.toModel(staffDto);
        return staffDAO.insertStaff(staffModel);
    }
    
    public List<Staffdto> getAllStaff() {
        return staffDAO.getAllStaff().stream()
                .map(staff -> staffMapper.toDto(staff))
                .collect(Collectors.toList());
    }
    
    public boolean updateStaff(Staffdto staffDto) {
        StaffModel staffModel = StaffMapper.toModel(staffDto);
        return staffDAO.updateStaff(staffModel);
    }
    
    public boolean deleteStaff(int id) {
        return staffDAO.deleteStaff(id);
    }
    
    public Staffdto getStaffById(int id) {
        StaffModel staff = staffDAO.getStaffById(id);
        return staff != null ? staffMapper.toDto(staff) : null;
    }

    public Staffdto authenticateStaff(String email) {
        StaffModel staff = staffDAO.findByEmail(email);
        return staff != null ? StaffMapper.toDto(staff) : null;
    }

    // In StaffService.java
    public int getTotalStaffCount() {
        return staffDAO.getTotalStaffCount();
    }
    
    public boolean doesEmailExist(String email) {
        return staffDAO.doesEmailExist(email);
    }
}
