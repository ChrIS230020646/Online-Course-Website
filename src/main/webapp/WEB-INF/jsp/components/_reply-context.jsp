<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty cmt.parentComment}">
    <div class="p-2 mb-2 border-start border-3 border-secondary bg-light" style="font-size: 0.85rem;">
        <div class="text-muted mb-1">
            <i class="bi bi-reply-fill"></i>
            Replying to <strong>${cmt.parentComment.user.username}</strong>:
        </div>
        <div class="fst-italic text-truncate">
            "${cmt.parentComment.description}"
        </div>
    </div>
</c:if>