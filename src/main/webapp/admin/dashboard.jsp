<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #f8f9fa;
            --card-hover: #f1f8ff;
        }
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            min-height: 100vh;
            background: #2c3e50;
            color: white;
            padding: 20px 0;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            margin: 5px 15px;
            border-radius: 5px;
            padding: 10px 15px;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }
        .sidebar .nav-link i {
            margin-right: 10px;
        }
        .main-content {
            padding: 30px;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s, box-shadow 0.3s;
            margin-bottom: 25px;
            height: 100%;
            background: white;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
        }
        .card-body {
            padding: 25px;
        }
        .card-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 15px;
        }
        .card-title {
            font-size: 1rem;
            color: #6c757d;
            margin-bottom: 10px;
            font-weight: 500;
        }
        .card-value {
            font-size: 1.8rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 10px 0;
        }
        .card-description {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        .header {
            background: white;
            padding: 15px 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        .welcome-text h1 {
            font-size: 1.8rem;
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
        }
        .welcome-text p {
            color: #7f8c8d;
            margin: 5px 0 0 0;
        }
        .loading {
            opacity: 0.7;
            pointer-events: none;
        }
        .stat-card {
            border-left: 4px solid var(--primary-color);
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-2 sidebar">
            <div class="text-center mb-4">
                <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Bookshop Logo" class="mb-2" style="max-width: 120px; height: auto;">
                <h4>Pahana Edu</h4>
                <p class="text-muted">Admin Panel</p>
            </div>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/addstaff.jsp">
                        <i class="bi bi-people"></i> Register Staff
                    </a>
                </li>

                <li class="nav-item mt-4">
                    <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout.jsp">
                        <i class="bi bi-box-arrow-right"></i> Logout
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 main-content">
            <!-- Header -->
            <div class="header d-flex justify-content-between align-items-center">
                <div class="welcome-text">
                    <h1>Dashboard</h1>
                    <p>Welcome back, Admin</p>
                </div>
                <div class="date-display">
                    <span id="currentDate" class="text-muted"></span>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div id="dashboardContent">
                <!-- Loading Indicator -->
                <div id="loadingIndicator" class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-2">Loading dashboard data...</p>
                </div>

                <!-- Dashboard Cards -->
                <div id="dashboardCards" style="display: none;">
                    <div class="row">
                        <!-- Bills Printed Today -->
                        <div class="col-md-6 col-lg-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="card-title text-uppercase">Bills Today</h6>
                                            <h2 id="billsToday" class="card-value">0</h2>
                                        </div>
                                        <div class="card-icon">
                                            <i class="bi bi-receipt"></i>
                                        </div>
                                    </div>
                                    <p class="card-description mb-0">Total bills printed today</p>
                                </div>
                            </div>
                        </div>

                        <!-- Total Sales Today -->
                        <div class="col-md-6 col-lg-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="card-title text-uppercase">Today's Sales</h6>
                                            <h2 id="salesToday" class="card-value">Rs. 0.00</h2>
                                        </div>
                                        <div class="card-icon">
                                            <i class="bi bi-cash-stack"></i>
                                        </div>
                                    </div>
                                    <p class="card-description mb-0">Total sales amount for today</p>
                                </div>
                            </div>
                        </div>

                        <!-- Top Selling Book -->
                        <div class="col-md-6 col-lg-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="card-title text-uppercase">Top Selling Book</h6>
                                            <h3 id="topBookTitle" class="card-value" style="font-size: 1.5rem;">-</h3>
                                            <p class="mb-0"><span id="topBookQty" class="fw-bold">0</span> sold</p>
                                        </div>
                                        <div class="card-icon">
                                            <i class="bi bi-trophy"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Total Books -->
                        <div class="col-md-6 col-lg-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="card-title text-uppercase">Total Books</h6>
                                            <h2 id="totalBooks" class="card-value">0</h2>
                                        </div>
                                        <div class="card-icon">
                                            <i class="bi bi-book"></i>
                                        </div>
                                    </div>
                                    <p class="card-description mb-0">Books in the system</p>
                                </div>
                            </div>
                        </div>

                        <!-- Total Customers -->
                        <div class="col-md-6 col-lg-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="card-title text-uppercase">Total Customers</h6>
                                            <h2 id="totalCustomers" class="card-value">0</h2>
                                        </div>
                                        <div class="card-icon">
                                            <i class="bi bi-people"></i>
                                        </div>
                                    </div>
                                    <p class="card-description mb-0">Registered customers</p>
                                </div>
                            </div>
                        </div>

                        <!-- Total Staff -->
                        <div class="col-md-6 col-lg-4">
                            <div class="card stat-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="card-title text-uppercase">Total Staff</h6>
                                            <h2 id="totalStaff" class="card-value">0</h2>
                                        </div>
                                        <div class="card-icon">
                                            <i class="bi bi-person-badge"></i>
                                        </div>
                                    </div>
                                    <p class="card-description mb-0">Staff members</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Set current date
    function updateCurrentDate() {
        const options = {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        };
        const now = new Date();
        document.getElementById('currentDate').textContent = now.toLocaleDateString('en-US', options);
    }

    // Format number with commas
    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    // Format currency
    function formatCurrency(amount) {
        return 'Rs. ' + parseFloat(amount).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
    }

    // Load dashboard data
    function loadDashboardData() {
        fetch('${pageContext.request.contextPath}/admin/dashboard/stats')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                // Update UI with data
                document.getElementById('billsToday').textContent = formatNumber(data.totalBillsToday);
                document.getElementById('salesToday').textContent = formatCurrency(data.totalSalesToday);
                document.getElementById('topBookTitle').textContent = data.topSellingBookTitle || 'N/A';
                document.getElementById('topBookQty').textContent = data.topSellingBookQty;
                document.getElementById('totalBooks').textContent = formatNumber(data.totalBooks);
                document.getElementById('totalCustomers').textContent = formatNumber(data.totalCustomers);
                document.getElementById('totalStaff').textContent = formatNumber(data.totalStaff);

                // Hide loading indicator and show content
                document.getElementById('loadingIndicator').style.display = 'none';
                document.getElementById('dashboardCards').style.display = 'block';
            })
            .catch(error => {
                console.error('Error loading dashboard data:', error);
                document.getElementById('loadingIndicator').innerHTML = `
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        Failed to load dashboard data. Please try again later.
                    </div>
                    <button class="btn btn-primary mt-2" onclick="loadDashboardData()">
                        <i class="bi bi-arrow-clockwise me-2"></i>Retry
                    </button>
                `;
            });
    }

    // Initialize dashboard when page loads
    document.addEventListener('DOMContentLoaded', function() {
        updateCurrentDate();
        loadDashboardData();
    });
</script>
</body>
</html>