<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- Display Comments List Component --%>
<div class="comment-list-container">
    <h4 class="mb-4">Comments (${commentList != null ? commentList.size() : 0})</h4>

    <div class="comment-list">
        <c:forEach var="cmt" items="${commentList}">
            <%-- 每一條主留言 --%>
            <div class="main-comment border-bottom py-3" id="comment-${cmt.id}">
                <div class="d-flex justify-content-between align-items-center">
                    <span>
                        <strong class="text-primary">@${cmt.user.username}</strong>
                        <small class="text-muted ms-2">${cmt.commentTime}</small>
                    </span>

                    <%-- 刪除按鈕 (只限老師或本人) --%>
                    <sec:authorize access="hasRole('TEACHER') or (isAuthenticated() and authentication.name == cmt.user.username)">
                        <form action="/comment/delete/${cmt.id}" method="post" class="d-inline">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="lectureId" value="${lectureId}"/>
                            <button type="submit" class="btn btn-link btn-sm text-danger p-0"
                                    onclick="return confirm('Delete this comment?')">Delete</button>
                        </form>
                    </sec:authorize>
                </div>

                <p class="mt-2 mb-1">${cmt.description}</p>

                <%-- 回覆按鈕與隱藏表單 --%>
                <sec:authorize access="isAuthenticated()">
                    <button class="btn btn-sm btn-light py-0 mt-1" onclick="toggleReplyForm(${cmt.id})">Reply</button>

                    <div id="reply-form-${cmt.id}" class="ms-4 mt-2" style="display:none;">
                        <form action="/comment/lectures/${lectureId}/add-comment" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="parentId" value="${cmt.id}"/>
                            <div class="input-group">
                                <input type="text" name="description" class="form-control form-control-sm"
                                       placeholder="Write a reply..." required>
                                <button type="submit" class="btn btn-primary btn-sm">Send</button>
                            </div>
                        </form>
                    </div>
                </sec:authorize>

                <%-- 回覆列表 (嵌套) --%>
                <c:if test="${not empty cmt.replies}">
                    <div class="replies ms-5 mt-3 border-start ps-3">
                        <c:forEach var="reply" items="${cmt.replies}">
                            <div class="reply-item mb-2 p-2 bg-light rounded shadow-sm">
                                <div class="d-flex justify-content-between">
                                    <strong class="small">@${reply.user.username}</strong>
                                    <sec:authorize access="hasRole('TEACHER') or (isAuthenticated() and authentication.name == reply.user.username)">
                                        <form action="/comment/delete/${reply.id}" method="post" class="d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <input type="hidden" name="lectureId" value="${lectureId}"/>
                                            <button type="submit" class="btn btn-link btn-sm text-danger p-0">×</button>
                                        </form>
                                    </sec:authorize>
                                </div>
                                <p class="mb-0 small text-secondary">${reply.description}</p>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</div>