<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 這裡完全不用再寫任何 getParameter 或 param --%>
<div class="card mb-4 shadow-sm border-0">
    <div class="card-header bg-white d-flex justify-content-between align-items-center border-bottom-0 pt-3">
        <span class="badge bg-primary-soft text-primary">
            Lecture: ${not empty cmt.lecture.title ? cmt.lecture.title : 'General'}
        </span>
        <small class="text-muted">${cmt.commentTime}</small>
    </div>

    <div class="card-body">
        <c:if test="${not empty cmt.parentComment}">
             <%-- 如果 reply-context 也是片段，建議也用靜態包含 --%>
             <%@ include file="_reply-context.jsp" %>
        </c:if>

        <div class="my-comment px-2 mt-3">
            <h6 class="fw-bold mb-2">
                <i class="bi ${not empty cmt.parentComment ? 'bi-reply-fill text-primary' : 'bi-chat-left-text-fill text-success'}"></i>
                ${not empty cmt.parentComment ? 'My reply:' : 'My comment:'}
            </h6>
            <p class="text-dark">${cmt.description}</p>
        </div>

        <div class="d-flex justify-content-end gap-2 mt-3">
            <a href="${pageContext.request.contextPath}/course-material-page/${cmt.lecture.id}" class="btn btn-sm btn-outline-secondary">
                View original text
            </a>
            <form action="${pageContext.request.contextPath}/comment/delete/${cmt.id}" method="post"
                  onsubmit="return confirm('確定要刪除嗎？');" style="display:inline;">
                <input type="hidden" name="lectureId" value="${cmt.lecture.id}">
                <input type="hidden" name="from" value="history">
                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
            </form>
        </div>
    </div>
</div>