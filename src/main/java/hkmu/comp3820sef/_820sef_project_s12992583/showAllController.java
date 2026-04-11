package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.dto.CommentHistoryDTO;
import hkmu.comp3820sef._820sef_project_s12992583.dto.PollGroupDTO;
import hkmu.comp3820sef._820sef_project_s12992583.dto.PollHistoryDTO;
import hkmu.comp3820sef._820sef_project_s12992583.model.Poll;
import hkmu.comp3820sef._820sef_project_s12992583.repository.PollRepository;
import hkmu.comp3820sef._820sef_project_s12992583.service.HistoryService;
import hkmu.comp3820sef._820sef_project_s12992583.service.PollService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/history")
public class showAllController {

    @Autowired
    private HistoryService historyService;
    @Autowired
    private PollService pollService;
    @Autowired
    private PollRepository pollRepository;
    @GetMapping("/comment/all")
    public String showAllCommentHistory(Model model) {
        log.info("Fetching system-wide comment and poll history...");

        List<CommentHistoryDTO> allComments = historyService.getAllCommentHistory();
        List<PollHistoryDTO> allPolls = historyService.getAllPollHistory();

        log.info("Comments retrieved: {} entries", allComments.size());
        log.info("Polls retrieved: {} entries", allPolls.size());

        if (!allComments.isEmpty()) {
            String firstTitle = allComments.get(0).getLectureTitle();
            log.info("First comment lecture title: [{}]", (firstTitle != null ? firstTitle : "NULL"));
            log.info("First comment content snippet: {}", allComments.get(0).getContent());
        } else {
            log.warn("Comment history list is empty!");
        }

        model.addAttribute("commentHistory", allComments);
        model.addAttribute("pollHistory", allPolls);
        model.addAttribute("viewTitle", "System-wide Activity Log");

        return "showAllCommentHistory";
    }




    @GetMapping("/poll/all")
    public String showAllPollHistory(Model model) {
        log.info("Fetching global poll history and raw entities...");

        List<Poll> rawPolls = pollRepository.findAll();

        model.addAttribute("rawPolls", rawPolls);
        model.addAttribute("pollHistory2", pollService.getAllPollHistory());
        model.addAttribute("viewTitle", "Global Activity Monitoring");

        return "showAllPolls";
    }
}