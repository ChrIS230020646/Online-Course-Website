<!--comment-section.jsp-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="container mt-5">
    <hr>
    <jsp:include page="_add-comment.jsp" />
    <jsp:include page="_display-comments.jsp" />
</div>

<script>
// 統一管理 JS 邏輯
function toggleReplyForm(id) {
    const form = document.getElementById('reply-form-' + id);
    if (form) {
        form.style.display = (form.style.display === 'none') ? 'block' : 'none';
    }
}
</script>