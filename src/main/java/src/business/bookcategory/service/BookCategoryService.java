package src.business.bookcategory.service;

import src.business.bookcategory.dto.BookCategoryDto;
import src.business.bookcategory.mapper.BookCategoryMapper;
import src.persistance.bookcategory.dao.BookCategoryDAO;

import java.util.List;
import java.util.stream.Collectors;

public class BookCategoryService {
    private BookCategoryDAO categoryDAO;

    public BookCategoryService() {
        this.categoryDAO = new BookCategoryDAO();
    }

    public boolean addCategory(BookCategoryDto dto) {
        return categoryDAO.insertCategory(BookCategoryMapper.toModel(dto));
    }

    public List<BookCategoryDto> getAllCategories() {
        return categoryDAO.getAllCategories().stream()
                .map(BookCategoryMapper::toDto)
                .collect(Collectors.toList());
    }

    public boolean updateCategory(BookCategoryDto dto) {
        return categoryDAO.updateCategory(BookCategoryMapper.toModel(dto));
    }

    public boolean deleteCategory(int id) {
        return categoryDAO.deleteCategory(id);
    }
}
