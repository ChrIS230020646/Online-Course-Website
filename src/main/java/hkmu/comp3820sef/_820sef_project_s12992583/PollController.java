package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.*;
import hkmu.comp3820sef._820sef_project_s12992583.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/polls")
public class PollController {

    @Autowired
    private PollRepository pollRepository;
    @Autowired
    private PollResponseRepository pollResponseRepository;
    @Autowired
    private UserRepository userRepository;

    private static final Logger log = LoggerFactory.getLogger(PollController.class);

    // 1. 查看投票詳情 (包含即時票數統計)
    @GetMapping("/courses/{courseId}/poll/{pollId}")
    public String viewPoll(@PathVariable Long courseId, @PathVariable Long pollId,
                           Authentication auth, Model model) {

        log.info(">>>> [Poll Debug] Starting access check for User: {}", auth.getName());

        Poll poll = pollRepository.findById(pollId).orElseThrow(() ->
                new IllegalArgumentException("Invalid poll Id:" + pollId));

        // 獲取當前登入者
        String currentLoginUser = auth.getName();

        // --- 權限診斷 Log ---
        boolean isInstructor = false;
        if (poll.getCourse() != null && poll.getCourse().getInstructor() != null) {
            String courseInstructorName = poll.getCourse().getInstructor().getUsername();

            // 核心比對細節
            isInstructor = courseInstructorName.equalsIgnoreCase(currentLoginUser);

            log.info(">>>> [Comparison Detail]");
            log.info("     - Logged in as: [{}]", currentLoginUser);
            log.info("     - Course Instructor is: [{}]", courseInstructorName);
            log.info("     - Match Result: {}", isInstructor);
        } else {
            log.warn(">>>> [Data Error] Course or Instructor is NULL for this poll!");
        }

        // 執行統計邏輯 (保持不變)
        List<PollResponse> allResponses = pollResponseRepository.findByPoll(poll);
        int[] voteCounts = new int[poll.getOptions().size()];
        for (PollResponse r : allResponses) {
            int idx = r.getSelectedOptionIndex();
            if (idx >= 0 && idx < voteCounts.length) voteCounts[idx]++;
        }

        model.addAttribute("poll", poll);
        model.addAttribute("courseId", courseId);
        model.addAttribute("isInstructor", isInstructor);
        model.addAttribute("voteCounts", voteCounts);
        model.addAttribute("totalVotes", allResponses.size());


        String target = isInstructor ? "poll-detail" : "student-vote";
        log.info(">>>> [View Selection] Final decision: Redirecting to -> {}.jsp", target);

        return target;
    }


    @Transactional
    @PostMapping("/{pollId}/vote")
    public String handleVote(@PathVariable Long pollId, @RequestParam int optionIndex, Authentication auth) {
        Poll poll = pollRepository.findById(pollId).orElseThrow();
        AppUser user = userRepository.findByUsername(auth.getName());


        pollResponseRepository.deleteByUserAndPoll(user, poll);
        pollResponseRepository.flush();


        if (optionIndex >= 0 && optionIndex < poll.getOptions().size()) {
            PollResponse newResponse = new PollResponse(user, poll, optionIndex);
            newResponse.setSelectedOptionText(poll.getOptions().get(optionIndex));
            pollResponseRepository.save(newResponse);
        }
        List<Integer> currentVotes = new ArrayList<>();


        for (int i = 0; i < poll.getOptions().size(); i++) {
            long count = pollResponseRepository.countByPollAndSelectedOptionIndex(poll, i);
            currentVotes.add(Integer.parseInt(String.valueOf(count))); // 這就是你要的「直接返回數值」

        }
        poll.setVotes(currentVotes);

        return "redirect:/polls/courses/" + poll.getCourse().getId() + "/poll/" + pollId;
    }


    @Transactional
    @PostMapping("/delete/{pollId}")
    public String deletePoll(@PathVariable Long pollId, Authentication auth, RedirectAttributes redirectAttributes) {
        Poll poll = pollRepository.findById(pollId).orElseThrow(() ->
                new IllegalArgumentException("Poll not found: " + pollId));

        Course course = poll.getCourse();
        String currentUsername = auth.getName();


        log.info("==== [Delete Attempt] Poll ID: {} ====", pollId);
        log.info("Current User: {}", currentUsername);

        if (course.getInstructor() == null) {
            log.warn("Access Denied: Course '{}' (ID: {}) has NO instructor assigned!",
                    course.getTitle(), course.getId());
        } else {
            log.info("Course Instructor: {}", course.getInstructor().getUsername());
        }
        // -----------------------

        boolean isOwner = course.getInstructor() != null &&
                course.getInstructor().getUsername().equals(currentUsername);

        if (isOwner) {
            Long courseId = course.getId();
            pollResponseRepository.deleteByPoll(poll);
            pollRepository.saveAndFlush(poll); // 確保刪除前狀態同步
            pollRepository.delete(poll);

            log.info("[Delete Success] Poll {} deleted by instructor {}", pollId, currentUsername);
            redirectAttributes.addFlashAttribute("message", "Poll deleted successfully.");
            return "redirect:/courses/" + courseId;
        } else {
            log.error("[Delete Failed] User {} is NOT the instructor of Course {}",
                    currentUsername, course.getId());


            redirectAttributes.addFlashAttribute("error", "Only the course instructor can delete polls.");
            return "redirect:/courses/" + course.getId();
        }
    }


    @Transactional
    @PostMapping("/{pollId}/edit-question")
    public String updateQuestion(@PathVariable Long pollId, @RequestParam String newQuestion, Authentication auth) {
        Poll poll = pollRepository.findById(pollId).orElseThrow();
        if (poll.getCourse().getInstructor().getUsername().equals(auth.getName())) {
            poll.setQuestion(newQuestion);
            pollRepository.save(poll);
        }
        return "redirect:/polls/courses/" + poll.getCourse().getId() + "/poll/" + pollId;
    }

    @Transactional
    @PostMapping("/{pollId}/edit-option")
    @ResponseBody
    public String editPollOption(@PathVariable Long pollId, @RequestParam int index,
                                 @RequestParam String newOptionText, Authentication auth) {
        Poll poll = pollRepository.findById(pollId).orElseThrow();
        if (poll.getCourse().getInstructor().getUsername().equals(auth.getName())) {
            if (index >= 0 && index < poll.getOptions().size()) {
                poll.getOptions().set(index, newOptionText);
                pollRepository.save(poll);
                return "success";
            }
        }
        return "error";
    }


    @GetMapping("/history")
    public String showPollHistory(Principal principal, Model model) {
        AppUser user = userRepository.findByUsername(principal.getName());

        List<PollResponse> participationHistory = pollResponseRepository.findByUserOrderByVoteTimeDesc(user);

        List<Poll> createdPolls = pollRepository.findByCourseInstructor(user);

        model.addAttribute("participationHistory", participationHistory);
        model.addAttribute("createdPolls", createdPolls);

        return "poll-history";
    }
}