<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="discussion-container">
    <h4 class="mb-4" style="font-weight: 600; color: #1d1d1f;">
        Course Discussion (${commentList != null ? commentList.size() : 0})
    </h4>

    <div class="comment-stack">
        <c:forEach var="cmt" items="${commentList}">
            <%-- 主留言區塊 --%>
            <div class="comment-item py-4 border-bottom" id="comment-${cmt.id}">
                <div class="d-flex justify-content-between align-items-start">
                    <div class="user-info d-flex align-items-center">
                        <div class="avatar me-2" style="width: 36px; height: 36px; background: #e8e8ed; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #0071e3; font-weight: bold;">
                            ${cmt.user.username.substring(0,1).toUpperCase()}
                        </div>
                        <div>
                            <div style="font-weight: 600;">@${cmt.user.username}</div>
                            <div style="font-size: 0.75rem; color: #86868b;">${cmt.commentTime}</div>
                        </div>
                    </div>

                    <%-- 主留言刪除功能 --%>
                    <c:set var="isAuthor" value="${pageContext.request.userPrincipal.name == cmt.user.username}" />
                    <sec:authorize access="hasRole('TEACHER')" var="isTeacher" />
                    <c:if test="${isTeacher || isAuthor}">
                        <form action="${pageContext.request.contextPath}/comment/lectures/delete/${cmt.id}" method="post" class="m-0">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="lectureId" value="${lectureId}"/>
                            <button type="submit" class="btn btn-link text-danger p-0" style="font-size: 0.8rem; text-decoration: none; opacity: 0.7;" onclick="return confirm('Confirm delete?')">Delete</button>
                        </form>
                    </c:if>
                </div>

                <div class="comment-content mt-3" style="color: #424245; font-size: 0.95rem;">
                    ${cmt.description}
                </div>

                <%-- 主留言 Reply 按鈕 --%>
                <div class="mt-2">
                    <sec:authorize access="isAuthenticated()">
                        <button class="btn btn-link p-0" style="font-size: 0.85rem; text-decoration: none;"
                                onclick="prepareReply('${cmt.id}', '${cmt.user.username}')">Reply</button>
                    </sec:authorize>
                </div>

                <%-- 該討論串公用的回覆輸入框 --%>
                <div id="reply-form-${cmt.id}" class="mt-3 ms-4" style="display:none;">
                    <form action="${pageContext.request.contextPath}/comment/lectures/${lectureId}/add-comment" method="post" class="d-flex flex-column gap-2">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="parentId" value="${cmt.id}"/>

                        <div id="reply-label-${cmt.id}" class="badge bg-light text-dark align-self-start" style="display:none; font-weight: normal; padding: 5px 10px; border-radius: 10px;"></div>

                        <div class="d-flex gap-2">
                            <input type="text" name="description" id="input-${cmt.id}" class="form-control form-control-sm border-0"
                                   style="background: #f5f5f7; border-radius: 20px; padding-left: 15px;"
                                   placeholder="Write your reply..." required>
                            <button type="submit" class="btn btn-primary btn-sm px-3" style="border-radius: 20px; background: #0071e3;">Send</button>
                        </div>
                    </form>
                </div>

                <%-- 二級回覆列表 --%>
                <c:if test="${not empty cmt.replies}">
                    <div class="replies-list ms-4 mt-3 ps-3" style="border-left: 2px solid #f5f5f7;">
                        <c:forEach var="reply" items="${cmt.replies}">
                            <div class="reply-item mb-2 p-3" style="background: #fafafa; border-radius: 12px;">
                                <div class="d-flex justify-content-between align-items-start mb-1">
                                    <strong style="font-size: 0.85rem; color: #1d1d1f;">@${reply.user.username}</strong>

                                    <div class="d-flex gap-2 align-items-center">
                                        <%-- 二級回覆 Reply 按鈕 --%>
                                        <sec:authorize access="isAuthenticated()">
                                            <button class="btn btn-link p-0" style="font-size: 0.75rem; text-decoration: none;"
                                                    onclick="prepareReply('${cmt.id}', '${reply.user.username}')">Reply</button>
                                        </sec:authorize>

                                        <%-- 二級回覆刪除按鈕 (已修正位置與判斷邏輯) --%>
                                        <c:set var="isReplyAuthor" value="${pageContext.request.userPrincipal.name == reply.user.username}" />
                                        <c:if test="${isTeacher || isReplyAuthor}">
                                            <form action="${pageContext.request.contextPath}/comment/lectures/delete/${reply.id}" method="post" class="m-0">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <input type="hidden" name="lectureId" value="${lectureId}"/>
                                                <button type="submit" class="btn btn-link text-danger p-0" style="font-size: 0.75rem; text-decoration: none; opacity: 0.7;" onclick="return confirm('Confirm delete?')">Delete</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                                <div style="font-size: 0.9rem; color: #424245;">${reply.description}</div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</div>

<script>
function prepareReply(mainId, targetUser) {
    const formDiv = document.getElementById('reply-form-' + mainId);
    const input = document.getElementById('input-' + mainId);
    const label = document.getElementById('reply-label-' + mainId);

    formDiv.style.display = 'block';
    label.innerText = 'Replying to @' + targetUser;
    label.style.display = 'inline-block';
    input.value = '@' + targetUser + ' ';
    input.focus();
}

</script>