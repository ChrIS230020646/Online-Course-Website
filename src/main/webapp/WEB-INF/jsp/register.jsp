<%--
  Created by IntelliJ IDEA.
  User: s12992583
  Date: 2/4/2026
  Time: 23:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
</head>
<body>
    <h2>Create an Account</h2>
    <form action="/register" method="post">
        <div>
            <label>Username:</label>
            <input type="text" name="username" required />
        </div>
        <div>
            <label>Password:</label>
            <input type="password" name="password" required />
        </div>
        <div>
            <label>Role:</label>
            <select name="role">
                <option value="ROLE_STUDENT">Student</option>
                <option value="ROLE_TEACHER">Teacher</option>
            </select>
        </div>
        <button type="submit">Register</button>
    </form>
    <p><a href="/">Back to Home</a></p>
</body>
</html>

