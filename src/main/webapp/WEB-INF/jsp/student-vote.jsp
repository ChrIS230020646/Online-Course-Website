<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Vote: ${poll.question}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .poll-card { border-radius: 15px; border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .option-box {
            padding: 15px; border: 1px solid #dee2e6; border-radius: 10px;
            margin-bottom: 15px; transition: 0.3s;
        }
        .option-box:hover { background-color: #f8f9fa; border-color: #0d6efd; }
        .progress { height: 10px; border-radius: 5px; margin-top: 10px; }
    </style>
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="card poll-card mx-auto" style="max-width: 700px;">
        <div class="card-body p-5">
            <a href="/courses/${courseId}" class="btn btn-link p-0 mb-4 text-decoration-none">
                <i class="bi bi-chevron-left"></i> Back to Course
            </a>

            <h2 class="fw-bold mb-1">${poll.question}</h2>
            <p class="text-muted mb-4">Total Participation: ${totalVotes} votes</p>

            <form action="/polls/${poll.id}/vote" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <c:forEach var="option" items="${poll.options}" varStatus="status">
                    <c:set var="idx" value="${status.index}" />
                    <c:set var="count" value="${voteCounts[idx]}" />
                    <c:set var="percent" value="${totalVotes > 0 ? (count * 100 / totalVotes) : 0}" />

                    <div class="option-box">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="form-check">
                                <%-- check userChoice --%>
                                <input class="form-check-input" type="radio" name="optionIndex"
                                       id="opt-${idx}" value="${idx}" required
                                       ${userChoice == idx ? 'checked' : ''}>
                                <label class="form-check-label fw-bold" for="opt-${idx}">
                                    ${option}
                                </label>
                            </div>
                            <span class="badge bg-light text-dark border">
                                ${count} ticket (${percent}%)
                            </span>
                        </div>

                        <%-- progressbar --%>
                        <div class="progress">
                            <div class="progress-bar bg-primary" role="progressbar"
                                 style="width: ${percent}%"></div>
                        </div>
                    </div>
                </c:forEach>

                <div class="text-center mt-5">
                    <button type="submit" class="btn btn-primary btn-lg px-5 w-100 shadow-sm" style="border-radius: 10px;">
                        <i class="bi bi-check2-circle"></i>
                        ${userChoice != -1 ? 'Update My Vote' : 'Submit Vote'}
                    </button>
                    <c:if test="${userChoice != -1}">
                        <p class="mt-2 text-success small">
                            <i class="bi bi-info-circle"></i> You have already voted. Submitting again will update your choice.
                        </p>
                    </c:if>
                </div>
            </form>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/jsp/components/comment-section.jsp" >
    <jsp:param name="type" value="poll" />
    <jsp:param name="targetId" value="${poll.id}" />
</jsp:include>
</body>
</html>