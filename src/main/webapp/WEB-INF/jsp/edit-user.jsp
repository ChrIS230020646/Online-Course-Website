<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 12/4/2026
  Time: 16:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Edit User - ${user.username}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="ui-container">
  <%-- Navigation --%>
  <a href="/users" class="btn-back">❮</a>

  <%-- Header Section --%>
  <h1 class="page-title">Administrative Edit</h1>
  <p class="text-secondary mb-5">Modifying account details and permissions for <strong>@${user.username}</strong>.</p>

  <form action="${pageContext.request.contextPath}/users/update/${user.id}" method="post">
    <%-- Security Token --%>
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

    <%-- Error Handling --%>
    <c:if test="${not empty error}">
      <div class="alert alert-danger mb-4" style="border-radius: 12px;">${error}</div>
    </c:if>

    <div class="ui-card static">
      <%-- User Summary Header --%>
      <div class="d-flex align-items-center mb-5">
        <img src="${not empty user.profilePicture ? user.profilePicture : 'https://ui-avatars.com/api/?name=' += user.fullName}"
             alt="Avatar"
             style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border-color);">

        <div class="ms-4">
          <h2 class="section-title mb-1">${user.fullName}</h2>
          <p class="text-secondary">@${user.username} • <span class="badge bg-light text-dark border">${user.role}</span></p>

          <label style="font-size: 12px;" class="d-block mt-2 text-primary fw-bold">Update Account Role</label>
          <select name="role" class="form-select form-select-sm" style="max-width: 200px; border-radius: 8px;">
            <option value="STUDENT" ${user.role == 'STUDENT' ? 'selected' : ''}>STUDENT</option>
            <option value="TEACHER" ${user.role == 'TEACHER' ? 'selected' : ''}>TEACHER</option>
          </select>
        </div>
      </div>

      <%-- Basic Info Row --%>
      <div class="row">
        <div class="col-md-6">
          <label>Full Name</label>
          <input type="text" name="fullName" class="ui-input" value="${user.fullName}" required>
        </div>
        <div class="col-md-6">
          <label>Phone Number</label>
          <input type="text" name="phoneNumber" class="ui-input" value="${user.phoneNumber}">
        </div>
      </div>

      <%-- Email & Username Row --%>
      <div class="row">
        <div class="col-md-6">
          <label>Email Address</label>
          <input type="email" name="email" class="ui-input" value="${user.email}" required>
        </div>
        <div class="col-md-6">
          <label>Username (Read Only)</label>
          <input type="text" class="ui-input" value="${user.username}" disabled
                 style="background-color: #f9f9f9; color: var(--text-secondary); cursor: not-allowed;">
        </div>
      </div>

      <hr style="border-color: var(--border-color); margin: 30px 0;">

      <%-- Password Section --%>
      <h3 class="section-title" style="font-size: 20px;">Security Override</h3>
      <p class="text-secondary mb-4" style="font-size: 14px;">Enter a new password below to reset this user's credentials.</p>

      <div class="row">
        <div class="col-md-12">
          <label class="text-primary">Reset Password</label>
          <input type="text"
                 name="password"
                 class="ui-input"
                 placeholder="Enter new password"
                 style="background-color: #f0f7ff; border: 1px solid #cce3ff;"

                 >
          <small class="text-muted">As a teacher, you are setting a new visible password for this student.</small>
        </div>
      </div>

      <%-- Action Buttons --%>
      <div class="text-end mt-5">
        <a href="/users" class="btn btn-light rounded-pill px-4 me-2">Cancel</a>
        <button type="submit" class="btn-primary-custom">Update User Account</button>
      </div>
    </div>
  </form>
</div>

</body>
</html>