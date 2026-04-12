<%--
  Created by IntelliJ IDEA.
  User: 12992583_ChrIS
  Date: 12/4/2026
  Time: 3:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <script>
        (function() {
            const referrer = document.referrer;
            if (referrer) {
                try {
                    const refUrl = new URL(referrer);
                    const path = refUrl.pathname;
                    const isUserManagementInternal = path.includes('/users');

                    if (!isUserManagementInternal) {
                        sessionStorage.setItem('user_management_back_url', referrer);
                    }
                } catch (e) {
                    console.error("Referrer parsing error", e);
                }
            }
        })();

        function handleSmartBack() {
            const backUrl = sessionStorage.getItem('user_management_back_url');
            window.location.href = backUrl ? backUrl : '/courses';
        }
    </script>
</head>
<body class="p-5">

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Global User Management</h2>
        <a href="javascript:void(0)" onclick="handleSmartBack()" class="btn btn-secondary rounded-pill px-4">❮</a>
    </div>

    <sec:authorize access="hasRole('TEACHER')">
        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <table class="table table-hover m-0">
                    <thead class="table-light">
                    <tr>
                        <th class="ps-4">Username</th>
                        <th>Role</th>
                        <th class="text-end pe-4">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td class="ps-4 align-middle">
                                <strong>${user.username}</strong>
                                <c:if test="${user.username == pageContext.request.userPrincipal.name}">
                                    <span class="badge bg-primary ms-2">You</span>
                                </c:if>
                            </td>
                            <td class="align-middle">${user.role}</td>
                            <td class="text-end pe-4 align-middle">
                                <div class="d-flex gap-2 justify-content-end">
                                    <a href="${pageContext.request.contextPath}/users/edit/${user.id}" class="btn btn-warning btn-sm rounded-pill px-3">Edit</a>

                                    <form action="${pageContext.request.contextPath}/users/delete/${user.id}" method="post" class="m-0"
                                          onsubmit="return confirm('${user.username == pageContext.request.userPrincipal.name ?
                                                  'WARNING: You are deleting YOUR OWN account. You will be logged out immediately. Continue?':'Are you sure you want to delete this account?'}')">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button class="btn btn-danger btn-sm rounded-pill px-3">Delete Account</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </sec:authorize>

    <sec:authorize access="!hasRole('TEACHER')">
        <div class="alert alert-danger">
            Access Denied: You do not have permission to view this page.
        </div>
    </sec:authorize>
</div>

</body>


