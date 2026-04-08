<%-- 使用 poll.id 確保在 Loop 中每個表單 ID 是唯一的 --%>
<form id="delete-form-${poll.id}" action="${pageContext.request.contextPath}/polls/delete/${poll.id}" method="post" style="display:none;">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<a href="javascript:void(0);"
   class="text-danger ms-2"
   onclick="if(confirm('Delete?')) { document.getElementById('delete-form-${poll.id}').submit(); }">
   Delete
</a>