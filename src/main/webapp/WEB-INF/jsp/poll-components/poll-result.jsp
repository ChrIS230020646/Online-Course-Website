<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<button class="btn btn-sm btn-light border-0 mb-1 d-flex align-items-center js-poll-trigger${pollId}"
        type="button">
    <span id="poll-arrow">▼</span>
</button>

<div class="collapse show" id="pollCollapse">
    <div id="poll-box" class="p-2 border rounded shadow-sm bg-white" style="width: 280px; display: none;">
        <div id="poll-options-list"></div>
        <div class="text-end mt-1" style="border-top: 1px solid #eee; padding-top: 4px;">
            <small class="text-muted" style="font-size: 0.65rem;">Total: <span id="poll-total">0</span></small>
        </div>
    </div>
</div>

<script>
// --- 原有邏輯保持不變 ---
function loadPollResults(pollId) {
    console.log("[Poll Log] Fetching data for ID:", pollId);
    fetch('/polls/api/polls/' + pollId + '/results')
        .then(response => response.json())
        .then(poll => {
            const total = poll.totalVotes || 0;
            const pollBox = document.getElementById('poll-box');
            const collapseEl = document.getElementById('pollCollapse');

            if (total === 0) {
                collapseEl.parentElement.style.display = 'none';
                return;
            }

            const listContainer = document.getElementById('poll-options-list');
            listContainer.innerHTML = '';

            (poll.options || []).forEach((opt, i) => {
                const v = (poll.votes && poll.votes[i] !== undefined) ? poll.votes[i] : 0;
                const p = total > 0 ? ((v * 100) / total).toFixed(1) : 0;

                const row = document.createElement('div');
                row.className = 'd-flex align-items-center mb-1';
                row.style.gap = '6px';

                const label = document.createElement('div');
                label.style.cssText = 'width: 50px; font-size: 0.7rem; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;';
                label.textContent = opt;

                const progWrap = document.createElement('div');
                progWrap.className = 'flex-grow-1 progress';
                progWrap.style.height = '8px';
                const bar = document.createElement('div');
                bar.className = 'progress-bar bg-primary';
                bar.style.width = p + '%';
                progWrap.appendChild(bar);

                const data = document.createElement('div');
                data.className = 'text-primary fw-bold';
                data.style.cssText = 'width: 70px; text-align: right; font-size: 0.7rem;';
                data.textContent = v + ' (' + p + '%)';

                row.append(label, progWrap, data);
                listContainer.appendChild(row);
            });

            document.getElementById('poll-total').textContent = total;
            pollBox.style.display = 'block';
        });
}

// --- 2. 使用 jQuery 改寫監聽部分 ---
$(function() {
    console.log("[Poll Log] Controller Initialized");

    // A. 監聽點擊事件 (取代原本的 toggleManualCollapse)
    $(document).on('click', '.js-poll-trigger${pollId}', function() {
        const $collEl = $('#pollCollapse');
        const $arrow = $('#poll-arrow');

        // 透過 Bootstrap 實例控制摺疊
        const bsColl = bootstrap.Collapse.getOrCreateInstance($collEl[0]);
        bsColl.toggle();

        // 動畫結束後切換箭頭方向 (使用 .one 確保不重複綁定)
        $collEl.one('hidden.bs.collapse', () => {
            $arrow.text('▶');
            console.log("[Poll Log] Panel Closed");
        });
        $collEl.one('shown.bs.collapse', () => {
            $arrow.text('▼');
            console.log("[Poll Log] Panel Opened");
        });
    });

    // B. 初始化數據加載 (取代原本的 DOMContentLoaded)
    let id = '${poll.id}';

    if (!id || id === '' || id.includes('$')) {
        const pathSegments = window.location.pathname.split('/');
        id = pathSegments[pathSegments.length - 1];
    }

    if (id && !isNaN(id)) {
        loadPollResults(id);
    } else {
        console.error("[Poll Log] Invalid ID:", id);
        if ($('#poll-q').length) $('#poll-q').text("Error: ID not found");
    }
});
</script>