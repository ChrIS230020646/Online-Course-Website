<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="comment-detail-view p-4 border rounded shadow-sm bg-white">
    <div class="d-flex justify-content-between align-items-center">
        <h3>Comment Information</h3>
        <a href="/lectures/${lectureId}" class="btn btn-outline-secondary btn-sm">Back to Lecture</a>
    </div>
    <hr>

    <div class="info-group mb-3 d-flex align-items-center">
        <span class="badge bg-primary">System ID: ${cmt.id}</span>

        <%-- 重點：加入回覆對象 ID --%>
        <c:if test="${not empty cmt.parentComment}">
            <span class="badge bg-info ms-2">Replying to ID: ${cmt.parentComment.id}</span>
        </c:if>

        <span class="ms-3 text-muted">Posted on: ${cmt.commentTime}</span>
    </div>

    <div class="user-info mb-3">
        <strong>Author:</strong>
        <span class="text-info">@${cmt.user.username}</span>

        <%-- 如果有父級留言，顯示回覆對象的名稱 --%>
        <c:if test="${not empty cmt.parentComment}">
            <span class="text-muted ms-1">replied to</span>
            <span class="fw-bold text-dark">@${cmt.parentComment.user.username}</span>
        </c:if>
    </div>

    <div class="content-box p-3 bg-light rounded mb-4">
        <strong>Content:</strong>
        <p class="mt-2 lead">${cmt.description}</p>
    </div>

    <div class="content-box p-3 bg-light rounded mb-4">
        <strong>Lecture ID:</strong>
        <p class="mt-2 mb-0">${lectureId}</p>
    </div>

    <c:if test="${not empty cmt.replies}">
        <div class="replies-section">
            <h5 class="mb-3">Replies to this comment:</h5>
            <ul class="list-group shadow-sm">
                <c:forEach var="reply" items="${cmt.replies}">
                    <li class="list-group-item">
                        <div class="d-flex justify-content-between">
                            <strong>@${reply.user.username}:</strong>
                            <small class="text-muted">ID: ${reply.id}</small>
                        </div>
                        <p class="mb-1 mt-1">${reply.description}</p>
                        <small class="text-muted" style="font-size: 0.75rem;">${reply.commentTime}</small>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </c:if>
</div>