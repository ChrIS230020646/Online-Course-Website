<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 2/4/2026
  Time: 23:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Create Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container d-flex flex-column align-items-center justify-content-center" style="min-height: 95vh; padding-top: 50px; padding-bottom: 50px;">
    <div style="text-align: center; margin-bottom: 30px;">
        <h1 class="page-title">Create Account</h1>
    </div>

    <div class="ui-card static" style="width: 100%; max-width: 440px; padding: 40px;">
        <a href="/" class="text-decoration-none text-muted" style="position: absolute; top: 20px; left: 25px; font-size: 20px;">❮</a>

        <!-- 錯誤提示 -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" style="border-radius: 12px; font-size: 13px;">
                    ${param.error}
            </div>
        </c:if>

        <form action="/register" method="post">
            <div class="mb-3">
                <label>Username (must contain letters)</label>
                <input type="text" name="username" class="ui-input" placeholder="e.g. john88" required>
            </div>
            <div class="mb-3">
                <label>Full Name</label>
                <input type="text" name="fullName" class="ui-input" placeholder="Full name" required>
            </div>
            <div class="mb-3">
                <label>Email Address</label>
                <input type="email" name="email" class="ui-input" placeholder="email@example.com" required>
            </div>
            <div class="mb-3">
                <label>Phone Number</label>
                <input type="tel" name="phoneNumber" class="ui-input" placeholder="Phone number" required>
            </div>
            <div class="mb-3">
                <label>Role</label>
                <select name="role" class="ui-input" required>
                    <option value="STUDENT">Student</option>
                    <option value="TEACHER">Teacher</option>
                </select>
            </div>
            <div class="mb-3">
                <label>Password</label>
                <input type="password" name="password" class="ui-input" placeholder="8+ chars, A-Z, a-z, 0-9, @" required>
            </div>
            <div class="mb-3">
                <label>Confirm Password</label>
                <input type="password" name="confirmPassword" class="ui-input" placeholder="Repeat password" required>
            </div>

            <button type="submit" class="btn-primary-custom w-100 mt-2">Get Started</button>
        </form>
    </div>
</div>
</body>
</html>



