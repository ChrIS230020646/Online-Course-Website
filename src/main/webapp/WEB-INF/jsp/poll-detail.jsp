<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- 1. Permissions and Identity Judgment--%>
<sec:authentication property="principal.username" var="currentUsername" />
<c:set var="isInstructor" value="${poll.instructor}" />

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
<nav class="main-nav">
    <div class="d-flex align-items-center">
        <a href="/profile" class="text-decoration-none d-flex align-items-center">
            <img src="${pageContext.request.userPrincipal != null ? currentUser.profilePicture : 'https://ui-avatars.com/api/?name=User'}"
                 alt="Avatar"
                 style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 2px solid #eee;">
            <span class="ms-2 fw-bold" style="color: #333;">
                ${currentUser.fullName}
            </span>
        </a>
    </div>
    <div class="nav-links">
        <a href="/courses">All Courses</a>
        <sec:authorize access="hasRole('STUDENT')">
            <a href="/my-courses">My Learning</a>
        </sec:authorize>
        <form action="/logout" method="post" style="display:inline; margin-left:25px;">
            <button type="submit" class="btn-logout" style="border:none; background:none; cursor:pointer; font-weight:500;">Logout</button>
        </form>
        <a href="/history/comment/all" class="nav-history-link">
                            <span class="badge rounded-pill bg-info-subtle text-info-emphasis">All Comment History</span>
                        </a>
                        <a href="/history/poll/all" class="nav-history-link">
                            <span class="badge rounded-pill bg-primary-subtle text-primary-emphasis">All Poll History</span>
                        </a>
    </div>
</nav>
<div class="ui-container">
<div class="container py-5">
    <div class="ui-card bg-white p-5 shadow-sm">
        <%--<%--Back Button--%>
        <a href="/courses/${courseId}" class="btn btn-link mb-3 p-0 text-decoration-none">❮</a>


        <div class="poll-header mb-5">
            <c:choose>
                <c:when test="${isInstructor}">
                        <%--Teacher can edit the title--%>
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

        <%-- 3. Voting and Options Area --%>
        <form action="/polls/${poll.id}/vote" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <c:forEach var="i" begin="0" end="4">
                <c:set var="v" value="${poll.votes[i]}" />
                <c:set var="p" value="${poll.totalVotes > 0 ? (v * 100.0 / poll.totalVotes) : 0}" />

                <div class="poll-option-item">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center">
                               <%-- Radio Button (everyone can vote/modify their vote) --%>
                                <div class="form-check me-2">
                                    <input class="form-check-input" type="radio" name="optionIndex" id="radio-${i}" value="${i}" required>
                                </div>

                                <c:choose>
                                    <c:when test="${isInstructor}">
                                        <%--Teacher: Text can be edited by click--%>
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

                            <%--Teacher-specific options to edit form (triggered via JS, independent of voting Form) --%>
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

                        <%--The votes on the right are displayed--%>
                        <span class="text-primary fw-bold">${v} votes (${p}%)</span>
                    </div>

                    <%--progress bar--%>
                    <div class="progress">
                        <div class="progress-bar" style="width: ${p}%"></div>
                    </div>
                </div>
            </c:forEach>

           <%--Vote Submit Button--%>
            <div class="text-center mt-5">
                <button type="submit" class="btn btn-primary btn-lg px-5 shadow-sm" style="border-radius: 30px;">
                    <i class="bi bi-check2-circle"></i> Submit My Vote
                </button>
            </div>
        </form>
    </div>
    </div>
<div class="ui-container">

<jsp:include page="/WEB-INF/jsp/components/comment-section.jsp" >
    <jsp:param name="type" value="poll" />
    <jsp:param name="targetId" value="${poll.id}" />
</jsp:include>
</div>
<script>
// Switch between editing and display modes
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

// Teacher edits AJAX logic for a single option (to avoid nested Form conflicts)
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