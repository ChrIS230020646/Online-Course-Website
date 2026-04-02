<%--
  Created by IntelliJ IDEA.
  User: s12992583
  Date: 3/4/2026
  Time: 1:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>${course.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container">
    <a href="/courses" class="btn-back">❮</a>

    <header style="margin: 20px 0 60px 0;">
        <span style="color:var(--text-secondary); font-weight:600; text-transform:uppercase; font-size:13px; letter-spacing:0.05em;">
            ${course.category}
        </span>
        <h1 class="page-title" style="font-size: 48px; margin-top:10px;">${course.title}</h1>
        <p style="font-size: 21px; color: #48484a; margin-top:20px; line-height: 1.4; max-width: 800px;">
            ${course.description}
        </p>
    </header>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="section-title m-0">Lectures</h2>
        <a href="/course/${course.id}/add-lecture" class="btn-outline-custom">Add Lecture</a>
    </div>

    <div class="lecture-list">
        <c:forEach items="${course.lectures}" var="lecture">
            <div class="ui-card mb-3" style="padding: 24px;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 style="font-size: 19px; font-weight: 500; margin:0; color: var(--text-primary);">${lecture.title}</h3>
                        <p style="color:var(--text-secondary); font-size:14px; margin:4px 0 0 0;">${lecture.content}</p>
                    </div>
                    <a href="#" class="btn-primary-custom" style="font-size: 14px; padding: 6px 16px;">View</a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>

