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
    <title>Learning Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .instructor-tag { font-size: 13px; color: var(--brand-blue); font-weight: 500; }
        .source-tag { font-size: 11px; color: #8e8e93; text-transform: uppercase; margin-bottom: 5px; display: block; font-weight: 600; }
        .nav-avatar { width: 38px; height: 38px; border-radius: 50%; object-fit: cover; border: 1px solid #eee; }
        .main-nav { padding: 15px 5%; }
    </style>
</head>
<body>

<nav class="main-nav">
    <div class="nav-links" style="width: 100%; display: flex; justify-content: space-between; align-items: center;">
        <div class="d-flex align-items-center gap-3">
            <sec:authorize access="isAuthenticated()">
                <a href="/profile">
                    <img src="${not empty currentUser.profilePicture ? currentUser.profilePicture : 'https://ui-avatars.com/api/?name=User'}" class="nav-avatar">
                </a>
                <form action="/logout" method="post" style="display:inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" style="border:none; background:none; color:#dc3545; font-size: 14px; font-weight: 600;">Logout</button>
                </form>
            </sec:authorize>
            <sec:authorize access="isAnonymous()">
                <a href="/login" style="text-decoration: none; font-weight: 600;">Login</a>
            </sec:authorize>
        </div>
        <div>
            <a href="/courses" style="font-weight: 600;">Browse Courses</a>
        </div>
    </div>
</nav>

<div class="ui-container">
    <div class="mt-4 mb-5">
        <sec:authorize access="isAuthenticated()">
            <h1 class="page-title">Hello, ${currentUser.fullName}</h1>
            <p class="text-secondary">Explore your courses and recent updates.</p>
        </sec:authorize>
    </div>

    <div class="mb-4">
        <h2 style="font-weight: 700; font-size: 28px;">Courses</h2>
    </div>

    <div class="row g-4 mb-5">
        <c:forEach items="${courses}" var="course">
            <div class="col-md-4">
                <a href="/courses/${course.id}" class="ui-card clickable h-100 d-flex flex-column">
                    <div class="d-flex justify-content-between align-items-center">
                        <span style="color:var(--text-secondary); font-weight:600; font-size:11px; text-transform:uppercase;">${course.category}</span>
                        <span class="instructor-tag">👤 ${course.instructor.fullName}</span>
                    </div>
                    <h3 style="font-size: 20px; font-weight: 700; margin: 15px 0 10px 0; color: var(--text-primary);">${course.title}</h3>
                    <p style="color: #666; font-size: 14px; flex-grow: 1; margin-bottom: 20px;">${course.description}</p>
                    <span class="btn-link-custom" style="font-size: 13px; font-weight: 600;">Learn more ❯</span>
                </a>
            </div>
        </c:forEach>
    </div>

    <div class="row">
        <div class="col-md-7">
            <h2 style="font-weight: 700; margin-bottom: 24px; font-size: 24px;">Latest Lectures</h2>
            <div class="d-flex flex-column gap-3">
                <c:forEach items="${recentLectures}" var="lecture">

                    <a href="/course-material-page/${lecture.id}" class="ui-card clickable" style="padding: 18px 24px;">
                        <span class="source-tag">COURSE: ${lecture.course.title}</span>
                        <div class="d-flex align-items-center">
                            <div style="background: var(--brand-blue); width: 8px; height: 8px; border-radius: 50%; margin-right: 15px;"></div>
                            <span style="font-weight: 600; color: var(--text-primary); font-size: 16px;">${lecture.title}</span>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>

        <div class="col-md-5">
            <h2 style="font-weight: 700; margin-bottom: 24px; font-size: 24px;">Active Polls</h2>
            <div class="d-flex flex-column gap-3">
                <c:forEach items="${activePolls}" var="poll">
                    <a href="/polls/courses/${poll.course.id}/poll/${poll.id}" class="ui-card clickable" style="padding: 20px;">
                        <span class="source-tag">POLL IN: ${poll.course.title}</span>
                        <div class="d-flex align-items-center mt-1">
                            <div style="font-size: 24px; margin-right: 15px;">📊</div>
                            <div>
                                <h4 style="margin:0; font-weight: 600; font-size: 16px; color: var(--text-primary);">${poll.question}</h4>
                                <p style="margin:0; font-size: 12px; color: var(--text-secondary);">Participate now</p>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>
    </div>
</div>
</body>
</html>
