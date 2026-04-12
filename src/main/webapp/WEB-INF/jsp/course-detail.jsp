<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 3/4/2026
  Time: 1:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>${course.title} - EduPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="main-nav">

    <div class="d-flex align-items-center">
        <a href="/profile" class="text-decoration-none d-flex align-items-center">
            <img src="${pageContext.request.userPrincipal != null ? currentUser.profilePicture : 'https://ui-avatars.com/api/?name=User'}"
                 alt="Avatar"
                 style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 2px solid #eee;">
            <span class="ms-2 fw-bold" style="color: #333;">
                ${currentUser.fullName}
            </span>
        </a>
    </div>

    <div class="nav-links">
        <a href="/courses">All Courses</a>
        <sec:authorize access="hasRole('STUDENT')">
            <a href="/my-courses">My Learning</a>
        </sec:authorize>
        <form action="/logout" method="post" style="display:inline; margin-left:20px;">
            <button type="submit" style="border:none; background:none; color:#dc3545; cursor:pointer;">Logout</button>
        </form>
    </div>
</nav>

<div class="ui-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <a href="/courses" class="btn-back">❮</a>
        <sec:authorize access="hasRole('TEACHER')">
            <div class="d-flex gap-2 align-items-center">
                <a href="/courses/${course.id}/edit" class="btn btn-outline-primary rounded-pill px-4">Edit Course</a>
                <form action="/courses/${course.id}/delete" method="post" class="m-0"
                      onsubmit="return confirm('WARNING: This will permanently delete the course. Proceed?');">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-danger rounded-pill px-4">Delete Course</button> <%--Nuke the Course--%>
                </form>
            </div>
        </sec:authorize>
    </div>

    <header class="mb-5">
    <span class="text-uppercase" style="color:var(--text-secondary); font-size:12px; font-weight:600; letter-spacing:1px;">
        ${course.category}
    </span>
        <h1 style="font-size: 42px; font-weight: 700; margin-top: 10px;">${course.title}</h1>
        <p class="mt-3" style="font-size: 18px; color: #424245;">${course.description}</p>
    </header>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="m-0" style="font-size: 24px; font-weight: 600;">Course Content</h2>

        <sec:authorize access="hasRole('TEACHER')">
            <div>
                <a href="/courses/${course.id}/add-lecture" class="btn-outline-custom" style="text-decoration:none;">Add Lecture</a>
                <a href="/courses/${course.id}/add-poll" class="btn-outline-custom" style="text-decoration:none;">Add Poll</a>
            </div>
        </sec:authorize>

        <sec:authorize access="hasRole('STUDENT')">
            <c:choose>
                <c:when test="${isEnrolled}">
                    <button class="btn btn-secondary disabled rounded-pill px-4" style="cursor: not-allowed;">Already Enrolled</button>
                </c:when>
                <c:otherwise>
                    <form action="/courses/${course.id}/enroll" method="post" class="m-0"
                          onsubmit="return confirm('Do you want to enroll in this course?');">
                        <button type="submit" class="btn-primary-custom">Enroll Now</button>
                    </form>
                </c:otherwise>
            </c:choose>
        </sec:authorize>
    </div>

    <div class="lecture-list mb-5">
    <h2 class="m-0" style="font-size: 24px; font-weight: 600;">Lectures</h2>
        <c:forEach items="${course.lectures}" var="lecture">
            <div class="ui-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 style="font-size:18px; margin:0;">${lecture.title}</h4>
                        <p class="text-muted m-0" style="font-size:14px;">${lecture.content}</p>
                    </div>

                    <sec:authorize access="hasRole('TEACHER')">
                      <div>
                        <a href="/course-material-page/${lecture.id}" class="btn btn-sm btn-light rounded-pill px-3">View / Edit</a>
                        <%@ include file="/WEB-INF/jsp/lecture-components/btn-delete.jsp" %>
                        </div>
                    </sec:authorize>

                    <sec:authorize access="hasRole('STUDENT')">
                        <c:choose>
                            <c:when test="${isEnrolled}">
                                <a href="/course-material-page/${lecture.id}" class="btn btn-sm btn-light rounded-pill px-3">View</a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-sm btn-light disabled rounded-pill px-3" title="Please enroll first">Locked 🔒</button>
                            </c:otherwise>
                        </c:choose>
                    </sec:authorize>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty course.lectures}">
            <p class="text-muted">No lectures added yet.</p>
        </c:if>
    </div>

    <%-- Poll Section --%>
    <div class="poll-list mb-5">
        <h2 class="mb-3" style="font-size: 24px; font-weight: 600;">Active Polls</h2>

        <%-- Loop through the POLLS collection, not the lectures collection --%>
        <c:forEach items="${course.polls}" var="poll">
            <div class="ui-card mb-3" style="border-left: 4px solid #007aff;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                            <%-- Display the Question created in add-poll.jsp --%>
                        <h4 style="font-size:18px; margin:0;"> ${poll.question}</h4>
                    </div>

                        <%-- Teacher View: See Results --%>
                    <sec:authorize access="hasRole('TEACHER')">
                    <div>
                        <a href="/polls/courses/${course.id}/poll/${poll.id}" class="btn btn-sm btn-light rounded-pill px-3">View Results/Edit</a>
