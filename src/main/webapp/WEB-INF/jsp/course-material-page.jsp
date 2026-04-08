<%--
  Created by IntelliJ IDEA.
  User: s12992583_ChrIS
  Date: 6/4/2026
  Time: 1:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>${lecture.title} - Course Material Page</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .file-download-link {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: #424245;
            padding: 10px 15px;
            border-radius: 8px;
            transition: background 0.2s;
        }
        .file-download-link:hover {
            background-color: #f5f5f7;
            color: #0071e3;
        }
        .file-icon { width: 24px; height: 24px; }
        .download-arrow { color: #0071e3; margin-left: 5px; }
    </style>
</head>
<body class="bg-light">

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
        <a href="/courses/${course.id}">Course Detail</a>
        <form action="/logout" method="post" style="display:inline; margin-left:25px;">
            <button type="submit" class="btn-logout" style="border:none; background:none; cursor:pointer; font-weight:500;">Logout</button>
        </form>
    </div>
</nav>

<div class="ui-container">
    <a href="/courses/${course.id}" class="btn-back">❮</a>

    <header class="mb-5">
        <h1 style="font-size: 42px; font-weight: 700; margin-top: 10px;">${lecture.title}</h1>
    </header>

    <div class="ui-card mb-5">
        <sec:authorize access="hasRole('TEACHER')">
            <form action="/course-material-page/${lecture.id}/update" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="mb-4">
                    <label class="form-label fw-bold text-muted small text-uppercase">Edit Title</label>
                    <input type="text" name="title" class="form-control form-control-lg border-0 bg-light"
                           value="${lecture.title}" style="font-weight: 700;" required>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold text-muted small text-uppercase">Edit Content</label>
                    <textarea name="content" class="form-control border-0 bg-light" rows="12"
                              style="line-height: 1.8; font-size: 18px;">${lecture.content}</textarea>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <span class="text-muted small"><i>Teacher Mode: Changes will go live once saved.</i></span>
                    <button type="submit" class="btn btn-primary rounded-pill px-5 shadow-sm">Save Changes</button>
                </div>
            </form>
        </sec:authorize>

        <sec:authorize access="hasRole('STUDENT')">
            <header class="mb-4">
                <h1 style="font-size: 42px; font-weight: 700;">${lecture.title}</h1>
            </header>
            <div class="py-3">
                <p style="font-size: 18px; color: #424245; line-height: 1.8; white-space: pre-wrap;">${lecture.content}</p>
            </div>
        </sec:authorize>

        <div class="mt-4 pt-4 border-top">
            <a href="/download/lecture/${lecture.id}" class="file-download-link">
                <img src="https://cdn-icons-png.flaticon.com/512/337/337946.png" class="file-icon" alt="pdf">
                <span style="font-size: 17px; font-weight: 500;">${lecture.title}.pdf</span>
                <svg class="download-arrow" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                    <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/>
                </svg>
            </a>
        </div>
    </div>

    <div class="ui-card">
        <h2 style="font-size: 24px; font-weight: 600; margin-bottom: 25px;">Comments / Discussion</h2>

        <jsp:include page="/WEB-INF/jsp/components/comment-section.jsp" />

    </div>
</div>

<c:if test="${not empty message}">
    <script>
        alert("${message}");
    </script>
</c:if>

</body>
</html>