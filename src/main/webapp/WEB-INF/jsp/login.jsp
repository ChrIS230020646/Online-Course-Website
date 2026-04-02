<%--
  Created by IntelliJ IDEA.
  User: s12992583
  Date: 3/4/2026
  Time: 0:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Login</title>
</head>
<body>
<h2>Login Page</h2>

<!-- 顯示錯誤訊息 -->
<c:if test="${param.error != null}">
    <p style="color:red">Invalid username or password.</p>
</c:if>

<form action="/login" method="post">
    <div>
        <label>Username:</label>
        <input type="text" name="username"/>
    </div>
    <div>
        <label>Password:</label>
        <input type="password" name="password"/>
    </div>
    <button type="submit">Login</button>
</form>

<p>Don't have an account? <a href="/register">Register here</a></p>
</body>
</html>