<%@ include file="/WEB-INF/jsp/poll-components/btn-delete.jsp" %>
                    </div>
                    </sec:authorize>

                        <%-- Student View: Vote --%>
                    <sec:authorize access="hasRole('STUDENT')">
                        <c:choose>
                            <c:when test="${isEnrolled}">
                                <a href="/polls/courses/${course.id}/poll/${poll.id}" class="btn btn-sm btn-primary rounded-pill px-4">View Results/Vote</a>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-sm btn-light disabled rounded-pill px-3" title="Enroll to participate">Locked 🔒</button>
                            </c:otherwise>
                        </c:choose>
                    </sec:authorize>
                </div>
            </div>
        </c:forEach>

        <%-- Fallback if no polls have been created yet --%>
        <c:if test="${empty course.polls}">
            <div class="p-4 border rounded text-center" style="border-style: dashed !important;">
                <p class="text-muted m-0">No polls have been created for this course yet.</p>
            </div>
        </c:if>
    </div>

    <sec:authorize access="hasRole('TEACHER')">
        <div class="mt-5 pt-5 border-top">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="section-title m-0">Course Management</h3>
                <a href="/users" class="btn btn-sm btn-outline-dark rounded-pill px-3">Manage Global Users</a>
            </div>

            <div class="ui-card mb-4" style="background: #f8f9fa; border: 1px dashed #dee2e6;">
                <h6 class="mb-3">Add Student to this Course Manually</h6>
                <form action="/courses/${course.id}/add-student" method="post" class="row g-2 align-items-center">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="col-auto" style="min-width: 300px;">
                        <select name="studentId" class="form-select" required>
                            <option value="" disabled selected>Select a user to enroll...</option>
                                <c:forEach var="user" items="${allUsers}">
                                    <c:if test="${user.role == 'STUDENT'}">
                                        <option value="${user.id}">${user.username} - ${user.role}</option>
                                    </c:if>
                                </c:forEach>
                        </select>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary px-4">Add Now</button>
                    </div>
                </form>
            </div>

            <div class="ui-card" style="background:#fff;">
                <h5 class="mb-3 text-muted" style="font-size: 14px; font-weight: 600;">CURRENT ENROLLED STUDENTS</h5>
                <c:choose>
                    <c:when test="${not empty course.students}">
                        <ul class="list-group list-group-flush">
                            <c:forEach items="${course.students}" var="student">
                                <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0">
                                    <div>
                                        <span class="fw-bold">👤 ${student.fullName}</span>
                                        <small class="text-muted">(@${student.username})</small>
                                    </div>
                                    <div class="d-flex gap-2">
                                        <form action="/courses/${course.id}/kick/${student.id}" method="post" style="display:inline;">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="btn btn-sm btn-outline-warning rounded-pill px-3"
                                                    onclick="return confirm('Remove student from this course?')">Remove From Course</button>
                                        </form>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted m-0">No students enrolled yet.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </sec:authorize>

    <c:if test="${not empty message}">
        <script>
            alert("${message}");
        </script>
    </c:if>
</div>
</body>
</html>

