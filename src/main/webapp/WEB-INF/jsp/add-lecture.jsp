<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 4/4/2026
  Time: 20:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>Add New Lecture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container">
    <a href="/courses/${courseId}" class="btn-back">❮</a>
<sec:authorize access="hasRole('TEACHER')">
    <h1 class="page-title mb-5">New Lecture</h1>
    <p style="color: var(--text-secondary); margin-top: -40px; margin-bottom: 40px;">
        Adding content to Course ID: <strong>${courseId}</strong>
    </p>

    <div class="ui-card static">
        <form action="/courses/${courseId}/add-lecture" method="post">

        <div class="mb-4">
                <label for="title">Lecture Title</label>
                <input type="text" id="title" name="title" class="ui-input"
                       placeholder="e.g. Introduction to Spring Security" required>
            </div>

            <div class="mb-4">
                <label for="content">Lecture Content / URL</label>
                <textarea id="content" name="content" class="ui-input" rows="5"
                          placeholder="Enter lecture notes or video links here..." required></textarea>
            </div>

            <div class="d-flex align-items-center mt-5">
                <button type="submit" class="btn-primary-custom me-4">Save Lecture</button>
                <a href="/courses/${courseId}" class="btn-link-custom">Cancel</a>
            </div>

            <%-- if Spring Security have CSRF --%>
            <%-- <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
        </form>
    </div>
</sec:authorize>
    <sec:authorize access="hasRole('STUDENT')">
    <div class="ui-card static">
        <div class="d-flex justify-content-center">
        <h1 class="page-title mb-5">You DO NOT have permission to access this page</h1>
        </div>
        <div class="d-flex justify-content-center">
        <a href="/courses" class="btn-primary-custom">Back to Courses</a>
        </div>
    </div>
    </sec:authorize>
</div>
</body>
</html>
