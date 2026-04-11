<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 4/4/2026
  Time: 23:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
  <title>My Enrolled Courses</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="main-nav">
  <div class="d-flex align-items-center">
    <a href="/profile" class="text-decoration-none d-flex align-items-center">
      <img src="${pageContext.request.userPrincipal != null ? currentUser.profilePicture : 'https://ui-avatars.com/api/?name=User'}"
           alt="Avatar"
           style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 2px solid #eee;">
      <span class="ms-2 fw-bold" style="color: #333;">
        ${currentUser.fullName}
      </span>
    </a>
  </div>
  <div class="nav-links">
    <a href="/courses">All Courses</a>
    <sec:authorize access="hasRole('STUDENT')">
      <a href="/my-courses">My Learning</a>
    </sec:authorize>
    <form action="/logout" method="post" style="display:inline; margin-left:25px;">
      <button type="submit" class="btn-logout" style="border:none; background:none; cursor:pointer; font-weight:500;">Logout</button>
    </form>
  </div>
</nav>
<div class="ui-container">
  <c:if test="${not empty message}">
    <div class="alert alert-success shadow-sm">${message}</div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-warning">${error}</div>
  </c:if>

  <div class="btn-back-wrapper">
    <a href="/courses" class="btn-back">❮</a>
  </div>

  <div class="page-header">
    <h1 class="page-title">My Learning Journey</h1>
  </div>

  <div class="row">
    <c:forEach items="${enrolledCourses}" var="course">
      <div class="col-md-6 mb-4">
        <div class="ui-card h-100">
          <span class="badge bg-primary mb-2">${course.category}</span>
          <h3 class="mb-3">${course.title}</h3>
          <p class="text-muted">${course.description}</p>
          <a href="/courses/${course.id}" class="btn btn-outline-primary btn-sm mt-3">Enter Classroom</a>
        </div>
      </div>
    </c:forEach>

    <c:if test="${empty enrolledCourses}">
      <div class="text-center p-5">
        <p style="color:var(--text-secondary);">You haven't enrolled in any courses yet.</p>
        <a href="/courses" class="btn-primary-custom">Browse Courses</a>
      </div>
    </c:if>
  </div>
</div>
</body>
</html>

