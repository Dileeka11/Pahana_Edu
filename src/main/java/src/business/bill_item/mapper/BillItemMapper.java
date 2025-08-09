package src.business.bill_item.mapper;

import src.business.bill_item.dto.BillItemDto;
import src.business.bill_item.model.BillItemModel;

public class BillItemMapper {

    public static BillItemModel toModel(BillItemDto dto) {
        return new BillItemModel(dto.getId(), dto.getBillId(), dto.getBookId());
    }

    public static BillItemDto toDto(BillItemModel model) {
        return new BillItemDto(model.getId(), model.getBillId(), model.getBookId());
    }
}
