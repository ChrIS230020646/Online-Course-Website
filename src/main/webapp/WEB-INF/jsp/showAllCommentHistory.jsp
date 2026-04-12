<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>All Comment History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/showAllCommentHistory.css">


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
    <!-- <div class="text-center mb-5">
        <a href="${pageContext.request.contextPath}/" class="btn-back">
            <i class="bi bi-chevron-left"></i>
        </a>
        <h1 class="page-title"><i class="bi bi-activity me-2"></i>All Comment History</h1>
        <p style="color: var(--text-secondary);">Review system-wide student comments.</p>
    </div>-->


    <div class="text-center mb-5">
        <ul class="nav nav-pills" id="pills-tab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="pills-comments-tab" data-bs-toggle="pill"
                        data-bs-target="#tab-comments" type="button" role="tab" aria-selected="true">
                    <i class="bi bi-chat-fill me-2"></i>Comments (${commentHistory.size()})
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="pills-polls-tab" data-bs-toggle="pill"
                        data-bs-target="#tab-polls" type="button" role="tab" aria-selected="false">
                    <i class="bi bi-check2-square me-2"></i>Poll Activities (${pollHistory.size()})
                </button>
            </li>
        </ul>
    </div>

    <div class="tab-content" id="pills-tabContent">
        <div class="tab-pane fade show active" id="tab-comments" role="tabpanel" aria-labelledby="pills-comments-tab">
            <c:choose>
                <c:when test="${empty commentHistory}">
                    <div class="ui-card static text-center empty-state-box">
                        <i class="bi bi-chat-dots" style="font-size: 48px;"></i>
                        <p class="mt-3">No comments recorded.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="cmt" items="${commentHistory}">
                        <div class="ui-card static mb-4">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="badge-user">
                                    <i class="bi bi-person-circle me-2" style="font-size: 18px;"></i>
                                    <span>@${cmt.username}</span>
                                </div>
                                <div class="timestamp">
                                    <i class="bi bi-clock me-1"></i>
                                    <fmt:parseDate value="${cmt.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="d" />
                                    <fmt:formatDate value="${d}" pattern="yyyy-MM-dd HH:mm" />
                                </div>
                            </div>

                            <label>LECTURE SOURCE</label>
                            <h3 class="fw-bold mb-3" style="font-size: 18px;" >${cmt.lectureTitle}</h3>

                            <div class="p-3 mb-3" style="background: var(--site-bg); border-radius: 14px; font-size: 16px;">
                                ${cmt.content}
                            </div>

                            <div class="text-end">
                                <a href="${pageContext.request.contextPath}/course-material-page/${cmt.lectureID}" class="btn-link-custom">
                                    View Discussion <i class="bi bi-arrow-up-right"></i>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="tab-pane fade" id="tab-polls" role="tabpanel" aria-labelledby="pills-polls-tab">
            <c:choose>
                <c:when test="${empty pollHistory}">
                    <div class="ui-card static text-center empty-state-box">
                        <i class="bi bi-clipboard-x" style="font-size: 48px;"></i>
                        <p class="mt-3">No poll activities found.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="poll" items="${pollHistory}">
                        <div class="ui-card static mb-4" style="border-left: 6px solid var(--brand-blue);">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="badge-user">
                                    <i class="bi bi-person-badge me-2" style="font-size: 18px;"></i>
                                    <span>@${poll.voterName}</span>
                                </div>
                                <div class="timestamp text-muted">
                                    <fmt:parseDate value="${poll.voteTime}" pattern="yyyy-MM-dd'T'HH:mm" var="pv" />
                                    <fmt:formatDate value="${pv}" pattern="yyyy-MM-dd HH:mm" />
                                </div>
                            </div>

                            <div class="p-4" style="border: 1px solid var(--border-color); border-radius: 18px; background: #fafafa;">
                                <label class="mb-2">POLL QUESTION</label>
                                <div class="fw-bold mb-3" style="font-size: 17px; color: var(--text-primary);">${poll.pollQuestion}</div>

                                <div class="d-inline-flex align-items-center px-3 py-2"
                                     style="color: var(--brand-blue); background: rgba(0,113,227,0.08); border-radius: 10px; font-weight: 600;">
                                    <i class="bi bi-check-circle-fill me-2"></i>
                                    Voted: ${poll.selectedOption}
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const triggerTabList = document.querySelectorAll('#pills-tab button');
        triggerTabList.forEach(triggerEl => {
            const tabTrigger = new bootstrap.Tab(triggerEl);
            triggerEl.addEventListener('click', function (event) {
                event.preventDefault();
                tabTrigger.show();
            });
        });
    });
</script>

</body>
</html>