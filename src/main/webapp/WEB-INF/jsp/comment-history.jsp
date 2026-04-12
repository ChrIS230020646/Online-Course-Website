<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>My Review History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/comment-history.css">

    <style>
        body { background-color: #f8f9fa; }
        .bg-primary-soft { background-color: #e7f0ff; }
        .card { transition: transform 0.2s; }
        .card:hover { transform: translateY(-3px); }
        .sort-btn { border-radius: 20px; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-9">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold m-0">My Review History</h2>
                    <p class="text-muted small">Manage the record of your speaking under the various courses</p>
                </div>

                <div class="dropdown">
                    <button class="btn btn-white shadow-sm dropdown-toggle sort-btn" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-sort-down"></i>
                        <c:choose>
                            <c:when test="${currentSort == 'lecture'}">lecture</c:when>
                            <c:otherwise>time</c:otherwise>
                        </c:choose>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><h6 class="dropdown-header">Sort by time</h6></li>
                        <li><a class="dropdown-item ${currentSort == 'commentTime' && currentDir == 'desc' ? 'active' : ''}" href="?sortBy=commentTime&dir=desc">Latest priority</a></li>
                        <li><a class="dropdown-item ${currentSort == 'commentTime' && currentDir == 'asc' ? 'active' : ''}" href="?sortBy=commentTime&dir=asc">Earliest priority</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><h6 class="dropdown-header">Sort by Name</h6></li>
                        <li><a class="dropdown-item ${currentSort == 'lecture' && currentDir == 'asc' ? 'active' : ''}" href="?sortBy=lecture&dir=asc">lecture Name (A-Z)</a></li>
                        <li><a class="dropdown-item ${currentSort == 'lecture' && currentDir == 'desc' ? 'active' : ''}" href="?sortBy=lecture&dir=desc">lecture Name (Z-A)</a></li>
                    </ul>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty historyList}">
                    <div class="text-center py-5 bg-white rounded shadow-sm border">
                        <i class="bi bi-chat-dots text-light" style="font-size: 4rem;"></i>
                        <p class="mt-3 text-muted">There are no review records yet！</p>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-sm">view Lecture</a>
                    </div>
                </c:when>
<c:otherwise>
    <c:forEach items="${historyList}" var="cmt">
        <%-- Force the current cmt into the request scope to ensure that the subpage must read --%>
        <c:set var="cmt" value="${cmt}" scope="request" />

        <div class="comment-item-container">
            <%@ include file="/WEB-INF/jsp/components/_comment-item.jsp" %>
        </div>
    </c:forEach>
</c:otherwise></c:choose>

            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/courses" class="btn btn-link text-decoration-none text-muted">
                    <i class="bi bi-arrow-left"></i> Home Page
                </a>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>