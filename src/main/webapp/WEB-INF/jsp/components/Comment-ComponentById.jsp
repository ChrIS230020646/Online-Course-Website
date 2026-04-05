<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!--header-->
<div class="comment-detail-view p-4 border rounded shadow-sm bg-white">
    <div class="d-flex justify-content-between">
        <h3>Comment Information</h3>
        <a href="/lectures/${lectureId}" class="btn btn-outline-secondary btn-sm">Back to Lecture</a>
       <!-- <a href="/comment/lectures/${lectureId}" class="btn btn-outline-secondary btn-sm">Back to Lecture</a>-->
    </div>
    <hr>
<!--id and time -->
    <div class="info-group mb-3">
        <span class="badge bg-primary">System ID: ${cmt.id}</span>
        <span class="ms-2 text-muted">Posted on: ${cmt.commentTime}</span>
    </div>
<!--Author -->
    <div class="user-info mb-3">
        <strong>Author:</strong> <span class="text-info">@${cmt.user.username}</span>
    </div>
<!--description -->
    <div class="content-box p-3 bg-light rounded mb-4">
        <strong>Content:</strong>
        <p class="mt-2 lead">${cmt.description}</p>
    </div>
<div class="content-box p-3 bg-light rounded mb-4">
    <strong>lectureId:</strong>
    <p class="mt-2 lead">${lectureId}</p>
</div>

    <c:if test="${not empty cmt.replies}">
        <div class="replies-section">
            <h5>Replies to this comment:</h5>
            <ul class="list-group">
                <c:forEach var="reply" items="${cmt.replies}">
                    <li class="list-group-item">
                        <strong>@${reply.user.username}:</strong> ${reply.description}
                        <br><small class="text-muted">Reply ID: ${reply.id}</small>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </c:if>
</div>