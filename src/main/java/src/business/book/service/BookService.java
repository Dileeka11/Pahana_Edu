package src.business.book.service;

import src.business.book.dto.BookDto;
import src.business.book.mapper.BookMapper;
import src.business.book.model.BookModel;
import src.persistance.book.dao.BookDAO;

import java.util.List;
import java.util.stream.Collectors;

public class BookService {
    private BookDAO bookDAO;

    public BookService() {
        System.out.println("Initializing BookService...");
        try {
            this.bookDAO = new BookDAO();
            System.out.println("BookDAO initialized successfully");
        } catch (Exception e) {
            System.err.println("Error initializing BookDAO: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize BookService", e);
        }
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

    public BookDto getBookById(int id) {
        return BookMapper.toDto(bookDAO.getBookById(id));
    }
    
    public List<BookDto> getAllAvailableBooks() {
        System.out.println("Getting all available books...");
        try {
            List<BookDto> books = bookDAO.getAllBooks().stream()
                    .peek(book -> System.out.println("Processing book: " + book.getName() + " (ID: " + book.getId() + ", Qty: " + book.getQty() + ")"))
                    .filter(book -> book.getQty() > 0)
                    .peek(book -> System.out.println("Book has stock: " + book.getName()))
                    .map(BookMapper::toDto)
                    .peek(dto -> System.out.println("Mapped to DTO: " + dto.getName()))
                    .collect(Collectors.toList());
            
            System.out.println("Total available books: " + books.size());
            return books;
        } catch (Exception e) {
            System.err.println("Error in getAllAvailableBooks: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public boolean updateBookQty(int bookId, int quantityChange) {
        try {
            // Get the current book
            BookModel book = bookDAO.getBookById(bookId);
            if (book == null) {
                System.err.println("Book not found with ID: " + bookId);
                return false;
            }
            
            // Calculate new quantity
            int newQty = book.getQty() + quantityChange;
            if (newQty < 0) {
                System.err.println("Insufficient stock for book ID: " + bookId);
                return false;
            }
            
            // Update quantity
            book.setQty(newQty);
            return bookDAO.updateBook(book);
            
        } catch (Exception e) {
            System.err.println("Error updating book quantity: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
