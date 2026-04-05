<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- Add Comment Form Component --%>
<sec:authorize access="isAuthenticated()">
    <div class="card mb-4 mt-3 shadow-sm">
        <div class="card-body">
            <h5 class="card-title">Leave a Comment</h5>
            <form action="/comment/lectures/${lectureId}/add-comment" method="post">
                <%-- CSRF Token 必須包含 --%>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="form-group">
                    <textarea name="description" class="form-control"
                              rows="3" placeholder="What's on your mind?" required></textarea>
                </div>
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary btn-sm mt-2 px-4">Post Comment</button>
                </div>
            </form>
        </div>
    </div>
</sec:authorize>

<sec:authorize access="isAnonymous()">
    <div class="alert alert-info">
        Please <a href="/login">login</a> to join the discussion.
    </div>
</sec:authorize>