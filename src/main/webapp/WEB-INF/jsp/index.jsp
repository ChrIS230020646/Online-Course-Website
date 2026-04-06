<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 26/3/2026
  Time: 14:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <div><h1>My Courses</h1></div>
    <div class="row mt-5 pt-5 g-4">
        <c:forEach items="${courses}" var="course">
            <div class="col-md-4 mb-4">
                <a href="/course/${course.id}" class="ui-card clickable h-100 d-flex flex-column">
                    <span style="color:var(--text-secondary); font-weight:600; font-size:12px; text-transform:uppercase; letter-spacing:0.05em;">
                            ${course.category}
                    </span>
                    <h2 style="font-size: 20px; font-weight: 600; margin: 10px 0; color: var(--text-primary);">
                            ${course.title}
                    </h2>
                    <p style="color: #48484a; font-size: 15px; flex-grow: 1; margin-bottom: 20px;">
                            ${course.description}
                    </p>
                    <span class="btn-link-custom" style="font-weight: 500; font-size: 15px;">Learn more</span>
                </a>
            </div>

            <div class="mt-5">
                <h2 style="font-weight: 700; margin-bottom: 24px;">Browse Courses</h2>
                <div class="row g-4">
                    <c:forEach items="${courses}" var="course">
                        <div class="col-md-4">
                            <a href="/course/${course.id}" class="ui-card clickable h-100 d-flex flex-column">
                        <span style="color:var(--text-secondary); font-weight:600; font-size:12px; text-transform:uppercase;">
                                ${course.category}
                        </span>
                                <h4 style="font-size: 20px; font-weight: 600; margin: 10px 0;">${course.title}</h4>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="mt-5 pt-5">
                <h2 style="font-weight: 700; margin-bottom: 24px;">All Lectures</h2>
                <div class="ui-card" style="padding: 20px;">
                    <div class="list-group list-group-flush">
                        <c:forEach items="${lectures}" var="lecture">
                            <a href="/lecture/${lecture.id}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 border-0">
                                <div>
                                    <span class="badge bg-primary me-2">Lecture</span>
                                    <span style="font-weight: 500;">${lecture.title}</span>
                                </div>
                                <span class="text-muted" style="font-size: 14px;">View Details &rarr;</span>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="mt-5 pt-5">
                <h2 style="font-weight: 700; margin-bottom: 24px;">Active Polls</h2>
                <div class="row g-4">
                    <c:forEach items="${polls}" var="poll">
                        <div class="col-md-6">
                            <a href="/poll/${poll.id}" class="ui-card clickable d-flex align-items-center gap-3">
                                <div style="font-size: 28px;">📊</div>
                                <div>
                                    <h4 style="margin:0; font-weight: 600; font-size: 18px;">${poll.question}</h4>
                                    <p style="margin:0; font-size: 14px; color: var(--text-secondary);">Participate in this multiple choice poll</p>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>


        </c:forEach>
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
