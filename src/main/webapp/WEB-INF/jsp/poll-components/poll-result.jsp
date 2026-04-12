<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<div class="poll-wrapper mb-3" data-poll-id="${param.pollId}">
    <button class="btn btn-sm btn-light border-0 d-flex align-items-center js-poll-btn"
            type="button">
        <span class="js-arrow">▶</span>
        <span class="ms-1">View Results</span>
    </button>

    <div class="collapse  js-collapse-body">
        <div class="p-2 border rounded shadow-sm bg-white js-poll-box" style="width: 280px; display: none;">
            <div class="js-options-list"></div>
            <div class="text-end mt-1" style="border-top: 1px solid #eee; padding-top: 4px;">
                <small class="text-muted" style="font-size: 0.65rem;">
                    Total: <span class="js-total-count">0</span>
                </small>
            </div>
        </div>
    </div>
</div>

<script>

function loadPollResults(pollId, $container) {
    console.log(`[Poll Log][Fetch] Data is requesting ID: ${pollId}`);

    fetch('/polls/api/polls/' + pollId + '/results')
        .then(response => response.json())
        .then(poll => {
            const total = poll.totalVotes || 0;
            const $pollBox = $container.find('.js-poll-box');

            const $listContainer = $container.find('.js-options-list');
            // [Critical Fix] Get a native DOM node to use appendChild
            const listContainer = $listContainer[0];

            if (total === 0) {
                $container.hide();
                return;
            }

            // Empty old content (using jQuery syntax)
            $listContainer.empty();

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

                // Now the listContainer has been defined as $listContainer[0]
                listContainer.appendChild(row);
            });

            $container.find('.js-total-count').text(total);
            $pollBox.show();
            console.log(`[Poll Log][UI] ID: ${pollId} Rendering completed`);
        })
        .catch(err => console.error(`[Poll Log][Error] ID: ${pollId} Loading failed:`, err));
}

$(function() {
    console.log("[Poll Log] Controller Initialized - The system starts successfully");

    // A. Fixed click listening: Uses Class selector and handles animation synchronization
    $(document).on('click', '.js-poll-btn', function() {
        const $btn = $(this);
        const $wrapper = $btn.closest('.poll-wrapper');
        const pollId = $wrapper.data('poll-id');
        const $collEl = $wrapper.find('.js-collapse-body');
        const $arrow = $btn.find('.js-arrow');

        console.log(`[Poll Log][Event] Click Trigger - Target ID: ${pollId}`);

        const bsColl = bootstrap.Collapse.getOrCreateInstance($collEl[0]);
        bsColl.toggle();

        // Listen to Bootstrap’s built-in events to switch arrows
        $collEl.one('hidden.bs.collapse', () => {
            $arrow.text('▶');
            console.log(`[Poll Log][Event] ID: ${pollId} The folding panel is closed`);
        });
        $collEl.one('shown.bs.collapse', () => {
            $arrow.text('▼');
            console.log(`[Poll Log][Event] ID: ${pollId} The folding panel is open`);
        });
    });


    $('.poll-wrapper').each(function() {
        const $item = $(this);
        let pid = $item.data('poll-id');

        if (!pid || pid === '' || pid.toString().includes('$')) {
            const segments = window.location.pathname.split('/');
            pid = segments[segments.length - 1];
            console.log(`[Poll Log][Init] Grab ID from URL: ${pid}`);
        }

        if (pid && !isNaN(pid)) {
            loadPollResults(pid, $item);
        } else {
            console.error(`[Poll Log][Init] Unable to identify valid ID: ${pid}`);
        }
    });
});
</script>