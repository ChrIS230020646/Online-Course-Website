<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 8/4/2026
  Time: 18:36
  To change this template use File | Settings | File Templates.
--%>
<form id="delete-form-${lecture.id}" action="${pageContext.request.contextPath}/course-material-page/delete/${lecture.id}" method="post" style="display:none;">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<a href="javascript:void(0);"
   class="text-danger ms-2"
   onclick="if(confirm('Delete?')) { document.getElementById('delete-form-${lecture.id}').submit(); }">
    Delete
</a>