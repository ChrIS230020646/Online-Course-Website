<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- Add Comment Form Component --%>
<sec:authorize access="isAuthenticated()">
    <div class="add-comment-wrapper mb-5 p-4" style="background: #ffffff; border-radius: 20px; box-shadow: 0 8px 24px rgba(0,0,0,0.04); border: 1px solid #f2f2f7;">
        <!--<h5 class="mb-3" style="font-weight: 600; color: #1d1d1f; letter-spacing: -0.02em;">Leave a Comment</h5>-->
        <form action="${pageContext.request.contextPath}/comment/lectures/${lectureId}/add-comment" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-group">
                <textarea name="description" class="form-control border-0"
                          rows="3" style="background: #f5f5f7; border-radius: 14px; padding: 18px; resize: none; font-size: 0.95rem;"
                          placeholder="What are your thoughts on this lecture?" required></textarea>
            </div>
            <div class="d-flex justify-content-end mt-3">
                <button type="submit" class="btn btn-primary px-4 py-2"
                        style="background: #0071e3; border: none; border-radius: 24px; font-weight: 500; font-size: 0.9rem; transition: all 0.2s ease;">
                    Post Comment
                </button>
            </div>
        </form>
    </div>
</sec:authorize>

<sec:authorize access="isAnonymous()">
    <div class="text-center py-4 mb-5" style="background: #f5f5f7; border-radius: 18px; color: #86868b; font-size: 0.95rem;">
        Please <a href="${pageContext.request.contextPath}/login" style="color: #0071e3; text-decoration: none; font-weight: 600;">Sign in</a> to participate in the discussion.
    </div>
</sec:authorize>