package src.business.servlet;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfAction;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import src.business.user.model.UserModel;
import src.business.user.service.UserService;
import src.business.bill.dto.BillDto;
import src.business.bill.service.BillService;
import src.business.bill_item.dto.BillItemDto;
import src.business.bill_item.service.BillItemService;
import src.persistance.book.dao.BookDAO;
import src.business.book.model.BookModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private UserService userService;
    private BillService billService;
    private BillItemService billItemService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        billService = new BillService();
        billItemService = new BillItemService();
    }

    private void generateBillPdf(HttpServletResponse response,
                                 int billId,
                                 UserModel user,
                                 Map<Integer, Integer> cart,
                                 BookDAO bookDAO,
                                 double totalAmount,
                                 double discount,
                                 double paid,
                                 double balance,
                                 double change,
                                 int totalQty) throws IOException, DocumentException {
        response.setContentType("application/pdf");
        String filename = "bill_" + billId + ".pdf";
        response.setHeader("Content-Disposition", "inline; filename=\"" + filename + "\"");

        Document document = new Document();
        PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
        document.open();
        // Auto-open browser print dialog when the PDF opens (supported viewers)
        PdfAction js = PdfAction.javaScript("this.print({bUI:true,bSilent:false,bShrinkToFit:true});", writer);
        writer.addJavaScript(js);

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
        Font labelFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
        Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);

        // Header
        Paragraph title = new Paragraph("Sales Bill", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(new Paragraph(" "));

        // Bill and customer info
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        document.add(new Paragraph("Bill ID: " + billId, normalFont));
        document.add(new Paragraph("Date: " + sdf.format(new Date()), normalFont));
        document.add(new Paragraph("Customer: " + user.getName() + " (ID: " + user.getId() + ")", normalFont));
        document.add(new Paragraph("Email: " + user.getEmail(), normalFont));
        document.add(new Paragraph("Phone: " + user.getTelephone(), normalFont));
        document.add(new Paragraph(" "));

        // Items table
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{4f, 1f, 2f, 2f});

        PdfPCell c1 = new PdfPCell(new Phrase("Book", labelFont));
        PdfPCell c2 = new PdfPCell(new Phrase("Qty", labelFont));
        PdfPCell c3 = new PdfPCell(new Phrase("Price (Rs.)", labelFont));
        PdfPCell c4 = new PdfPCell(new Phrase("Line Total (Rs.)", labelFont));
        c1.setHorizontalAlignment(Element.ALIGN_CENTER);
        c2.setHorizontalAlignment(Element.ALIGN_CENTER);
        c3.setHorizontalAlignment(Element.ALIGN_CENTER);
        c4.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(c1);
        table.addCell(c2);
        table.addCell(c3);
        table.addCell(c4);

        for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
            int bookId = e.getKey();
            int qty = e.getValue();
            BookModel b = bookDAO.getBookById(bookId);
            if (b != null) {
                double line = b.getPrice() * qty;
                table.addCell(new Phrase(b.getName(), normalFont));
                PdfPCell qCell = new PdfPCell(new Phrase(String.valueOf(qty), normalFont));
                qCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                table.addCell(qCell);
                PdfPCell pCell = new PdfPCell(new Phrase(String.format("%.2f", b.getPrice()), normalFont));
                pCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                table.addCell(pCell);
                PdfPCell tCell = new PdfPCell(new Phrase(String.format("%.2f", line), normalFont));
                tCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                table.addCell(tCell);
            }
        }

        document.add(table);
        document.add(new Paragraph(" "));

        // Summary
        document.add(new Paragraph("Total Qty: " + totalQty, normalFont));
        document.add(new Paragraph("Subtotal: Rs. " + String.format("%.2f", totalAmount), normalFont));
        document.add(new Paragraph("Discount: Rs. " + String.format("%.2f", discount), normalFont));
        double net = Math.max(0.0, totalAmount - discount);
        document.add(new Paragraph("Net Total: Rs. " + String.format("%.2f", net), labelFont));
        document.add(new Paragraph("Paid: Rs. " + String.format("%.2f", paid), normalFont));
        document.add(new Paragraph("Balance: Rs. " + String.format("%.2f", balance), normalFont));
        document.add(new Paragraph("Change: Rs. " + String.format("%.2f", change), normalFont));

        document.close();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Try to get customerId from request first
        String customerIdParam = request.getParameter("customerId");
        Integer customerId = null;

        if (customerIdParam != null && !customerIdParam.trim().isEmpty()) {
            try {
                customerId = Integer.parseInt(customerIdParam);
            } catch (NumberFormatException ignored) { }
        }

        // If not provided, try to resolve from session currentUser
        if (customerId == null && session != null) {
            Object cu = session.getAttribute("currentUser");
            if (cu instanceof UserModel) {
                customerId = ((UserModel) cu).getId();
            }
        }

        if (customerId == null) {
            // No customer identified, redirect to user lookup
            response.sendRedirect(request.getContextPath() + "/staff/user-lookup.jsp");
            return;
        }

        // Load full user details
        UserModel user = userService.getUserById(customerId);
        if (user == null) {
            // If somehow user not found, go back to lookup
            response.sendRedirect(request.getContextPath() + "/staff/user-lookup.jsp");
            return;
        }

        // Put user in request (and session for continuity)
        request.setAttribute("user", user);
        if (session != null) {
            session.setAttribute("currentUser", user);
        }

        // Prepare cart details and totals for JSP (avoid DB calls in JSP)
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = session != null ? (Map<Integer, Integer>) session.getAttribute("cart") : null;
        if (cart == null) {
            cart = new HashMap<>();
            if (session != null) session.setAttribute("cart", cart);
        }

        BookDAO bookDAO = new BookDAO();
        Map<Integer, BookModel> bookDetails = new HashMap<>();
        double total = 0.0;
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            int bookId = entry.getKey();
            int qty = entry.getValue();
            BookModel book = bookDAO.getBookById(bookId);
            if (book != null) {
                bookDetails.put(bookId, book);
                total += book.getPrice() * qty;
            }
        }

        request.setAttribute("bookDetails", bookDetails);
        request.setAttribute("total", total);

        // Forward to JSP for rendering
        request.getRequestDispatcher("/staff/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/staff/user-lookup.jsp");
            return;
        }

        // Resolve customerId
        Integer customerId = null;
        String customerIdParam = request.getParameter("customerId");
        if (customerIdParam != null) {
            try { customerId = Integer.parseInt(customerIdParam); } catch (NumberFormatException ignored) {}
        }
        if (customerId == null) {
            Object cu = session.getAttribute("currentUser");
            if (cu instanceof UserModel) customerId = ((UserModel) cu).getId();
        }
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/staff/user-lookup.jsp");
            return;
        }

        // Staff must be logged in; staffId stored in session by LoginServlet
        Integer staffId = (Integer) session.getAttribute("staffId");
        if (staffId == null) {
            request.setAttribute("message", "Please login as staff to complete checkout.");
            doGet(request, response);
            return;
        }

        // Cart from session
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("message", "Cart is empty. Add items before checkout.");
            doGet(request, response);
            return;
        }

        // Compute totals
        BookDAO bookDAO = new BookDAO();
        int totalQty = 0;
        double totalAmount = 0.0;
        java.util.List<String> stockErrors = new java.util.ArrayList<>();
        for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
            int bookId = e.getKey();
            int qty = e.getValue();
            BookModel book = bookDAO.getBookById(bookId);
            if (book != null) {
                // Validate stock availability
                if (qty > book.getQty()) {
                    stockErrors.add("'" + book.getName() + "' (requested " + qty + ", available " + book.getQty() + ")");
                }
                totalQty += qty;
                totalAmount += book.getPrice() * qty;
            }
        }

        if (!stockErrors.isEmpty()) {
            request.setAttribute("message", "Insufficient stock for: " + String.join(", ", stockErrors));
            doGet(request, response);
            return;
        }

        // Read discount and paid from form and compute balance (amount due) and change (overpay)
        String discountParam = request.getParameter("discount");
        String paidParam = request.getParameter("paid");
        double discount = 0.0;
        double paid = 0.0;
        try { if (discountParam != null) discount = Double.parseDouble(discountParam); } catch (NumberFormatException ignored) {}
        try { if (paidParam != null) paid = Double.parseDouble(paidParam); } catch (NumberFormatException ignored) {}
        if (discount < 0) discount = 0.0;
        if (paid < 0) paid = 0.0;
        if (discount > totalAmount) discount = totalAmount; // clamp
        double net = Math.max(0.0, totalAmount - discount);
        double balance = Math.max(0.0, net - paid); // amount still due
        double change = Math.max(0.0, paid - net);  // amount to return to customer

        // Create bill
        BillDto billDto = new BillDto();
        billDto.setUserId(customerId);
        billDto.setStaffId(staffId);
        billDto.setDiscount(discount);
        billDto.setQty(totalQty);
        billDto.setTotal(totalAmount);
        billDto.setPaid(paid);
        billDto.setBalance(balance);
        billDto.setChange(change);

        int billId = billService.createBill(billDto);
        if (billId <= 0) {
            request.setAttribute("message", "Failed to create bill. Please try again.");
            doGet(request, response);
            return;
        }

        // Create bill items (one row per quantity unit)
        List<BillItemDto> items = new ArrayList<>();
        for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
            int bookId = e.getKey();
            int qty = e.getValue();
            for (int i = 0; i < qty; i++) {
                BillItemDto item = new BillItemDto();
                item.setBillId(billId);
                item.setBookId(bookId);
                items.add(item);
            }
        }

        boolean itemsOk = items.isEmpty() || billItemService.addBillItems(items);
        if (!itemsOk) {
            request.setAttribute("message", "Bill created, but adding items failed.");
        } else {
            // Decrement stock quantities for each purchased book
            boolean stockUpdated = true;
            for (Map.Entry<Integer, Integer> e : cart.entrySet()) {
                int bookId = e.getKey();
                int qty = e.getValue();
                BookModel book = bookDAO.getBookById(bookId);
                if (book != null) {
                    int newQty = Math.max(0, book.getQty() - qty);
                    book.setQty(newQty);
                    if (!bookDAO.updateBook(book)) {
                        stockUpdated = false;
                        break;
                    }
                }
            }

            if (stockUpdated) {
                // Update customer's units consumed by total quantity purchased
                boolean unitsUpdated = userService.updateUnitsConsumed(customerId, totalQty);

                if (!unitsUpdated) {
                    request.setAttribute("message", "Checkout successful. Bill ID: " + billId + ". However, updating customer's units consumed failed.");
                } else {
                    request.setAttribute("message", "Checkout successful. Bill ID: " + billId);
                }
                // Clear cart after successful checkout and stock update
                session.setAttribute("cart", new java.util.HashMap<Integer, Integer>());
            } else {
                request.setAttribute("message", "Checkout successful, but stock update failed. Please verify inventory.");
            }
        }

        // On success, generate and download PDF bill
        if (itemsOk) {
            try {
                UserModel user = userService.getUserById(customerId);
                generateBillPdf(response, billId, user, cart, bookDAO, totalAmount, discount, paid, balance, change, totalQty);
                return;
            } catch (Exception pdfEx) {
                // Fallback to UI message if PDF generation fails
                request.setAttribute("message", "Checkout successful (Bill ID: " + billId + ") but PDF generation failed: " + pdfEx.getMessage());
            }
        }

        // Reload page with user details otherwise
        doGet(request, response);
    }
}