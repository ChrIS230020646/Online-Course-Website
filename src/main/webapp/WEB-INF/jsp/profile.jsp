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
  <title>My Profile</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="ui-container">

  <a href="javascript:history.back()" class="btn-back">❮</a>

  <h1 class="page-title">User Profile</h1>
  <p class="text-secondary mb-5">Manage your personal information and security.</p>

  <form action="/profile/update" method="post" enctype="multipart/form-data">

    <c:if test="${not empty param.error}"><div class="alert alert-danger mb-4">${param.error}</div></c:if>
    <c:if test="${param.success == 'true'}"><div class="alert alert-success mb-4">Profile updated successfully!</div></c:if>

    <div class="ui-card static">
      <div class="d-flex align-items-center mb-5">

        <img src="<c:url value='${user.profilePicture}' />" alt="Avatar"
             style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border-color);">

        <div class="ms-4">
          <h2 class="section-title mb-1">${user.fullName}</h2>
          <p class="text-secondary">@${user.username} • ${user.role}</p>

          <input type="file" name="avatar" class="form-control form-control-sm mt-2" accept="image/*" style="max-width: 250px;">
        </div>
      </div>

      <div class="row">
        <div class="col-md-6">
          <label>Display Name</label>
          <input type="text" name="fullName" class="ui-input" value="${user.fullName}" required>

          <label>Email Address</label>
          <input type="email" name="email" class="ui-input" value="${user.email}" required>
        </div>
        <div class="col-md-6">
          <label>Phone Number</label>
          <input type="text" name="phoneNumber" class="ui-input" value="${user.phoneNumber}" required>
        </div>
      </div>

      <hr style="border-color: var(--border-color); margin: 30px 0;">

      <h3 class="section-title" style="font-size: 20px;">Security</h3>
      <div class="row">
        <div class="col-md-6">
          <label>New Password</label>
          <input type="password" name="password" class="ui-input" placeholder="Min. 8 chars, mixed case, symbols">
        </div>
        <div class="col-md-6">
          <label>Confirm New Password</label>
          <input type="password" name="confirmPassword" class="ui-input" placeholder="Repeat new password">
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


