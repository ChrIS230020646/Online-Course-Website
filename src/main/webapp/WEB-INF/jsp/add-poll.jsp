<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 5/4/2026
  Time: 04:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Course Poll - ${course.title}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="ui-container">
  <a href="/courses/${courseId}" class="btn-back">❮</a>

  <div class="header mb-5">
    <h1 class="page-title">${poll.question}</h1>
    <p class="text-secondary">Cast your vote for the next class topic.</p>
  </div>

  <div class="ui-card static">
    <form action="/courses/${courseId}/add-poll" method="post">
      <div class="mb-4">
        <label for="question">Poll Question</label>
        <input type="text" id="question" name="question" class="ui-input" required>
      </div>

      <label class="mb-2">Options (Exactly 5)</label>
      <%-- Using the same name "options" for all 5 inputs --%>
      <c:forEach var="i" begin="1" end="5">
        <div class="mb-2 d-flex align-items-center">
          <span class="me-2">${i}.</span>
          <input type="text" name="options" class="ui-input" placeholder="Option ${i}" required>
        </div>
      </c:forEach>

      <button type="submit" class="btn-primary-custom mt-4">Create Poll</button>
    </form>
  </div>
</div>
</body>
</html>
