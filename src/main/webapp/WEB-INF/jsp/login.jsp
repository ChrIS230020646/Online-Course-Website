<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 3/4/2026
  Time: 0:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Sign In</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container d-flex flex-column align-items-center justify-content-center" style="min-height: 90vh;">

    <div style="text-align: center; margin-bottom: 40px;">
        <a href="/" class="text-decoration-none text-muted mb-4 d-inline-block">❮</a>
        <h1 class="page-title" style="font-size: 32px;">Sign In</h1>
        <p style="color: var(--text-secondary); font-size: 17px; margin-top: 8px;">Enter your details to continue</p>
    </div>

    <div class="ui-card static" style="width: 100%; max-width: 400px; padding: 48px;">
        <c:if test="${param.deleted == 'self'}">
            <div class="alert alert-info">Your account has been successfully deleted and you have been logged out.</div>
        </c:if>
        <c:if test="${param.registered == 'true'}">
            <div class="alert alert-success py-2" style="font-size: 14px;">Registration successful! Please sign in.</div>
        </c:if>
        <c:if test="${param.error != null}">
            <div class="alert alert-danger py-2" style="font-size: 14px;">Invalid ID or password.</div>
        </c:if>
        <c:if test="${param.logout != null}">
            <div class="alert alert-info py-2" style="font-size: 14px;">Logged out successfully.</div>
        </c:if>

        <form action="/login" method="post">
            <div class="mb-4">
                <label for="username">Username / Email / Phone</label>
                <input type="text" id="username" name="username" class="ui-input" placeholder="e.g. john_doe or john@email.com" required>
            </div>

            <div class="mb-4">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="ui-input" placeholder="Your password" required>
            </div>

            <button type="submit" class="btn-primary-custom w-100 mt-3" style="padding: 14px; font-size: 17px;">Sign In</button>

            <div class="text-center mt-4">
                <span style="color: var(--text-secondary); font-size: 14px;">Don't have an account?</span>
                <a href="/register" class="btn-link-custom ms-1" style="font-size: 14px; font-weight: 500;">Create one now</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>



