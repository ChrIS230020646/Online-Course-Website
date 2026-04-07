<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lecture Detail - ${lecture.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <%-- 確保你的 static/css 目錄下有這個檔案 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .lecture-content {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            min-height: 200px;
            white-space: pre-wrap; /* 保持換行 */
        }
    </style>
</head>
<body>
<div class="alert alert-info">
    測試資訊：目前登入用戶為
    <strong>
        <sec:authentication property="principal.username" />
    </strong>
</div>
<div class="ui-container mt-5">
    <%-- 返回按鈕 --%>
    <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-secondary mb-4">❮ Back to Courses</a>

    <div class="ui-card static p-4 shadow-sm">
        <%-- 1. 課程標題 --%>
        <h1 class="page-title mb-3">${lecture.title != null ? lecture.title : "Default Lecture Title (Testing)"}</h1>

        <p class="text-secondary mb-4">
            Lecture ID: <strong>${lectureId}</strong>
        </p>

        <hr>

        <%-- 2. 課程內文顯示區 --%>
        <div class="lecture-body mb-5">
            <h5>Lecture Content:</h5>
            <div class="lecture-content border mt-2">
                ${lecture.content != null ? lecture.content : "Here is the sample content for testing purposes. If you see this, the 'lecture' object might be null in your Model."}
            </div>
        </div>

        <hr>

        <%-- 3. 評論區塊 (這是你之前噴 500 錯誤的地方，請確保路徑正確) --%>


<jsp:include page="/WEB-INF/jsp/components/comment-section.jsp" />

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>