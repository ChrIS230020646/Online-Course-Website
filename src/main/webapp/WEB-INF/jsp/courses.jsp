<%--
  Created by IntelliJ IDEA.
  User: ChrIS
  Date: 3/4/2026
  Time: 1:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container">
    <div class="d-flex justify-content-between align-items-end mb-5">
        <div>
            <h1 class="page-title m-0">Courses</h1>
        </div>
        <div>
            <a href="/add-course" class="btn-primary-custom">Create Course</a>
        </div>
    </div>

    <div class="row">
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
        </c:forEach>
    </div>
</div>
</body>
</html>





