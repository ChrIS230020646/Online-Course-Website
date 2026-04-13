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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>${course.title} - EduPortal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .quick-link-btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 14px; border-radius: 20px; font-size: 12px; font-weight: 600;
            text-decoration: none; transition: all 0.2s; border: 1px solid #eee; margin-right: 8px;
        }
        .btn-link-web { background: #f0f7ff; color: #0071e3; border-color: #d0e7ff; }
        .btn-link-web:hover { background: #0071e3; color: white; }
        .btn-link-file { background: #fff9f0; color: #ff9500; border-color: #ffeccf; }
        .btn-link-file:hover { background: #ff9500; color: white; }
        .lecture-card { transition: transform 0.2s, box-shadow 0.2s; border: 1px solid #eee !important; }
        .lecture-card:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(0,0,0,0.05); }
    </style>

    <script>
        (function() {
            const referrer = document.referrer;
            if (referrer) {
                try {
                    const refUrl = new URL(referrer);
                    const path = refUrl.pathname;

                    const whiteList = ['/courses', '/my-courses', '/', '/index'];
                    const isFromWhiteList = whiteList.some(item => path === item || path === (item + '/'));

                    if (isFromWhiteList) {
                        sessionStorage.setItem('course_detail_back_url', referrer);
                    }
                } catch (e) {
                    console.error("Referrer parsing error", e);
                }
            }
        })();

        function handleSmartBack() {
            const backUrl = sessionStorage.getItem('course_detail_back_url');
            window.location.href = backUrl ? backUrl : '/courses';
        }
    </script>
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
                <a href="/history/comment/all" class="nav-history-link">
                    <span class="badge rounded-pill bg-info-subtle text-info-emphasis">All Comment History</span>
                </a>
                <a href="/history/poll/all" class="nav-history-link">
                    <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">All Poll History</span>
                </a>
    </div>
</nav>

<div class="ui-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <a href="javascript:void(0)" onclick="handleSmartBack()" class="btn-back">❮</a>
        <sec:authorize access="hasRole('TEACHER')">
            <div class="d-flex gap-2 align-items-center">
                <a href="/courses/${course.id}/edit" class="btn btn-outline-primary rounded-pill px-4">Edit Course</a>
                <form action="/courses/${course.id}/delete" method="post" class="m-0"
                      onsubmit="return confirm('WARNING: This will permanently delete the course. Proceed?');">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-danger rounded-pill px-4">Delete Course</button>
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
        <h3 class="mb-4" style="font-size: 20px; font-weight: 600; color: #666;">Lectures</h3>
        <c:forEach items="${course.lectures}" var="lecture">
            <div class="ui-card mb-3 lecture-card">
                <div class="d-flex justify-content-between align-items-start">
                    <div style="flex: 1;">

                        <h4 style="font-size:18px; margin:0; font-weight: 700;">${lecture.title}</h4>

                        <p class="text-muted mt-1 mb-3" style="font-size:14px;">
                            <c:choose>
                                <c:when test="${fn:contains(lecture.content, '|||')}">
                                    ${fn:substringBefore(lecture.content, '|||')}
                                </c:when>
                                <c:when test="${fn:startsWith(lecture.content, 'http')}">
                                </c:when>
                                <c:otherwise>
                                    ${lecture.content}
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <c:if test="${isEnrolled or pageContext.request.isUserInRole('TEACHER')}">
                            <div class="d-flex flex-wrap gap-1">

                                <c:if test="${not empty lecture.fileName}">
                                    <a href="/download/lecture/${lecture.id}" class="quick-link-btn btn-link-file">
                                        <img src="https://cdn-icons-png.flaticon.com/512/337/337946.png" width="14" alt="file">
                                            ${fn:length(lecture.fileName) > 20 ? fn:substring(lecture.fileName, 0, 17).concat('...') : lecture.fileName}
                                    </a>
                                </c:if>

                                <c:if test="${fn:contains(lecture.content, '|||') or fn:startsWith(lecture.content, 'http')}">
                                    <c:set var="linksPart" value="${fn:contains(lecture.content, '|||') ? fn:substringAfter(lecture.content, '|||') : lecture.content}" />
                                    <c:forEach var="url" items="${fn:split(linksPart, ' ')}">
                                        <c:if test="${not empty fn:trim(url) and fn:startsWith(fn:trim(url), 'http')}">
                                            <a href="${fn:trim(url)}" target="_blank" class="quick-link-btn btn-link-web">
                                                <img src="https://cdn-icons-png.flaticon.com/512/44/44386.png" width="14" alt="link">
                                                <c:set var="d" value="${fn:replace(fn:replace(fn:replace(url, 'https://', ''), 'http://', ''), 'www.', '')}" />
                                                    ${fn:contains(d, '/') ? fn:substringBefore(d, '/') : d}
                                            </a>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </c:if>
                    </div>

                    <div class="ms-3 d-flex align-items-center gap-2">
                        <sec:authorize access="hasRole('TEACHER')">
                            <a href="/course-material-page/${lecture.id}" class="btn btn-sm btn-light rounded-pill px-3 fw-bold">Edit Content</a>
                            <form action="${pageContext.request.contextPath}/courses/${course.id}/lecture/${lecture.id}/delete" method="post" class="d-inline m-0" onsubmit="return confirm('Delete this lecture permanently?');">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="submit" class="btn btn-sm btn-danger rounded-pill px-3">Delete</button>
                            </form>
                        </sec:authorize>

                        <sec:authorize access="hasRole('STUDENT')">
                            <c:choose>
                                <c:when test="${isEnrolled}">
                                    <a href="/course-material-page/${lecture.id}" class="btn btn-sm btn-light rounded-pill px-3 fw-bold">Go to Lecture</a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-sm btn-light disabled rounded-pill px-3" title="Please enroll first">Locked 🔒</button>
                                </c:otherwise>
                            </c:choose>
                        </sec:authorize>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty course.lectures}">
            <p class="text-muted">No lectures added yet.</p>
        </c:if>
    </div>

    <div class="poll-list mb-5">
        <h2 class="mb-3" style="font-size: 24px; font-weight: 600;">Active Polls</h2>
        <c:forEach items="${course.polls}" var="poll">
            <div class="ui-card mb-3" style="border-left: 4px solid #007aff;">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4 style="font-size:18px; margin:0;"> ${poll.question}</h4>
                        <br>
                        <jsp:include page="poll-components/poll-result.jsp">
                            <jsp:param name="pollId" value="${poll.id}" />
                        </jsp:include>
                    </div>
                    <sec:authorize access="hasRole('TEACHER')">
                        <div>
                            <a href="/polls/courses/${course.id}/poll/${poll.id}" class="btn btn-sm btn-light rounded-pill px-3">View Results/Edit</a>
                            <form action="${pageContext.request.contextPath}/polls/${poll.id}/delete" method="post" class="d-inline m-0"
                                  onsubmit="return confirm('Delete this poll permanently?');">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="submit" class="btn btn-sm btn-danger rounded-pill px-3">Delete</button>
                            </form>
                        </div>
                    </sec:authorize>
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
        <script>alert("${message}");</script>
    </c:if>
</div>
</body>
</html>