<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Poll Management & History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .poll-stat-pill {
            display: inline-flex;
            align-items: center;
            background: var(--site-bg);
            border: 1px solid var(--border-color);
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 13px;
            margin-right: 8px;
            margin-bottom: 8px;
        }

        .badge-course {
            background: rgba(0, 113, 227, 0.1);
            color: var(--brand-blue);
            padding: 4px 12px;
            border-radius: 980px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .participation-choice {
            color: #34c759; /* Apple Success Green */
            font-weight: 600;
            background: rgba(52, 199, 89, 0.1);
            padding: 4px 10px;
            border-radius: 6px;
        }

        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 24px;
            margin-top: 40px;
        }

        .section-header i {
            font-size: 24px;
            margin-right: 12px;
            color: var(--brand-blue);
        }
    </style>
</head>
<body>

<div class="ui-container">
    <div class="text-center mb-5">
        <a href="${pageContext.request.contextPath}/" class="btn-back">
            <i class="bi bi-chevron-left"></i>
        </a>
        <h1 class="page-title">Poll Management</h1>
        <p style="color: var(--text-secondary);">Track your created polls and participation activity.</p>
    </div>

    <div class="section-header">
        <i class="bi bi-pencil-square"></i>
        <h2 class="section-title mb-0">Polls Created by You</h2>
    </div>

    <c:choose>
        <c:when test="${empty createdPolls}">
            <div class="ui-card static text-center py-5">
                <i class="bi bi-inbox text-secondary" style="font-size: 40px;"></i>
                <p class="mt-3 text-secondary">You haven't created any polls yet.</p>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="poll" items="${createdPolls}">
                <div class="ui-card static mb-4">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <span class="badge-course">${poll.course.title}</span>
                        <div class="text-end">
                            <span class="small text-muted">Total Votes: <strong>${poll.totalVotes}</strong></span>
                        </div>
                    </div>

                    <h3 class="fw-bold mb-3" style="font-size: 20px;">${poll.question}</h3>

                    <div class="mb-4">
                        <label class="d-block mb-2">TOP 5 RESULTS</label>
                        <div class="d-flex flex-wrap">
                            <c:forEach var="i" begin="0" end="4">
                                <c:set var="v" value="${poll.votes[i]}" />
                                <c:set var="p" value="${poll.totalVotes > 0 ? (v * 100.0 / poll.totalVotes) : 0}" />
                                <div class="poll-stat-pill">
                                    <span class="text-secondary me-2">Option ${i+1}:</span>
                                    <span class="fw-bold me-1">${v}</span>
                                    <span class="text-muted small">(<fmt:formatNumber value="${p}" maxFractionDigits="1"/>%)</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="text-end">
                        <a href="${pageContext.request.contextPath}/polls/courses/${poll.courseId}/poll/${poll.id}?type=poll&targetId=${poll.id}"
                           class="btn-link-custom">
                            View Detailed Analysis <i class="bi bi-arrow-right-short"></i>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <div class="section-header">
        <i class="bi bi-person-check"></i>
        <h2 class="section-title mb-0">Your Participation</h2>
    </div>

    <c:choose>
        <c:when test="${empty participationHistory}">
            <div class="ui-card static text-center py-5">
                <i class="bi bi-clipboard-x text-secondary" style="font-size: 40px;"></i>
                <p class="mt-3 text-secondary">No participation history found.</p>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="response" items="${participationHistory}">
                <div class="ui-card static mb-3" style="padding: 24px; border-left: 5px solid #34c759;">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <span class="badge-course mb-2 d-inline-block">${response.poll.course.title}</span>
                            <div class="fw-bold" style="font-size: 17px;">${response.poll.question}</div>
                            <div class="mt-2">
                                <span class="text-secondary small">Your Choice:</span>
                                <span class="participation-choice ms-1">
                                    <i class="bi bi-check2-circle"></i> ${response.selectedOptionText}
                                </span>
                            </div>
                        </div>
                        <div class="col-md-4 text-end mt-3 mt-md-0">
                            <a href="/polls/courses/${response.poll.course.id}/poll/${response.poll.id}"
                               class="btn-link-custom" style="font-size: 15px;">
                                View Final Results <i class="bi bi-chevron-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <div class="mt-5 mb-5 text-center">
        <a href="/courses" class="btn-link-custom" style="font-size: 18px;">
            <i class="bi bi-house-door me-2"></i>Return to Dashboard
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>