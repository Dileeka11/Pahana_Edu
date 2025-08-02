<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
</head>
<body>
<h2>User Registration</h2>
<form action="register" method="post">
    <label>Account Number:</label>
    <input type="text" name="account_number" required><br><br>

    <label>Name:</label>
    <input type="text" name="name" required><br><br>

    <label>Address:</label>
    <input type="text" name="address" required><br><br>

    <label>Telephone:</label>
    <input type="text" name="telephone" required><br><br>

    <label>Email:</label>
    <input type="email" name="email" required><br><br>

    <button type="submit">Register</button>
</form>
</body>
</html>
