<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- 1. 權限與身分判斷 --%>
<sec:authentication property="principal.username" var="currentUsername" />
<c:set var="isInstructor" value="${poll.course.instructor.username == currentUsername}" />

<!DOCTYPE html>
<html>
<head>
    <title>Poll Detail - ${poll.question}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/poll-detail.css">



</head>
<body class="bg-light">

<div class="container py-5">
    <div class="ui-card bg-white p-5 shadow-sm">
        <%-- 返回按鈕 --%>
        <a href="/courses/${courseId}" class="btn btn-link mb-3 p-0 text-decoration-none">❮ Back to Course</a>

        <%-- 2. 投票標題區域 --%>
        <div class="poll-header mb-5">
            <c:choose>
                <c:when test="${isInstructor}">
                    <%-- 老師可編輯標題 --%>
                    <div onclick="toggleEdit('q-text', 'q-form')" id="q-text" class="editable-area">
                        <h2 class="fw-bold">${poll.question} <i class="bi bi-pencil-square text-muted fs-6"></i></h2>
                    </div>
                    <form id="q-form" action="/polls/${poll.id}/edit-question" method="post" style="display:none;" class="mt-2">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="input-group">
                            <input type="text" name="newQuestion" class="form-control form-control-lg" value="${poll.question}" required>
                            <button class="btn btn-primary">Save</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="toggleEdit('q-text', 'q-form')">Cancel</button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <h2 class="fw-bold">${poll.question}</h2>
                </c:otherwise>
            </c:choose>
            <p class="text-muted">Total: <strong>${totalVotes}</strong> votes</p>
        </div>

        <%-- 3. 投票與選項區域 --%>
        <form action="/polls/${poll.id}/vote" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <c:forEach var="i" begin="0" end="4">
                <c:set var="v" value="${poll.votes[i]}" />
                <c:set var="p" value="${totalVotes > 0 ? (v * 100 / totalVotes) : 0}" />

                <div class="poll-option-item">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center">
                                <%-- Radio Button (所有人均可投票/修改投票) --%>
                                <div class="form-check me-2">
                                    <input class="form-check-input" type="radio" name="optionIndex" id="radio-${i}" value="${i}" required>
                                </div>

                                <c:choose>
                                    <c:when test="${isInstructor}">
                                        <%-- 老師：可點擊文字編輯內容 --%>
                                        <div onclick="toggleEdit('opt-t-${i}', 'opt-f-${i}')" id="opt-t-${i}" class="editable-area">
                                            <label class="fw-bold mb-0 cursor-pointer" for="radio-${i}">
                                                ${poll.options[i]} <i class="bi bi-pencil text-muted small"></i>
                                            </label>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <label class="fw-bold mb-0 cursor-pointer" for="radio-${i}">${poll.options[i]}</label>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- 老師專用的選項編輯表單 (獨立於投票 Form 外，透過 JS 觸發) --%>
                            <c:if test="${isInstructor}">
                                <div id="opt-f-${i}" style="display:none;" class="mt-2">
                                    <div class="input-group input-group-sm w-75">
                                        <input type="text" id="input-opt-${i}" class="form-control" value="${poll.options[i]}">
                                        <button type="button" class="btn btn-success" onclick="saveOption(${poll.id}, ${i})">OK</button>
                                        <button type="button" class="btn btn-light border" onclick="toggleEdit('opt-t-${i}', 'opt-f-${i}')">Cancel</button>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <%-- 右側票數顯示 --%>
                        <span class="text-primary fw-bold">${v} votes (${p}%)</span>
                    </div>

                    <%-- 進度條 --%>
                    <div class="progress">
                        <div class="progress-bar" style="width: ${p}%"></div>
                    </div>
                </div>
            </c:forEach>

            <%-- 投票提交按鈕 --%>
            <div class="text-center mt-5">
                <button type="submit" class="btn btn-primary btn-lg px-5 shadow-sm" style="border-radius: 30px;">
                    <i class="bi bi-check2-circle"></i> Submit My Vote
                </button>
            </div>
        </form>
    </div>
</div>

<script>
// 切換編輯與顯示模式
function toggleEdit(textId, formId) {
    const textElem = document.getElementById(textId);
    const formElem = document.getElementById(formId);
    if (textElem.style.display === 'none') {
        textElem.style.display = 'block';
        formElem.style.display = 'none';
    } else {
        textElem.style.display = 'none';
        formElem.style.display = 'block';
        const input = formElem.querySelector('input');
        input.focus();
        const val = input.value;
        input.value = '';
        input.value = val;
    }
}

// 老師編輯單個選項的 AJAX 邏輯 (避免嵌套 Form 衝突)
function saveOption(pollId, index) {
    const newText = document.getElementById('input-opt-' + index).value;
    const formData = new URLSearchParams();
    formData.append('index', index);
    formData.append('newOptionText', newText);
    formData.append('${_csrf.parameterName}', '${_csrf.token}');

    fetch('/polls/' + pollId + '/edit-option', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData.toString()
    }).then(response => {
        if (response.ok) {
            location.reload();
        } else {
            alert("Update failed!");
        }
    });
}
</script>

</body>
</html>