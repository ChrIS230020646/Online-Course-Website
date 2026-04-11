<%--
  Created by IntelliJ IDEA.
  User: 12992583_ChrIS
  Date: 12/4/2026
  Time: 3:42
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="p-5">
<h2>Global User Management</h2>
<table class="table border">
    <thead>
    <tr>
        <th>Username</th>
        <th>Role</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="user" items="${users}">
        <tr>
            <td>${user.username}</td>
            <td>${user.role}</td>
            <td>
                <form action="/users/delete/${user.id}" method="post" onsubmit="return confirm('Delete this account?')">
                    <button class="btn btn-danger btn-sm">Delete Account Permanently</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<a href="/courses" class="btn btn-secondary">Back to Courses</a>
</body>
</html>


