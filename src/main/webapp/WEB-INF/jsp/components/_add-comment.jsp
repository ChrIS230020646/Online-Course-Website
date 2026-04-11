<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Add Comment Form Component --%>
<sec:authorize access="isAuthenticated()">
    <div class="add-comment-wrapper mb-5 p-4" style="background: #ffffff; border-radius: 20px; box-shadow: 0 8px 24px rgba(0,0,0,0.04); border: 1px solid #f2f2f7;">
        <div id="commentForm">
            <input type="hidden" id="csrfToken" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-group">
                <textarea id="commentDescription" name="description" class="form-control border-0"
                          rows="3" style="background: #f5f5f7; border-radius: 14px; padding: 18px; resize: none; font-size: 0.95rem;"
                          placeholder="What are your thoughts on this content?" required></textarea>
            </div>
            <div class="d-flex justify-content-end mt-3">
                <button type="button" onclick="sendComment('${param.type}', ${param.targetId})" class="btn btn-primary px-4 py-2"
                        style="background: #0071e3; border: none; border-radius: 24px; font-weight: 500; font-size: 0.9rem; transition: all 0.2s ease;">
                    Post Comment
                </button>
            </div>
        </div>
    </div>
</sec:authorize>

<sec:authorize access="isAnonymous()">
    <div class="text-center py-4 mb-5" style="background: #f5f5f7; border-radius: 18px; color: #86868b; font-size: 0.95rem;">
        Please <a href="${pageContext.request.contextPath}/login" style="color: #0071e3; text-decoration: none; font-weight: 600;">Sign in</a> to participate in the discussion.
    </div>
</sec:authorize>

<script>
function sendComment(type, id) {
    const descriptionField = document.getElementById('commentDescription');
    const description = descriptionField.value;
    const csrfToken = document.getElementById('csrfToken').value;

    console.log("Sending to:", type, id); // Debug
    console.log("Content:", description);

    if (!description.trim()) {
        alert("Please enter a comment.");
        return;
    }

    const params = new URLSearchParams();
    params.append('description', description);

    // params.append('parentId', '');

    fetch(`${pageContext.request.contextPath}/comment/` + type + `/` + id + `/add-ajax`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-TOKEN': csrfToken
        },
        body: params.toString()
    })
    .then(async response => {
        if (response.ok) {
            descriptionField.value = '';
            location.reload();
        } else {

            const errorText = await response.text();
            alert("Failed (Status: " + response.status + "): " + errorText);
        }
    })
    .catch(error => console.error('Fetch error:', error));
}
</script>