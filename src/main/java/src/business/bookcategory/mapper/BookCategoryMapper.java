package src.business.bookcategory.mapper;

import src.business.bookcategory.dto.BookCategoryDto;
import src.business.bookcategory.model.BookCategoryModel;

public class BookCategoryMapper {
    public static BookCategoryModel toModel(BookCategoryDto dto) {
        return new BookCategoryModel.Builder()
                .id(dto.getId())
                .name(dto.getName())
                .description(dto.getDescription())
                .build();
    }

    public static BookCategoryDto toDto(BookCategoryModel model) {
        return new BookCategoryDto(model.getId(), model.getName(), model.getDescription());
    }
}
