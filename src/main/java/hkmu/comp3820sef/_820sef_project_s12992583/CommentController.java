package hkmu.comp3820sef._820sef_project_s12992583;


import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CommentRepository;

import hkmu.comp3820sef._820sef_project_s12992583.repository.CourseRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;


@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private LectureRepository lectureRepository;


@GetMapping("/history")
public String showHistory(Principal principal, Model model) {
    if (principal == null) return "redirect:/login";


    AppUser currentUser = userRepository.findByUsername(principal.getName());


    Sort sort = Sort.by("commentTime").descending();
    List<Comment> historyList = commentRepository.findByUser(currentUser, sort);

    // 3. 核心修正：手動觸發 Hibernate 抓取關聯數據，確保 JSP 能讀到 parentComment.user
    for (Comment cmt : historyList) {
        if (cmt.getLecture() != null) {
            cmt.getLecture().getTitle();
        }
        if (cmt.getParentComment() != null) {
            cmt.getParentComment().getUser().getUsername();
        }
    }

    model.addAttribute("historyList", historyList);
    return "comment-history";
}


    @PostMapping("/delete/{id}")
    public String deleteComment(@PathVariable Long id,
                                HttpServletRequest request) {


        commentRepository.deleteById(id);

        String referer = request.getHeader("Referer");

        return "redirect:" + (referer != null ? referer : "/");
    }
    // 處理新增評論
    @PostMapping("/lectures/{lectureId}/add-comment")
    public String addComment(@PathVariable Long lectureId,
                             @RequestParam String description,
                             @RequestParam(required = false) Long parentId,
                             Principal principal) {

        if (principal == null) return "redirect:/login";

        String username = principal.getName();
        AppUser currentUser = userRepository.findByUsername(username);

        Lecture lecture = lectureRepository.findById(lectureId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid lecture Id:" + lectureId));

        Comment comment = new Comment();
        comment.setDescription(description);
        comment.setUser(currentUser);
        comment.setLecture(lecture);


        if (parentId != null) {
            commentRepository.findById(parentId).ifPresent(comment::setParentComment);
        }

        commentRepository.save(comment);

        return "redirect:/course-material-page/" + lectureId;
    }


    @PostMapping("/lectures/delete/{id}")
    public String deleteComment(@PathVariable Long id,
                                @RequestParam Long lectureId,
                                Principal principal)  {

        Comment comment = commentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid comment Id:" + id));

        String currentUsername = principal.getName();
        boolean isTeacher = userRepository.findByUsername(currentUsername).getRole().equals("teacher");//role
        boolean isOwner = comment.getUser().getUsername().equals(currentUsername);

        if (isTeacher || isOwner) {
            commentRepository.delete(comment);
        }

        return "redirect:/course-material-page/" + lectureId;
    }
    @GetMapping("/comments/{Id}")
    public String getCommentById(@PathVariable Long Id, Model model) {
        Comment comment = commentRepository.findById(Id)
                .orElseThrow(() -> new IllegalArgumentException("Comment ID " + Id + " not found"));

        model.addAttribute("cmt", comment);

        model.addAttribute("lectureId", comment.getLecture().getId());

        return "components/Comment-ComponentById";
    }


}