<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Global Poll Activity Analysis</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/showAllPolls.css">

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
        <form action="/logout" method="post" style="display:inline; margin-left:25px;">
            <button type="submit" class="btn-logout" style="border:none; background:none; cursor:pointer; font-weight:500;">Logout</button>
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
    <div class="text-center mb-5">
        <!--<a href="${pageContext.request.contextPath}/" class="btn-back">
            <i class="bi bi-chevron-left"></i>
        </a>-->
        <h1 class="page-title">Poll Monitoring</h1>
    </div>



<c:forEach var="poll" items="${pollHistory2}">
    <div class="ui-card static mb-4" style="border-radius: 20px; padding: 25px; transition: transform 0.2s;">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/course/view?cid=${poll.courseId}"
                   class="badge-course text-decoration-none" style="cursor: pointer;">
                    <i class="bi bi-book me-1"></i> CID: ${poll.courseId}
                </a>
                <span class="small text-muted" style="background: #f2f2f7; padding: 4px 10px; border-radius: 6px;">
                    <i class="bi bi-person-circle me-1"></i> Author: <strong>${poll.createdBy}</strong>
                </span>
            </div>

            <div class="d-flex align-items-center gap-3">
                <span class="small text-muted font-monospace" style="font-size: 11px;">
                    POLL_ID: <strong class="${empty poll.voters ? 'text-danger' : 'text-primary'}">${poll.pollId}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/polls/courses/${poll.courseId}/poll/${poll.pollId}"
                   class="btn-action-circle" title="View Detail">
                    <i class="bi bi-arrow-up-right-circle-fill" style="font-size: 20px; color: #0071e3;"></i>
                </a>
            </div>
        </div>

        <h3 class="fw-bold mb-4" style="font-size: 24px; color: #1d1d1f; line-height: 1.2;">
            ${poll.pollQuestion}
        </h3>

        <c:if test="${not empty poll.voters}">
            <div class="mb-4">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <label class="text-secondary small fw-bold text-uppercase" style="letter-spacing: 1px;">Participation Log</label>
                    <span class="badge bg-primary-subtle text-primary border-0" style="border-radius: 6px; font-size: 11px;">
                        ${poll.voters.size()} RESPONSES
                    </span>
                </div>

                <div class="voter-details-section" style="background: #f5f5f7; border-radius: 16px; padding: 20px;">
                    <div class="row g-3">
                        <c:forEach var="voter" items="${poll.voters}">
                            <div class="col-md-4">
                                <div class="p-3 d-flex align-items-center"
                                     style="background: white; border-radius: 12px; border: 1px solid #e5e5ea; box-shadow: 0 4px 6px rgba(0,0,0,0.02);">

                                    <div style="width: 36px; height: 36px; background: #0071e3; color: white; border-radius: 50%;
                                                display: flex; align-items: center; justify-content: center; font-weight: 600; margin-right: 12px;">
                                        ${voter.username.substring(0,1).toUpperCase()}
                                    </div>

                                    <div style="min-width: 0;">
                                        <div class="fw-bold text-dark mb-0" style="font-size: 14px;">${voter.username}</div>
                                        <div class="text-truncate" style="font-size: 12px; color: #0071e3;">
                                            <i class="bi bi-check-circle-fill me-1" style="font-size: 10px;"></i>
                                            ${voter.optionText}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>



    </div>
</c:forEach>
</div>

</body>
</html>