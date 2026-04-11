<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Poll Management & History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="header mb-4">
        <h1 class="page-title">Poll Management & History</h1>
        <p class="text-secondary">Track your created polls and your participation.</p>
    </div>

    <div class="mb-5">
        <h3>Polls Created by You</h3>
        <c:choose>
            <c:when test="${empty createdPolls}">
                <div class="card p-3 bg-light text-center">
                    <p class="mb-0">You haven't created any polls yet.</p>
                </div>card
            </c:when>
            <c:otherwise>
<div class="table-responsive shadow-sm" style="border-radius: 12px; overflow: hidden;">
    <table class="table table-hover align-middle mb-0">
        <thead class="table-dark">
            <tr>
                <th class="ps-4">Course</th>
                <th>Poll Question / Statistics (Top 5 Options)</th>
                <th class="text-end pe-4">Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="poll" items="${createdPolls}">
                <tr>
                    <td class="ps-4">
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill">
                            ${poll.course.title}
                        </span>
                    </td>
                    <td>
                        <div class="fw-bold mb-2">${poll.question}</div>


                        <div class="d-flex flex-wrap gap-2">
                            <c:forEach var="i" begin="0" end="4">
                                <c:set var="v" value="${poll.votes[i]}" />
                                <c:set var="p" value="${poll.totalVotes > 0 ? (v * 100.0 / poll.totalVotes) : 0}" />

                                <div class="p-1 px-2 border rounded bg-light" style="font-size: 0.75rem;">
                                    <span class="text-muted">Opt ${i+1}:</span>
                                    <strong class="text-primary">${v}</strong>
                                    <span class="text-secondary">(<fmt:formatNumber value="${p}" maxFractionDigits="1"/>%)</span>
                                </div>
                            </c:forEach>
                        </div>
                    </td>
                    <td class="text-end pe-4">
                        <a href="/polls/courses/${poll.course.id}/poll/${poll.id}?type=poll&targetId=${poll.id}"
                           class="btn btn-sm btn-info text-white rounded-pill px-3">
                            View Full Statistics
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
            </c:otherwise>
        </c:choose>
    </div>

    <hr>

    <div class="mt-5">
        <h3>Your Voting Participation</h3>
        <c:choose>
            <c:when test="${empty participationHistory}">
                <div class="card p-3 bg-light text-center">
                    <p class="mb-0">You haven't participated in any polls yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table border">
                        <thead class="table-light">
                            <tr>
                                <th>Course</th>
                                <th>Poll Question</th>
                                <th>Your Choice</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="response" items="${participationHistory}">
                                <tr>
                                    <td>${response.poll.course.title}</td>
                                    <td><strong>${response.poll.question}</strong></td>
                                    <td><span class="badge bg-success">${response.selectedOptionText}</span></td>
                                    <td>
                                        <a href="/polls/courses/${response.poll.course.id}/poll/${response.poll.id}" class="btn btn-sm btn-outline-primary">View Results</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="mt-4 mb-5">
        <a href="/courses" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</div>
</body>
</html>