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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>${lecture.title} - Course Material</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .file-box {
            display: flex; align-items: center; justify-content: space-between;
            background: #f8f9fa; padding: 15px; border-radius: 12px; border: 1px solid #eee;
            transition: all 0.2s; margin-bottom: 12px; border-left: 4px solid #dee2e6;
        }
        .file-box:hover { background: #fefefe; border-color: #0071e3; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .file-info { display: flex; align-items: center; gap: 12px; text-decoration: none; color: #333; flex: 1; overflow: hidden; }
        .file-info:hover { color: #0071e3; }
        .file-info span { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        .btn-delete-item { color: #ff3b30; border: none; background: none; font-size: 22px; padding: 0 10px; cursor: pointer; line-height: 1; }
        .btn-delete-item:hover { color: #d70015; transform: scale(1.2); }

        .url-name { font-size: 13px; color: #0071e3; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .upload-section { background: #fff; border: 2px dashed #dee2e6; padding: 20px; border-radius: 12px; text-align: center; margin-top: 20px; }
    </style>

    <script>
        (function() {
            const currentPath = window.location.pathname;
            const referrer = document.referrer;
            if (referrer && !referrer.includes(currentPath)) {
                sessionStorage.setItem('lecture_back_url', referrer);
            }
        })();

        function handleSmartBack() {
            const backUrl = sessionStorage.getItem('lecture_back_url');
            if (backUrl) {
                window.location.href = backUrl;
            } else {
                window.location.href = '/courses/${lecture.course.id}';
            }
        }
    </script>
</head>
<body class="bg-light">

<c:set var="rawContent" value="${lecture.content}" />
<c:set var="displayDesc" value="${rawContent}" />
<c:set var="urlList" value="" />

<c:if test="${fn:contains(rawContent, '|||')}">
    <c:set var="parts" value="${fn:split(rawContent, '|||')}" />
    <c:set var="displayDesc" value="${parts[0]}" />
    <c:set var="urlList" value="${fn:trim(parts[1])}" />
</c:if>

<nav class="main-nav">
    <div class="d-flex align-items-center">
        <a href="/profile" class="text-decoration-none d-flex align-items-center">
            <img src="${currentUser.profilePicture}" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%;">
            <span class="ms-2 fw-bold" style="color: #333;">${currentUser.fullName}</span>
        </a>
    </div>
    <div class="nav-links">
        <a href="/courses">All Courses</a>
        <a href="javascript:void(0)" onclick="handleSmartBack()">Back</a>
    </div>
</nav>

<div class="ui-container">

    <a href="javascript:void(0)" onclick="handleSmartBack()" class="btn-back">❮</a>

    <div class="ui-card mb-4">
        <sec:authorize access="hasRole('TEACHER')">
            <form action="/course-material-page/${lecture.id}/update" method="post" id="mainUpdateForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="mb-4">
                    <label class="fw-bold text-muted small">LECTURE TITLE</label>
                    <input type="text" name="title" class="form-control form-control-lg border-0 bg-light" value="${lecture.title}" required>
                </div>
                <div class="mb-4">
                    <label class="fw-bold text-muted small">DESCRIPTION (TEXT ONLY)</label>
                    <textarea id="editDesc" class="form-control border-0 bg-light" rows="4">${displayDesc}</textarea>
                </div>
                <div class="mb-4">
                    <label class="fw-bold text-muted small">EXTERNAL LINKS (ONE PER LINE)</label>
                    <textarea id="editUrlList" class="form-control border-0 bg-light" rows="3">${urlList}</textarea>
                </div>
                <input type="hidden" name="content" id="finalContentField">
                <div class="d-flex justify-content-between align-items-center">
                    <span class="text-muted small">Edit content and links.</span>
                    <button type="submit" onclick="prepareSubmit()" class="btn btn-primary rounded-pill px-5">Save Changes</button>
                </div>
            </form>
        </sec:authorize>

        <sec:authorize access="hasRole('STUDENT')">
                <c:choose>
                    <c:when test="${isEnrolled}">
            <h1 style="font-weight: 700; margin-bottom: 20px;">${lecture.title}</h1>
            <div class="mt-2 mb-4" style="font-size: 17px; line-height: 1.7; white-space: pre-wrap; color: #444;">${displayDesc}</div>
                    </c:when>
                    <c:otherwise>
                            <div class="d-flex justify-content-center">
                                <h1 class="page-title mb-5">You DO NOT have permission to access this page</h1>
                            </div>
                            <div class="d-flex justify-content-center">
                                <a href="/courses" class="btn-primary-custom">Back to Courses</a>
                            </div>
                    </c:otherwise>
                </c:choose>
        </sec:authorize>

        <hr class="my-5">
        <h5 class="mb-4 text-muted" style="font-size: 13px; font-weight: 700;">ATTACHED MATERIALS & LINKS</h5>

        <c:if test="${not empty urlList}">
            <c:forEach var="link" items="${fn:split(urlList, ' ')}">
                <c:set var="trimmedLink" value="${fn:trim(link)}" />
                <c:if test="${not empty trimmedLink and fn:startsWith(trimmedLink, 'http')}">
                    <c:set var="d" value="${fn:replace(fn:replace(fn:replace(trimmedLink, 'https://', ''), 'http://', ''), 'www.', '')}" />
                    <c:set var="domain" value="${fn:substringBefore(d, '/')}" />
                    <c:if test="${empty domain}"><c:set var="domain" value="${d}" /></c:if>
                    <div class="file-box" style="border-left: 4px solid #0071e3;">
                        <a href="${trimmedLink}" target="_blank" class="file-info">
                            <img src="https://cdn-icons-png.flaticon.com/512/44/44386.png" width="30" alt="web">
                            <div>
                                <span class="url-name">${domain}</span><br>
                                <small class="text-muted" style="font-size: 11px;">${trimmedLink}</small>
                            </div>
                        </a>
                        <sec:authorize access="hasRole('TEACHER')">
                            <button type="button" class="btn-delete-item" onclick="removeLink('${trimmedLink}')" title="Delete Link">×</button>
                        </sec:authorize>
                    </div>
                </c:if>
            </c:forEach>
        </c:if>

        <c:if test="${not empty lecture.fileName}">
            <c:set var="fnLower" value="${fn:toLowerCase(lecture.fileName)}" />
            <c:choose>
                <c:when test="${fn:endsWith(fnLower, '.pdf')}"><c:set var="fileIcon" value="https://cdn-icons-png.flaticon.com/512/337/337946.png" /></c:when>
                <c:when test="${fn:endsWith(fnLower, '.doc') || fn:endsWith(fnLower, '.docx')}"><c:set var="fileIcon" value="https://cdn-icons-png.flaticon.com/512/337/337932.png" /></c:when>
                <c:when test="${fn:endsWith(fnLower, '.xls') || fn:endsWith(fnLower, '.xlsx')}"><c:set var="fileIcon" value="https://cdn-icons-png.flaticon.com/512/337/337958.png" /></c:when>
                <c:when test="${fn:endsWith(fnLower, '.ppt') || fn:endsWith(fnLower, '.pptx')}"><c:set var="fileIcon" value="https://cdn-icons-png.flaticon.com/512/337/337949.png" /></c:when>
                <c:when test="${fn:endsWith(fnLower, '.zip') || fn:endsWith(fnLower, '.rar')}"><c:set var="fileIcon" value="https://cdn-icons-png.flaticon.com/512/337/337941.png" /></c:when>
                <c:otherwise><c:set var="fileIcon" value="https://cdn-icons-png.flaticon.com/512/337/337956.png" /></c:otherwise>
            </c:choose>
            <div class="file-box" style="border-left: 4px solid #ff9500;">
                <a href="/download/lecture/${lecture.id}" class="file-info">
                    <img src="${fileIcon}" width="30" alt="file">
                    <span class="fw-bold">${lecture.fileName}</span>
                    <svg width="18" height="18" fill="#0071e3" viewBox="0 0 16 16" class="ms-2"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>
                </a>
                <sec:authorize access="hasRole('TEACHER')">
                    <form action="/course-material-page/${lecture.id}/delete-file" method="post" class="m-0">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn-delete-item" onclick="return confirm('Delete this file?')">×</button>
                    </form>
                </sec:authorize>
            </div>
        </c:if>

        <sec:authorize access="hasRole('TEACHER')">
            <div class="upload-section">
                <p class="text-muted mb-3 small fw-bold">UPLOAD / REPLACE FILE</p>
                <form action="/course-material-page/${lecture.id}/upload" method="post" enctype="multipart/form-data" class="m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="input-group" style="max-width: 500px; margin: 0 auto;">
                        <input type="file" name="file" class="form-control" required>
                        <button type="submit" class="btn btn-dark">Upload</button>
                    </div>
                </form>
            </div>
        </sec:authorize>
    </div>
</div>
<c:choose>
    <c:when test="${isEnrolled}">
<div class="ui-container">
<jsp:include page="/WEB-INF/jsp/components/comment-section.jsp" >
    <jsp:param name="type" value="lecture" />
    <jsp:param name="targetId" value="${lecture.id}" />
</jsp:include>
</div>
</c:when>
<c:otherwise>
</c:otherwise>
</c:choose>
<script>
    function prepareSubmit() {
        const desc = document.getElementById('editDesc').value;
        const urls = document.getElementById('editUrlList').value.trim();
        const formattedUrls = urls.replace(/\n/g, ' ');
        document.getElementById('finalContentField').value = formattedUrls ? (desc + "|||" + formattedUrls) : desc;
    }

    function removeLink(linkToDelete) {
        if(confirm('Remove this link?')) {
            const urlTextArea = document.getElementById('editUrlList');
            let urls = urlTextArea.value.split(/\n| /);
            urls = urls.filter(u => u.trim() !== linkToDelete.trim() && u.trim() !== "");
            urlTextArea.value = urls.join('\n');

            prepareSubmit();
            document.getElementById('mainUpdateForm').submit();
        }
    }
</script>

<c:if test="${not empty message}">
    <script>alert("${message}");</script>
</c:if>
</body>
</html>




