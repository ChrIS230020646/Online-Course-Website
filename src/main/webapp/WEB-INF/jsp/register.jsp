<%--
  Created by IntelliJ IDEA.
  User: s12992583
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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container d-flex flex-column align-items-center justify-content-center" style="min-height: 95vh;">
    <div style="text-align: center; margin-bottom: 40px;">
        <h1 class="page-title" style="font-size: 32px;">Create Account</h1>
        <p style="color: var(--text-secondary); font-size: 17px; margin-top: 8px;">Join our community today</p>
    </div>

    <div class="ui-card static" style="width: 100%; max-width: 440px; padding: 48px;">
        <form action="/register" method="post">
            <div class="mb-4">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="ui-input" placeholder="Choose a username" required>
            </div>

            <!-- 新增：Role 選擇欄位 -->
            <div class="mb-4">
                <label for="role">I am a...</label>
                <select id="role" name="role" class="ui-input" required style="appearance: none; background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%2386868b%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E'); background-repeat: no-repeat; background-position: right 1rem center; background-size: 0.65rem auto;">
                    <option value="" disabled selected>Select your role</option>
                    <option value="STUDENT">Student</option>
                    <option value="TEACHER">Teacher</option>
                </select>
            </div>

            <div class="mb-4">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="ui-input" placeholder="Strong password" required>
            </div>

            <div class="mb-4">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="ui-input" placeholder="Repeat password" required>
            </div>

            <button type="submit" class="btn-primary-custom w-100 mt-3" style="padding: 14px; font-size: 17px;">Get Started</button>

            <div class="text-center mt-4">
                <span style="color: var(--text-secondary); font-size: 14px;">Already a member?</span>
                <a href="/login" class="btn-link-custom ms-1" style="font-size: 14px; font-weight: 500;">Sign in here</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>

