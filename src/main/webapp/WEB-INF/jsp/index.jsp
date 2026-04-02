<%--
  Created by IntelliJ IDEA.
  User: s12992583
  Date: 26/3/2026
  Time: 14:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>HKMU COMP3820SEF Online Course</title>
</head>
<body>
    <h1>Welcome to HKMU COMP3820SEF Online Course Website</h1>
    <p>This is the index page of your group project.</p>
    <p>Course Name: COMP3820SEF</p>
    <p>Short Description: Web Applications: Design and Development</p>

    <h2>Lectures</h2>
    <ul>
        <li><a href="/lecture/1">Lecture 1: Introduction to Spring Boot</a></li>
        <li><a href="/lecture/2">Lecture 2: Understanding JSP and Controllers</a></li>
    </ul>

    <h2>Polls</h2>
    <ul>
        <li><a href="/poll/1">Poll 1: Which topic for next class?</a></li>
    </ul>

    <p>You can also <a href="/register">Register</a> or <a href="/login">Login</a>.</p>

    <sec:authorize access="isAuthenticated()">
        <p>Welcome, <sec:authentication property="principal.username" />!</p>
        <p>Your role is: <sec:authentication property="principal.authorities" /></p>

        <form action="/logout" method="post">
            <button type="submit">Logout</button>
        </form>
    </sec:authorize>

    <sec:authorize access="isAnonymous()">
        <p>Please <a href="/login">Login</a> or <a href="/register">Register</a></p>
    </sec:authorize>
</body>
</html>
