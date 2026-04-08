<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 9/4/2026
  Time: 01:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
  <title>Edit Course - ${course.title}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container mt-5">
  <a href="/courses/${course.id}" class="btn-back mb-4">❮</a>
  <sec:authorize access="hasRole('TEACHER')">
  <div class="ui-card">
    <h1 class="mb-4" style="font-weight: 700;">Edit Course Details</h1>

    <form action="/courses/${course.id}/edit" method="post">
      <%-- Security Token --%>
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

      <div class="mb-3">
        <label class="form-label fw-bold">Course Title</label>
        <input type="text" name="title" class="form-control" value="${course.title}" required>
      </div>

      <div class="mb-3">
        <label class="form-label fw-bold">Category</label>
        <input type="text" name="category" class="form-control" value="${course.category}" placeholder="e.g., Computer Science, Math, History" required>
      </div>

      <div class="mb-3">
        <label class="form-label fw-bold">Description</label>
        <textarea name="description" class="form-control" rows="5" required>${course.description}</textarea>
      </div>

      <div class="d-flex justify-content-end gap-2 mt-4">
        <a href="/courses/${course.id}" class="btn btn-light rounded-pill px-4">Cancel</a>
        <button type="submit" class="btn btn-primary rounded-pill px-4">Update Course</button>
      </div>
    </form>
  </div>
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
</body>
</html>