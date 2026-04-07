<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- /WEB-INF/jsp/components/_comment-item.jsp --%>
<div class="card mb-4 shadow-sm border-0" style="border-radius: 15px; overflow: hidden;">
    <div class="card-header bg-white d-flex justify-content-between align-items-center border-0 pt-3 px-4">
        <span class="badge rounded-pill bg-primary-soft text-primary">
            Lecture: ${cmt.lecture.title}
        </span>
        <small class="text-muted">ID: ${cmt.id} | ${cmt.commentTime}</small>
    </div>

    <div class="card-body px-4">
        <%-- 區塊 A: 被回覆的上下文 (只有是回覆時才顯示) --%>
        <c:if test="${not empty cmt.parentComment}">
            <div class="reply-context p-3 mb-3 bg-light border-start border-primary border-4" style="border-radius: 0 8px 8px 0;">
                <div class="d-flex align-items-center mb-1">
                    <i class="bi bi-reply-all-fill me-2 text-primary"></i>
                    <small class="text-muted">Replying to</small>
                    <strong class="ms-1 text-dark">@${cmt.parentComment.user.username}</strong>
                    <span class="ms-2 badge bg-white border text-muted" style="font-size: 0.65rem;">ID: ${cmt.parentComment.id}</span>
                </div>
                <p class="mb-0 text-muted small" style="font-style: italic;">"${cmt.parentComment.description}"</p>
            </div>
        </c:if>

        <%-- 區塊 B: 我的留言內容 --%>
        <div class="my-comment mt-2">
            <h6 class="fw-bold mb-2">
                <i class="bi ${not empty cmt.parentComment ? 'bi-chat-right-dots text-primary' : 'bi-chat-left-text text-success'} me-2"></i>
                ${not empty cmt.parentComment ? 'My Reply:' : 'My Comment:'}
            </h6>

            <%-- 這裡顯示 Description。注意：如果 description 內自帶 @user，會顯示出來 --%>
            <p class="text-dark fs-6">${cmt.description}</p>
        </div>

        <%-- 操作區 --%>
        <div class="d-flex justify-content-end gap-2 mt-3 pb-2">
            <a href="${pageContext.request.contextPath}/course-material-page/${cmt.lecture.id}" class="btn btn-sm btn-outline-secondary rounded-pill px-3">
                View in Lecture
            </a>
            <form action="${pageContext.request.contextPath}/comment/delete/${cmt.id}" method="post" class="m-0">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-sm btn-danger rounded-pill px-3" onclick="return confirm('Delete this record?')">Delete</button>
            </form>
        </div>
    </div>
</div>