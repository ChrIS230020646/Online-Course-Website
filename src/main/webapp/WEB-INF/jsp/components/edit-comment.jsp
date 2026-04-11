<%-- /WEB-INF/jsp/components/edit-comment.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div id="edit-form-${param.commentId}" style="display:none;" class="mt-2">
<form action="${pageContext.request.contextPath}/comment/edit" method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="commentId" value="${param.commentId}"/>
        <input type="hidden" name="type" value="${param.type}"/>
        <input type="hidden" name="targetId" value="${param.targetId}"/>

        <textarea name="description" class="form-control form-control-sm mb-2"
                  style="background: #f5f5f7; border-radius: 12px; border: none; padding: 10px;" required>${param.currentContent}</textarea>

        <div class="d-flex gap-2">
            <button type="submit" class="btn btn-primary btn-sm px-3" style="border-radius: 20px; background: #0071e3;">Save</button>
            <button type="button" class="btn btn-light btn-sm px-3" style="border-radius: 20px; border: 1px solid #d2d2d7;"
                    onclick="toggleEdit('${param.commentId}')">Cancel</button>
        </div>
    </form>
</div>