package src.business.bill_item.service;



import src.business.bill_item.dto.BillItemDto;
import src.business.bill_item.mapper.BillItemMapper;
import src.business.bill_item.model.BillItemModel;
import src.persistance.bill_item.dao.BillItemDAO;

import java.util.List;
import java.util.stream.Collectors;

public class BillItemService {
    private BillItemDAO billItemDAO;

    public BillItemService() {
        this.billItemDAO = new BillItemDAO();
    }

    public boolean addBillItem(BillItemDto dto) {
        return billItemDAO.insertBillItem(BillItemMapper.toModel(dto));
    }

    public boolean addBillItems(List<BillItemDto> dtoList) {
        List<BillItemModel> models = dtoList.stream()
                .map(BillItemMapper::toModel)
                .collect(Collectors.toList());

        boolean ok = billItemDAO.insertMultiple(models);
        if (!ok) {
            // Fallback: try inserting one-by-one to better surface errors on some JDBC drivers/DBs
            ok = true;
            for (BillItemModel m : models) {
                if (!billItemDAO.insertBillItem(m)) {
                    ok = false;
                    break;
                }
            }
        }
        return ok;
    }

    public List<BillItemDto> getItemsByBillId(int billId) {
        return billItemDAO.getItemsByBillId(billId).stream()
                .map(BillItemMapper::toDto)
                .collect(Collectors.toList());
    }
}
