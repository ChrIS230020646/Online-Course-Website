<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<c:choose>

    <c:when test="${cmt.targetType == 'lecture'}">
        <c:set var="areaColor" value="primary" />
        <c:set var="areaIcon" value="bi-book-half" />
        <c:set var="areaLabel" value="Lecture" />

        <c:set var="targetTitle" value="${not empty cmt.lecture ? cmt.lecture.title : 'Lecture ID: '.concat(cmt.targetId)}" />
        <c:set var="viewUrl" value="${pageContext.request.contextPath}/course-material-page/${cmt.targetId}" />
    </c:when>



 <c:when test="${cmt.targetType == 'poll'}">
     <c:set var="areaColor" value="success" />
     <c:set var="areaIcon" value="bi-patch-check" />
     <c:set var="areaLabel" value="Poll" />


     <c:set var="targetPoll" value="${pollMap[cmt.targetId]}" />

     <c:choose>
         <c:when test="${not empty targetPoll}">
             <c:set var="targetTitle" value="${targetPoll.question}" />

             <c:set var="viewUrl" value="${pageContext.request.contextPath}/polls/courses/${targetPoll.course.id}/poll/${targetPoll.id}?type=poll&targetId=${targetPoll.id}" />
         </c:when>
         <c:otherwise>
             <c:set var="targetTitle" value="Survey Discussion (ID: ${cmt.targetId})" />
             <c:set var="viewUrl" value="#" />
         </c:otherwise>
     </c:choose>
 </c:when>


    <c:otherwise>
        <c:set var="areaColor" value="info" />
        <c:set var="areaIcon" value="bi-chat-quote" />
        <c:set var="areaLabel" value="General" />
        <c:set var="targetTitle" value="Main Forum" />
        <c:set var="viewUrl" value="${pageContext.request.contextPath}/" />
    </c:otherwise>
</c:choose>


<div class="card mb-4 shadow-sm border-0"
     style="border-radius: 16px; border-left: 6px solid var(--bs-${areaColor}) !important;">

    <div class="card-header bg-white d-flex justify-content-between align-items-center border-0 pt-3 px-4">
        <div>
            <span class="badge rounded-pill" style="background-color: rgba(var(--bs-${areaColor}-rgb), 0.1); color: var(--bs-${areaColor}); font-weight: 600;">
                <i class="bi ${areaIcon} me-1"></i> ${areaLabel}
            </span>
            <span class="ms-2 text-dark fw-bold" style="font-size: 0.85rem;">${targetTitle}</span>
        </div>
        <small class="text-muted" style="font-size: 0.75rem;">${cmt.commentTime}</small>
    </div>

    <div class="card-body px-4">

        <c:if test="${not empty cmt.parentComment}">
            <div class="p-2 mb-3 bg-light border-start border-3" style="border-radius: 8px; font-size: 0.85rem;">
                <small class="text-muted">Reply to @${cmt.parentComment.user.username}:</small>
                <p class="mb-0 text-muted text-truncate" style="font-style: italic;">"${cmt.parentComment.description}"</p>
            </div>
        </c:if>

        <div class="my-comment">
            <p class="text-dark mb-0" style="font-size: 0.95rem; line-height: 1.5;">${cmt.description}</p>
        </div>

        <div class="d-flex justify-content-end gap-2 mt-3 pb-2">
            <a href="${viewUrl}" class="btn btn-sm btn-light rounded-pill px-3" style="font-size: 0.8rem;">
                <i class="bi bi-arrow-right-short"></i> View source page
            </a>

            <form action="${pageContext.request.contextPath}/comment/delete/${cmt.id}" method="post" class="m-0">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <button type="submit" class="btn btn-sm btn-outline-danger border-0" onclick="return confirm('Delete this comment?')">
                    <i class="bi bi-trash3"></i>
                </button>
            </form>
        </div>
    </div>
</div>