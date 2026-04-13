package hkmu.comp3820sef._820sef_project_s12992583;


import hkmu.comp3820sef._820sef_project_s12992583.dto.PollDTO;
import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.model.Poll;
import hkmu.comp3820sef._820sef_project_s12992583.repository.*;

import hkmu.comp3820sef._820sef_project_s12992583.service.CommentService;
import hkmu.comp3820sef._820sef_project_s12992583.service.PollService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired private CommentRepository commentRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private CommentService commentService;
    @Autowired private PollRepository  pollRepository;
    @Autowired
    private PollService pollService;
    @GetMapping("/history")
    public String showHistory(Principal principal, Model model) {
        if (principal == null) return "redirect:/login";

        AppUser currentUser = userRepository.findByUsername(principal.getName());
        Sort sort = Sort.by("commentTime").descending();

        List<Comment> historyList = commentRepository.findByUser(currentUser, sort);

        Map<Long, Poll> pollMap = new HashMap<>();

        for (Comment cmt : historyList) {
            if ("poll".equalsIgnoreCase(cmt.getTargetType()) && cmt.getTargetId() != null) {
                pollRepository.findById(cmt.getTargetId()).ifPresent(poll -> {
                    pollMap.put(poll.getId(), poll);
                });
            }

            if (cmt.getLecture() != null) {
                cmt.getLecture().getTitle();
                if (cmt.getLecture().getCourse() != null) {
                    cmt.getLecture().getCourse().getTitle();
                }
            }


            if (cmt.getParentComment() != null) {
                cmt.getParentComment().getUser().getUsername();
            }
        }

        model.addAttribute("historyList", historyList);
        model.addAttribute("pollMap", pollMap);
        return "comment-history";
    }
    @GetMapping("/comments/{Id}")
    public String getCommentById(@PathVariable Long Id, Model model) {
        Comment comment = commentRepository.findById(Id)
                .orElseThrow(() -> new IllegalArgumentException("Comment ID " + Id + " not found"));

        model.addAttribute("cmt", comment);

        Long tid = (comment.getLecture() != null)
                ? comment.getLecture().getId()
                : comment.getTargetId();

        model.addAttribute("lectureId", tid);

        return "components/Comment-ComponentById";
    }
    @PostMapping("/{type}/{id}/add-ajax")
    @ResponseBody
    public ResponseEntity<?> addCommentAjax(@PathVariable String type,
                                            @PathVariable Long id,
                                            @RequestParam("description") String description,
                                            @RequestParam(required = false) Long parentId,
                                            Principal principal) {
        if (principal == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login required");

        try {
            Comment savedComment = commentService.saveComment(type, id, description, parentId, principal.getName());
            Map<String, Object> response = new HashMap<>();
            response.put("status", "success");
            response.put("commentId", savedComment.getId());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }

    @PostMapping("/lecture/{lectureId}/add")
    public String addComment(@PathVariable Long lectureId,
                             @RequestParam String description,
                             @RequestParam(required = false) Long parentId,
                             Principal principal) {
        commentService.saveComment("lecture", lectureId, description, parentId, principal.getName());
        return "redirect:/course-material-page/" + lectureId;
    }


    @PostMapping("/delete/{id}")
    public String deleteComment(@PathVariable Long id,
                                @RequestParam(required = false) Long lectureId,
                                Principal principal,
                                HttpServletRequest request) {
        Comment comment = commentRepository.findById(id).orElse(null);
        if (comment != null) {
            String currentUsername = principal.getName();
            AppUser user = userRepository.findByUsername(currentUsername);
            boolean isTeacher = user.getRole().equalsIgnoreCase("teacher");
            boolean isOwner = comment.getUser().getUsername().equals(currentUsername);

            if (isTeacher || isOwner) {
                commentRepository.delete(comment);

                    List<Comment> replies = comment.getReplies();
                    for (Comment reply : replies) {
                        commentRepository.delete(reply);

                }

            }
        }

        if (lectureId != null) return "redirect:/course-material-page/" + lectureId;
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/");
    }
    @PostMapping("/edit")
    public String editComment(@RequestParam("commentId") Long commentId,
                              @RequestParam("description") String content,
                              @RequestParam("type") String type,
                              @RequestParam("targetId") Long targetId) {

        commentService.updateComment(commentId, content);


        String redirectUrl = commentService.getRedirectUrl(type, targetId);
        return "redirect:" + redirectUrl;
    }
}