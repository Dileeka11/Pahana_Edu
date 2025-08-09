package src.business.bill.mapper;

import src.business.bill.dto.BillDto;
import src.business.bill.model.BillModel;

public class BillMapper {
    public static BillModel toModel(BillDto dto) {
        return new BillModel(
                dto.getId(),
                dto.getUserId(),
                dto.getStaffId(),
                dto.getDate(),
                dto.getDiscount(),
                dto.getQty(),
                dto.getTotal(),
                dto.getPaid(),
                dto.getBalance(),
                dto.getChange()
        );
    }

    public static BillDto toDto(BillModel model) {
        return new BillDto(
                model.getId(),
                model.getUserId(),
                model.getStaffId(),
                model.getDate(),
                model.getDiscount(),
                model.getQty(),
                model.getTotal(),
                model.getPaid(),
                model.getBalance(),
                model.getChange()
        );
    }
}
