<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 3/4/2026
  Time: 1:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>New Course</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container">
  <a href="/courses" class="btn-back">❮</a>

  <h1 class="page-title mb-5">Course Information</h1>

  <div class="ui-card static">
    <form action="/courses/add" method="post">
      <div class="mb-4">
        <label for="title">Title</label>
        <input type="text" id="title" name="title" class="ui-input" placeholder="e.g. Advanced Java" required>
      </div>

      <div class="mb-4">
        <label for="category">Category</label>
        <input type="text" id="category" name="category" class="ui-input" placeholder="e.g. Computer Science" required>
      </div>

      <div class="mb-4">
        <label for="description">Description</label>
        <textarea id="description" name="description" class="ui-input" rows="5" placeholder="Course details..." required></textarea>
      </div>

      <div class="d-flex align-items-center mt-5">
        <button type="submit" class="btn-primary-custom me-4">Publish Course</button>
        <a href="/courses" class="btn-link-custom">Cancel</a>
      </div>
    </form>
  </div>
</div>
</body>
</html>


