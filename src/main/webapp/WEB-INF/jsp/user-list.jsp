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
<sec:authorize access="hasRole('TEACHER')">
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
                <div class="d-flex gap-2">
                        <%-- Only Teachers see the Edit button --%>

                        <a href="${pageContext.request.contextPath}/users/edit/${user.id}" class="btn btn-warning btn-sm">Edit</a>
                            <form action="${pageContext.request.contextPath}/users/delete/${user.id}" method="post" class="m-0"
                                  onsubmit="return confirm('${user.username == pageContext.request.userPrincipal.name ?
                                'WARNING: You are deleting YOUR OWN account. You will be logged out immediately. Continue?':'Are you sure you want to delete this account?'}')">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button class="btn btn-danger btn-sm">Delete Account Permanently</button>
                            </form>
                </div>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</sec:authorize>
<a href="/courses" class="btn btn-secondary">Back to Courses</a>
</body>
</html>


