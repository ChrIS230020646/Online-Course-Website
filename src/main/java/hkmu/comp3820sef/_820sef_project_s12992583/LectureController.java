package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.Course;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.ArrayList;

@Controller
@RequestMapping("/course-material-page")
public class LectureController {

    // Service
    // @Autowired
    // private CommentService commentService;
    //@Autowired
    //private CourseService courseService;
    @Autowired
    private LectureRepository lectureRepository;

    @GetMapping("/{lectureId}")
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

    @PostMapping("/{lectureId}/comment")
    public String addCommentToCourseMaterialPage(@PathVariable Long lectureId, @RequestParam("content") String content) {

        // User currentUser = ...

        // Comment newComment = new Comment();
        // newComment.setLectureId(lectureId);
        // newComment.setContent(content);
        // newComment.setUser(currentUser); //
        // newComment.setCreatedAt(new Date()); //
        // commentService.save(newComment);
        return "redirect:/course-material-page/" + lectureId;
    }
}