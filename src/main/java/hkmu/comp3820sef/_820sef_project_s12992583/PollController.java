package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.dto.PollDTO;
import hkmu.comp3820sef._820sef_project_s12992583.model.*;
import hkmu.comp3820sef._820sef_project_s12992583.repository.PollRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.PollResponseRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.UserRepository;
import hkmu.comp3820sef._820sef_project_s12992583.service.CommentService;
import hkmu.comp3820sef._820sef_project_s12992583.service.PollService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/polls")
public class PollController {

    @Autowired
    private PollRepository pollRepository;
    @Autowired
    private PollResponseRepository pollResponseRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PollService pollService;
    @Autowired
    private CommentService commentService;
    private static final Logger log = LoggerFactory.getLogger(PollController.class);
    @GetMapping("/courses/{courseId}/poll/{pollId}")
    public String viewPoll(@PathVariable Long courseId, @PathVariable Long pollId,
                           Authentication auth, Model model) {

        PollDTO pollDto = pollService.getPollViewData(pollId, auth.getName());
        model.addAttribute("poll", pollDto);
        model.addAttribute("courseId", courseId);



        List<Comment> comments = commentService.getCommentsByTarget("poll", pollId);

        model.addAttribute("commentList", comments);

        return pollDto.isInstructor() ? "poll-detail" : "student-vote";
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
            currentVotes.add(Integer.parseInt(String.valueOf(count)));

        }
        poll.setVotes(currentVotes);

        return "redirect:/polls/courses/" + poll.getCourse().getId() + "/poll/" + pollId;
    }


    @Transactional
    @PostMapping("/{pollId}/delete")
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
            pollRepository.saveAndFlush(poll);
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


        List<PollDTO> createdPollDTOs = createdPolls.stream().map(poll -> {
            PollDTO dto = new PollDTO();
            dto.setId(poll.getId());
            dto.setQuestion(poll.getQuestion());
            dto.setVotes(poll.getVotes());

            int total = 0;
            if (poll.getVotes() != null) {
                for (int v : poll.getVotes()) {
                    total += v;
                }
            }
            dto.setTotalVotes(total);
            // -----------------------

            if (poll.getCourse() != null) {
                dto.setCourseId(poll.getCourse().getId());
            }
            dto.setInstructor(true);
            return dto;
        }).collect(Collectors.toList());

        model.addAttribute("participationHistory", participationHistory);
        model.addAttribute("createdPolls", createdPollDTOs);

        return "poll-history";
    }
    @GetMapping("/api/polls/{pollId}/results")
    @ResponseBody
    public PollDTO getPollResults(@PathVariable Long pollId) {
        return pollService.getJustResults(pollId);
    }
}