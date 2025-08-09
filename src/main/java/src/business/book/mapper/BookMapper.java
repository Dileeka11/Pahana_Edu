package src.business.book.mapper;

import src.business.book.dto.BookDto;
import src.business.book.model.BookModel;

public class BookMapper {
    public static BookModel toModel(BookDto dto) {
        return new BookModel(dto.getId(), dto.getCategoryId(), dto.getName(),
                dto.getDescription(), dto.getPrice(), dto.getPhoto(), dto.getQty());
    }

    public static BookDto toDto(BookModel model) {
        return new BookDto(model.getId(), model.getCategoryId(), model.getName(),
                model.getDescription(), model.getPrice(), model.getPhoto(), model.getQty());
    }
}
