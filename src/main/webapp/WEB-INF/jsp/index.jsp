<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 26/3/2026
  Time: 14:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>Welcome to Modern Learning</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container">
    <div class="hero-section text-center" style="padding: 100px 0 80px 0;">
        <h1 style="font-size: 64px; font-weight: 800; letter-spacing: -0.03em; margin-bottom: 24px; color: var(--text-primary); line-height: 1.1;">
            Learn Everything. <br> <span style="color: var(--brand-blue);">Anywhere.</span>
        </h1>
        <p style="font-size: 24px; color: var(--text-secondary); max-width: 700px; margin: 0 auto 48px auto; line-height: 1.5; font-weight: 400;">
            The most professional way to manage your learning path. <br> Experience a cleaner, faster, and smarter education platform.
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="/courses" class="btn-primary-custom" style="padding: 18px 48px; font-size: 19px;">Browse Courses</a>
            <a href="/login" class="btn-outline-custom" style="padding: 18px 48px; font-size: 19px; border-radius: 980px;">Login</a>
        </div>
    </div>

    <div class="row mt-5 pt-5 g-4">
        <div class="col-md-4">
            <div class="ui-card static h-100" style="padding: 40px;">
                <div style="font-size: 32px; margin-bottom: 20px;">🎨</div>
                <h3 style="font-size: 22px; font-weight: 700; margin-bottom: 12px;">Modern UI</h3>
                <p style="color: var(--text-secondary); font-size: 16px; line-height: 1.6;">A pixel-perfect interface designed for focus. No clutter, just your content.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="ui-card static h-100" style="padding: 40px;">
                <div style="font-size: 32px; margin-bottom: 20px;">⚡</div>
                <h3 style="font-size: 22px; font-weight: 700; margin-bottom: 12px;">Smart Sync</h3>
                <p style="color: var(--text-secondary); font-size: 16px; line-height: 1.6;">Access your courses and lectures from any device. Your progress stays with you.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="ui-card static h-100" style="padding: 40px;">
                <div style="font-size: 32px; margin-bottom: 20px;">🛠️</div>
                <h3 style="font-size: 22px; font-weight: 700; margin-bottom: 12px;">Easy Management</h3>
                <p style="color: var(--text-secondary); font-size: 16px; line-height: 1.6;">Powerful tools for creators to organize lectures and materials effortlessly.</p>
            </div>
        </div>
    </div>
</div>
</body>
</html>
