<!--comment-section.jsp-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="container mt-5">
    <hr>
   <!-- <jsp:include page="_add-comment.jsp" />-->

    <jsp:include page="/WEB-INF/jsp/components/_add-comment.jsp">
        <jsp:param name="type" value="${param.type}" />
        <jsp:param name="targetId" value="${param.targetId}" />
    </jsp:include>

    <jsp:include page="_display-comments.jsp" >
        <jsp:param name="type" value="${param.type}" />
        <jsp:param name="targetId" value="${param.targetId}" />
    </jsp:include>


<script>
lecture-comment-section.jsp
function toggleReplyForm(id) {
    const form = document.getElementById('reply-form-' + id);
    if (form) {
        form.style.display = (form.style.display === 'none') ? 'block' : 'none';
    }
}
</script>