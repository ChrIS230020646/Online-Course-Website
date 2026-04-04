<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 3/4/2026
  Time: 1:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>${course.title} - EduPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="main-nav">
    <a href="/courses" style="font-weight:600; text-decoration:none; color:black;">EduPortal</a>
    <div class="nav-links">
        <a href="/courses">All Courses</a>
        <sec:authorize access="hasRole('STUDENT')">
            <a href="/my-courses">My Learning</a>
        </sec:authorize>
        <form action="/logout" method="post" style="display:inline; margin-left:20px;">
            <button type="submit" style="border:none; background:none; color:#dc3545; cursor:pointer;">Logout</button>
        </form>
    </div>
</nav>

<div class="ui-container">
    <a href="/courses" class="btn-back">❮</a>

    <header class="mb-5">
    <span class="text-uppercase" style="color:var(--text-secondary); font-size:12px; font-weight:600; letter-spacing:1px;">
        ${course.category}
    </span>
        <h1 style="font-size: 42px; font-weight: 700; margin-top: 10px;">${course.title}</h1>
        <p class="mt-3" style="font-size: 18px; color: #424245;">${course.description}</p>
    </header>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="m-0" style="font-size: 24px; font-weight: 600;">Course Content</h2>

        <sec:authorize access="hasRole('TEACHER')">
            <a href="/courses/${course.id}/add-lecture" class="btn-outline-custom" style="text-decoration:none;">Add Lecture</a>
        </sec:authorize>

        <sec:authorize access="hasRole('STUDENT')">
            <c:choose>
                <c:when test="${isEnrolled}">
                    <button class="btn btn-secondary disabled rounded-pill px-4" style="cursor: not-allowed;">Already Enrolled</button>
                </c:when>
                <c:otherwise>
                    <form action="/courses/${course.id}/enroll" method="post" class="m-0"
                          onsubmit="return confirm('Do you want to enroll in this course?');">
                        <button type="submit" class="btn-primary-custom">Enroll Now</button>
                    </form>
                </c:otherwise>
            </c:choose>
        </sec:authorize>
    </div>

    <div class="lecture-list mb-5">
        <c:forEach items="${course.lectures}" var="lecture">
            <div class="ui-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 style="font-size:18px; margin:0;">${lecture.title}</h4>
                        <p class="text-muted m-0" style="font-size:14px;">${lecture.content}</p>
                    </div>

                    <sec:authorize access="hasRole('TEACHER')">
                        <a href="/lectures/${lecture.id}" class="btn btn-sm btn-light rounded-pill px-3">View / Edit</a>
                    </sec:authorize>

                    <sec:authorize access="hasRole('STUDENT')">
                        <c:choose>
                            <c:when test="${isEnrolled}">
                                <a href="/lectures/${lecture.id}" class="btn btn-sm btn-light rounded-pill px-3">View</a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-sm btn-light disabled rounded-pill px-3" title="Please enroll first">Locked 🔒</button>
                            </c:otherwise>
                        </c:choose>
                    </sec:authorize>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty course.lectures}">
            <p class="text-muted">No lectures added yet.</p>
        </c:if>
    </div>

    <sec:authorize access="hasRole('TEACHER')">
        <div class="mt-5 pt-5 border-top">
            <h3 class="section-title">Enrolled Students</h3>
            <div class="ui-card" style="background:#fff;">
                <c:choose>
                    <c:when test="${not empty course.students}">
                        <ul class="list-group list-group-flush">
                            <c:forEach items="${course.students}" var="student">
                                <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                    <span>👤 ${student.username}</span>
                                    <span class="badge rounded-pill bg-light text-dark border">Student Account</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted m-0">No students enrolled yet.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </sec:authorize>

    <c:if test="${not empty message}">
        <script>
            alert("${message}");
        </script>
    </c:if>
</div>
</body>
</html>


