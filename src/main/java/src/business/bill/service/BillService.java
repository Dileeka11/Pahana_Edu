package src.business.bill.service;

import src.business.bill.dto.BillDto;
import src.business.bill.mapper.BillMapper;
import src.persistance.bill.dao.BillDAO;

import java.util.List;
import java.util.stream.Collectors;

public class BillService {
    private BillDAO billDAO;

    public BillService() {
        this.billDAO = new BillDAO();
    }

    public int createBill(BillDto dto) {
        return billDAO.insertBill(BillMapper.toModel(dto));
    }

    public List<BillDto> getAllBills() {
        return billDAO.getAllBills().stream()
                .map(BillMapper::toDto)
                .collect(Collectors.toList());
    }
}
