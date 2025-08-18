<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="src.business.bill.dto.BillDto" %>
<%@ page import="src.business.bill.service.BillService" %>

<%
  BillService billService = new BillService();

  String filter = request.getParameter("filter");
  String customDate = request.getParameter("date");

  List<BillDto> allBills = billService.getAllBills();
  List<BillDto> bills = new ArrayList<>();

  String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

  if ("today".equals(filter)) {
    for (BillDto b : allBills) {
      if (b.getDate() != null && b.getDate().startsWith(today)) {
        bills.add(b);
      }
    }
  } else if ("date".equals(filter) && customDate != null && !customDate.isEmpty()) {
    for (BillDto b : allBills) {
      if (b.getDate() != null && b.getDate().startsWith(customDate)) {
        bills.add(b);
      }
    }
  } else {
    bills = allBills;
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bill Reports - Pahana Edu</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/bootstrap.min.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <script src="<%=request.getContextPath()%>/assets/jquery.min.js"></script>
  <script src="<%=request.getContextPath()%>/assets/bootstrap.bundle.min.js"></script>
  <style>
    :root {
      --primary-blue: #3b82f6;
      --light-blue: #dbeafe;
      --sky-blue: #0ea5e9;
      --blue-50: #eff6ff;
      --blue-100: #dbeafe;
      --blue-500: #3b82f6;
      --blue-600: #2563eb;
      --blue-700: #1d4ed8;
      --gray-50: #f9fafb;
      --gray-100: #f3f4f6;
      --gray-200: #e5e7eb;
      --gray-300: #d1d5db;
      --gray-500: #6b7280;
      --gray-600: #4b5563;
      --gray-700: #374151;
      --gray-800: #1f2937;
      --gray-900: #111827;
      --success: #10b981;
      --warning: #f59e0b;
      --danger: #ef4444;
      --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
      --shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
      --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
      --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
      --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
    }

    * {
      box-sizing: border-box;
    }

    body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: linear-gradient(135deg, var(--blue-50) 0%, var(--gray-50) 100%);
      color: var(--gray-700);
      line-height: 1.6;
      margin: 0;
      min-height: 100vh;
    }

    .main-container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 2rem 1rem;
    }

    /* Header Section */
    .page-header {
      background: white;
      border-radius: 20px;
      padding: 2rem;
      margin-bottom: 2rem;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--gray-100);
    }

    .page-title {
      font-size: 2rem;
      font-weight: 700;
      color: var(--gray-900);
      margin: 0;
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .page-title .icon {
      width: 48px;
      height: 48px;
      background: linear-gradient(135deg, var(--blue-500), var(--sky-blue));
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 1.25rem;
    }

    .page-subtitle {
      color: var(--gray-500);
      font-size: 0.95rem;
      margin-top: 0.5rem;
      font-weight: 500;
    }

    /* Stats Cards */
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 1.5rem;
      margin-bottom: 2rem;
    }

    .stat-card {
      background: white;
      border-radius: 16px;
      padding: 1.75rem;
      box-shadow: var(--shadow);
      border: 1px solid var(--gray-100);
      position: relative;
      overflow: hidden;
      transition: all 0.3s ease;
    }

    .stat-card:hover {
      box-shadow: var(--shadow-lg);
      transform: translateY(-2px);
    }

    .stat-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: linear-gradient(90deg, var(--blue-500), var(--sky-blue));
    }

    .stat-content {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .stat-info h3 {
      font-size: 1.875rem;
      font-weight: 700;
      color: var(--gray-900);
      margin: 0;
      line-height: 1.2;
    }

    .stat-info p {
      color: var(--gray-500);
      font-size: 0.875rem;
      font-weight: 500;
      margin: 0.25rem 0 0 0;
      text-transform: uppercase;
      letter-spacing: 0.025em;
    }

    .stat-icon {
      width: 64px;
      height: 64px;
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
      color: white;
    }

    .stat-icon.total {
      background: linear-gradient(135deg, var(--blue-500), var(--blue-600));
    }

    .stat-icon.paid {
      background: linear-gradient(135deg, var(--success), #059669);
    }

    .stat-icon.balance {
      background: linear-gradient(135deg, var(--warning), #d97706);
    }

    /* Filter Section */
    .filter-section {
      background: white;
      border-radius: 16px;
      padding: 1.75rem;
      margin-bottom: 2rem;
      box-shadow: var(--shadow);
      border: 1px solid var(--gray-100);
    }

    .filter-title {
      font-size: 1.125rem;
      font-weight: 600;
      color: var(--gray-900);
      margin-bottom: 1.5rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .form-control, .form-select {
      border: 1px solid var(--gray-300);
      border-radius: 10px;
      padding: 0.75rem 1rem;
      font-size: 0.875rem;
      font-weight: 500;
      transition: all 0.2s ease;
      background: white;
    }

    .form-control:focus, .form-select:focus {
      border-color: var(--blue-500);
      box-shadow: 0 0 0 3px var(--blue-100);
      outline: none;
    }

    .btn {
      font-weight: 500;
      border-radius: 10px;
      padding: 0.75rem 1.5rem;
      transition: all 0.2s ease;
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      font-size: 0.875rem;
      border: none;
    }

    .btn-primary {
      background: linear-gradient(135deg, var(--blue-500), var(--blue-600));
      color: white;
    }

    .btn-primary:hover {
      background: linear-gradient(135deg, var(--blue-600), var(--blue-700));
      transform: translateY(-1px);
      box-shadow: var(--shadow-md);
    }

    .btn-outline-secondary {
      border: 1px solid var(--gray-300);
      color: var(--gray-600);
      background: white;
    }

    .btn-outline-secondary:hover {
      background: var(--gray-50);
      border-color: var(--gray-400);
      color: var(--gray-700);
    }

    /* Table Section */
    .table-section {
      background: white;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: var(--shadow);
      border: 1px solid var(--gray-100);
    }

    .table-header {
      background: linear-gradient(135deg, var(--blue-500), var(--blue-600));
      color: white;
      padding: 1.5rem 2rem;
      border-bottom: 1px solid var(--blue-600);
    }

    .table-header h5 {
      margin: 0;
      font-size: 1.125rem;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .table-responsive {
      border-radius: 0 0 16px 16px;
      overflow: hidden;
    }

    .table {
      margin: 0;
      border-collapse: separate;
      border-spacing: 0;
    }

    .table thead th {
      background: var(--gray-50);
      border: none;
      padding: 1rem 1.5rem;
      font-weight: 600;
      font-size: 0.8rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--gray-700);
      border-bottom: 1px solid var(--gray-200);
    }

    .table tbody tr {
      transition: all 0.2s ease;
      border: none;
    }

    .table tbody tr:hover {
      background: var(--blue-50);
    }

    .table tbody td {
      padding: 1.25rem 1.5rem;
      border: none;
      border-bottom: 1px solid var(--gray-100);
      font-size: 0.875rem;
      vertical-align: middle;
    }

    .table tbody tr:last-child td {
      border-bottom: none;
    }

    .bill-id {
      font-weight: 600;
      color: var(--blue-600);
      font-family: 'Monaco', 'Menlo', monospace;
    }

    .user-badge, .staff-badge {
      background: var(--gray-100);
      color: var(--gray-600);
      padding: 0.25rem 0.75rem;
      border-radius: 20px;
      font-size: 0.75rem;
      font-weight: 500;
      text-transform: uppercase;
      letter-spacing: 0.025em;
    }

    .amount {
      font-weight: 600;
      font-family: 'Monaco', 'Menlo', monospace;
    }

    .amount.positive {
      color: var(--success);
    }

    .amount.negative {
      color: var(--danger);
    }

    .status-badge {
      padding: 0.5rem 1rem;
      border-radius: 20px;
      font-size: 0.75rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.025em;
      display: inline-flex;
      align-items: center;
      gap: 0.375rem;
    }

    .status-paid {
      background: #ecfdf5;
      color: #065f46;
    }

    .status-pending {
      background: #fef3c7;
      color: #92400e;
    }

    .action-buttons {
      display: flex;
      gap: 0.5rem;
    }

    .btn-action {
      width: 36px;
      height: 36px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 0.875rem;
      transition: all 0.2s ease;
      border: 1px solid var(--gray-200);
      background: white;
      color: var(--gray-600);
    }

    .btn-action:hover {
      background: var(--blue-50);
      border-color: var(--blue-300);
      color: var(--blue-600);
      transform: translateY(-1px);
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 4rem 2rem;
      color: var(--gray-500);
    }

    .empty-state i {
      font-size: 4rem;
      margin-bottom: 1rem;
      color: var(--gray-300);
    }

    .empty-state h6 {
      font-size: 1.125rem;
      font-weight: 600;
      color: var(--gray-600);
      margin-bottom: 0.5rem;
    }

    .empty-state p {
      font-size: 0.875rem;
      margin: 0;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .main-container {
        padding: 1rem;
      }

      .page-header {
        padding: 1.5rem;
      }

      .page-title {
        font-size: 1.5rem;
      }

      .stats-grid {
        grid-template-columns: 1fr;
      }

      .stat-card {
        padding: 1.25rem;
      }

      .filter-section {
        padding: 1.25rem;
      }

      .table thead th,
      .table tbody td {
        padding: 0.75rem 1rem;
      }

      .table-header {
        padding: 1.25rem 1.5rem;
      }
    }

    /* Print Styles */
    @media print {
      body {
        background: white;
      }

      .filter-section {
        display: none;
      }

      .action-buttons {
        display: none;
      }

      .table-section {
        box-shadow: none;
        border: 1px solid #ccc;
      }
    }
  </style>
</head>
<body>
<div class="main-container">
  <jsp:include page="sidebar.jsp" />
  <!-- Page Header -->
  <div class="page-header">
    <div class="d-flex justify-content-between align-items-start">
      <div>
        <h1 class="page-title">
          <div class="icon">
            <i class="fas fa-receipt"></i>
          </div>
          Bill Reports
        </h1>
        <p class="page-subtitle">
          <i class="far fa-calendar-alt me-1"></i>
          <%= new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new Date()) %>
        </p>
      </div>
      <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary" onclick="location.reload()">
          <i class="fas fa-sync-alt"></i>
          Refresh
        </button>
        <button class="btn btn-primary" onclick="window.print()">
          <i class="fas fa-print"></i>
          Print Report
        </button>
      </div>
    </div>
  </div>

  <!-- Statistics Cards -->
  <div class="stats-grid">
    <%
      double totalAmount = bills.stream().mapToDouble(BillDto::getTotal).sum();
      double totalPaid = bills.stream().mapToDouble(BillDto::getPaid).sum();
      double totalBalance = bills.stream().mapToDouble(BillDto::getBalance).sum();
    %>
    <div class="stat-card">
      <div class="stat-content">
        <div class="stat-info">
          <h3>Rs. <%= String.format("%.2f", totalAmount) %></h3>
          <p>Total Amount</p>
        </div>
        <div class="stat-icon total">
          <i class="fas fa-money-bill-wave"></i>
        </div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-content">
        <div class="stat-info">
          <h3>Rs. <%= String.format("%.2f", totalPaid) %></h3>
          <p>Total Paid</p>
        </div>
        <div class="stat-icon paid">
          <i class="fas fa-check-circle"></i>
        </div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-content">
        <div class="stat-info">
          <h3>Rs. <%= String.format("%.2f", totalBalance) %></h3>
          <p>Outstanding Balance</p>
        </div>
        <div class="stat-icon balance">
          <i class="fas fa-clock"></i>
        </div>
      </div>
    </div>
  </div>

  <!-- Filter Section -->
  <div class="filter-section">
    <h6 class="filter-title">
      <i class="fas fa-filter"></i>
      Filter Options
    </h6>
    <form method="get" class="row g-3 align-items-end">
      <div class="col-md-3">
        <label class="form-label">Filter By</label>
        <select name="filter" class="form-select" onchange="toggleDateFilter(); this.form.submit()">
          <option value="">All Bills</option>
          <option value="today" <%= "today".equals(filter) ? "selected" : "" %>>Today's Bills</option>
          <option value="date" <%= "date".equals(filter) ? "selected" : "" %>>By Date</option>
        </select>
      </div>
      <div class="col-md-3" id="dateFilter" style="display: <%= "date".equals(filter) ? "block" : "none" %>">
        <label class="form-label">Select Date</label>
        <input type="date" name="date" value="<%= customDate != null ? customDate : "" %>"
               class="form-control" onchange="this.form.submit()">
      </div>
      <div class="col-md-6 d-flex gap-2 justify-content-md-end">
        <a href="bill-report.jsp" class="btn btn-outline-secondary">
          <i class="fas fa-times"></i>
          Clear Filters
        </a>
        <button type="button" class="btn btn-primary" onclick="exportData()">
          <i class="fas fa-download"></i>
          Export
        </button>
      </div>
    </form>
  </div>

  <!-- Bills Table -->
  <div class="table-section">
    <div class="table-header">
      <h5>
        <i class="fas fa-list-ul"></i>
        Bill Records (<%= bills.size() %> entries)
      </h5>
    </div>
    <div class="table-responsive">
      <table class="table align-middle">
        <thead>
        <tr>
          <th>Bill ID</th>
          <th>Date</th>
          <th>Customer</th>
          <th>Staff</th>
          <th class="text-end">Total</th>
          <th class="text-end">Paid</th>
          <th class="text-end">Balance</th>
          <th class="text-center">Status</th>
          <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <% if (bills.isEmpty()) { %>
        <tr>
          <td colspan="9">
            <div class="empty-state">
              <i class="fas fa-receipt"></i>
              <h6>No Bills Found</h6>
              <p>There are no bills matching your current filter criteria.</p>
            </div>
          </td>
        </tr>
        <% } else {
          for (BillDto b : bills) {
            String statusClass = b.getBalance() <= 0 ? "status-paid" : "status-pending";
            String statusText = b.getBalance() <= 0 ? "Paid" : "Pending";
            String balanceClass = b.getBalance() > 0 ? "negative" : "positive";
        %>
        <tr>
          <td><span class="bill-id">#<%= b.getId() %></span></td>
          <td><%= new SimpleDateFormat("MMM dd, yyyy").format(new SimpleDateFormat("yyyy-MM-dd").parse(b.getDate())) %></td>
          <td><span class="user-badge">USER-<%= b.getUserId() %></span></td>
          <td><span class="staff-badge">STAFF-<%= b.getStaffId() %></span></td>
          <td class="text-end"><span class="amount">Rs. <%= String.format("%.2f", b.getTotal()) %></span></td>
          <td class="text-end"><span class="amount positive">Rs. <%= String.format("%.2f", b.getPaid()) %></span></td>
          <td class="text-end"><span class="amount <%= balanceClass %>">Rs. <%= String.format("%.2f", b.getBalance()) %></span></td>
          <td class="text-center">
              <span class="status-badge <%= statusClass %>">
                <i class="<%= b.getBalance() <= 0 ? "fas fa-check-circle" : "fas fa-clock" %>"></i>
                <%= statusText %>
              </span>
          </td>
          <td class="text-center">
            <div class="action-buttons">
              <button class="btn-action" title="View Details"
                      data-bs-toggle="modal"
                      data-bs-target="#billDetailsModal"
                      data-bill-id="<%= b.getId() %>">
                <i class="fas fa-eye"></i>
              </button>
              <button class="btn-action" title="Print Bill" onclick="printBill(<%= b.getId() %>)">
                <i class="fas fa-print"></i>
              </button>
            </div>
          </td>
        </tr>
        <% }} %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script>
  function toggleDateFilter() {
    const filterSelect = document.querySelector('select[name="filter"]');
    const dateFilter = document.getElementById('dateFilter');

    if (filterSelect.value === 'date') {
      dateFilter.style.display = 'block';
    } else {
      dateFilter.style.display = 'none';
    }
  }

  function printBill(billId) {
    // Add your print bill logic here
    console.log('Printing bill:', billId);
  }

  function exportData() {
    // Add your export logic here
    console.log('Exporting data...');
  }

  // Initialize on page load
  document.addEventListener('DOMContentLoaded', function() {
    toggleDateFilter();
  });
</script>
</body>
</html>