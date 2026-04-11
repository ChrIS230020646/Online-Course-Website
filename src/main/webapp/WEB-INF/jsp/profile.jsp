<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 8/4/2026
  Time: 3:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>My Profile Settings</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="ui-container">
  <a href="javascript:history.back()" class="btn-back">❮</a>
<div class="position-absolute" style="top: 130px; right: 40px; z-index: 10;">
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/comment/history"
               class="btn btn-outline-secondary btn-sm px-3"
               style="border-radius: 20px; font-size: 13px; color: #86868b; border-color: #d2d2d7; background: white;">
               Comment History
            </a>
            <a href="${pageContext.request.contextPath}/polls/history"
               class="btn btn-outline-secondary btn-sm px-3"
               style="border-radius: 20px; font-size: 13px; color: #86868b; border-color: #d2d2d7; background: white;">
               Poll History
            </a>
        </div>
    </div>
  <h1 class="page-title">User Profile</h1>
  <p class="text-secondary mb-5">Manage your personal information and security settings.</p>

  <form action="/profile/update" method="post" enctype="multipart/form-data">

    <c:if test="${not empty param.error}">
      <div class="alert alert-danger mb-4" style="border-radius: 12px;">${param.error}</div>
    </c:if>
    <c:if test="${param.success == 'true'}">
      <div class="alert alert-success mb-4" style="border-radius: 12px;">Profile updated successfully!</div>
    </c:if>

    <div class="ui-card static">
      <div class="d-flex align-items-center mb-5">
        <img src="${user.profilePicture}" alt="Avatar"
             style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border-color);">

        <div class="ms-4">
          <h2 class="section-title mb-1">${user.fullName}</h2>
          <p class="text-secondary">@${user.username} • ${user.role}</p>

          <label style="font-size: 12px;">Update Profile Photo</label>
          <input type="file" name="avatar" class="form-control form-control-sm" accept="image/*" style="max-width: 250px;">
        </div>
      </div>

      <div class="row">
        <div class="col-md-6">
          <label>Display Name</label>
          <input type="text" name="fullName" class="ui-input" value="${user.fullName}" required>
        </div>
        <div class="col-md-6">
          <label>Phone Number</label>
          <input type="text" name="phoneNumber" class="ui-input" value="${user.phoneNumber}" required>
        </div>
      </div>

      <div class="row">
        <div class="col-md-6">
          <label>Email Address</label>
          <input type="email" name="email" class="ui-input" value="${user.email}" required>
        </div>
        <div class="col-md-6">
          <label>Username (Read Only)</label>
          <input type="text" class="ui-input" value="${user.username}" disabled style="background-color: #f9f9f9; color: var(--text-secondary);">
        </div>
      </div>

      <hr style="border-color: var(--border-color); margin: 30px 0;">

      <h3 class="section-title" style="font-size: 20px;">Security & Password</h3>
      <p class="text-secondary mb-4" style="font-size: 14px;">Leave these blank if you do not wish to change your password.</p>

      <div class="row">
        <div class="col-md-6">
          <label>New Password</label>
          <input type="password" name="password" class="ui-input" placeholder="Min. 8 chars (A, a, 1, @)">
        </div>
        <div class="col-md-6">
          <label>Confirm New Password</label>
          <input type="password" name="confirmPassword" class="ui-input" placeholder="Repeat your new password">
        </div>
      </div>

      <div class="text-end mt-4">
        <button type="submit" class="btn-primary-custom">Save Changes</button>
      </div>
    </div>
  </form>
</div>

</body>
</html>



