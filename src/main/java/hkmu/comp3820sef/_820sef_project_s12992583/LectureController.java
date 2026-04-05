package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CommentRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
public class LectureController {

    @Autowired
    private LectureRepository lectureRepository;

    @Autowired
    private CommentRepository commentRepository;

    @GetMapping("/course-material-page/{lectureId}")
    public String showCourseMaterialPage(@PathVariable("lectureId") Long lectureId, Model model) {

        Lecture lecture = lectureRepository.findById(lectureId).orElse(null);

        if (lecture == null) {
            return "redirect:/";
        }

        model.addAttribute("lecture", lecture);
        model.addAttribute("course", lecture.getCourse());
        model.addAttribute("comments", new ArrayList<>());

        return "course-material-page";
    }

    @PostMapping("/course-material-page/{lectureId}/comment")
    public String addCommentToCourseMaterialPage(@PathVariable Long lectureId, @RequestParam("content") String content) {
        return "redirect:/course-material-page/" + lectureId;
    }

    @GetMapping("/lecture-view/{lectureId}")
    public String viewLectureDetail(@PathVariable Long lectureId, Model model) {

        Lecture lecture = lectureRepository.findById(lectureId)
                .orElseThrow(() -> new IllegalArgumentException("Lecture not found: " + lectureId));

        List<Comment> comments = commentRepository.findByLectureIdAndParentCommentIsNullOrderByCommentTimeDesc(lectureId);

        model.addAttribute("lecture", lecture);
        model.addAttribute("commentList", comments);
        model.addAttribute("lectureId", lectureId);

        return "lecture-detail";
    }
}
