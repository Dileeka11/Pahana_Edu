package src.business.book.service;

import src.business.book.dto.BookDto;
import src.business.book.mapper.BookMapper;
import src.persistance.book.dao.BookDAO;

import java.util.List;
import java.util.stream.Collectors;

public class BookService {
    private BookDAO bookDAO;

    public BookService() {
        this.bookDAO = new BookDAO();
    }

    public boolean addBook(BookDto dto) {
        return bookDAO.insertBook(BookMapper.toModel(dto));
    }

    public List<BookDto> getAllBooks() {
        return bookDAO.getAllBooks().stream()
                .map(BookMapper::toDto)
                .collect(Collectors.toList());
    }

    public boolean updateBook(BookDto dto) {
        return bookDAO.updateBook(BookMapper.toModel(dto));
    }

    public boolean deleteBook(int id) {
        return bookDAO.deleteBook(id);
    }
}
