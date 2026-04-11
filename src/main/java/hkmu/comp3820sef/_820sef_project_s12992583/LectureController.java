package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Course;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CommentRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import hkmu.comp3820sef._820sef_project_s12992583.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class LectureController {

    @Autowired
    private LectureRepository lectureRepository;

    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private CommentService commentService;
    @GetMapping("/course-material-page/{lectureId}")
    public String showCourseMaterialPage(@PathVariable("lectureId") Long lectureId, Model model) {

        Lecture lecture = lectureRepository.findById(lectureId).orElse(null);
        Course course =lecture.getCourse();
        model.addAttribute("course", course);
        model.addAttribute("lecture", lecture);
        model.addAttribute("lectureId", lectureId);
        if (lecture == null) {
            return "redirect:/";
        }
        List<Comment> comments = commentService.getCommentsByTarget("lecture", lectureId);

        model.addAttribute("commentList", comments);
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

        return "course-material-page";
    }
    @PostMapping("/course-material-page/delete/{lectureId}")
    public String deleteLecture(@PathVariable Long lectureId) {
        //Find the lecture to identify the course ID for redirection
        Lecture lecture = lectureRepository.findById(lectureId).orElseThrow(() -> new IllegalArgumentException("Invalid lecture Id:" + lectureId));

        Long courseId = lecture.getCourse().getId();
        //Delete the lecture
        lectureRepository.delete(lecture);
        //Redirect back to the specific course detail page
        return "redirect:/courses/" + courseId;
    }
    @PostMapping("/course-material-page/{lectureId}/update")
    public String updateLecture(@PathVariable Long lectureId,
                                @RequestParam("title") String title,
                                @RequestParam("content") String content) {

        //Find the existing lecture
        Lecture lecture = lectureRepository.findById(lectureId)
                .orElseThrow(() -> new IllegalArgumentException("Lecture not found: " + lectureId));
        //Update the fields with the data from the form
        lecture.setTitle(title);
        lecture.setContent(content);
        //Save the changes back to the database
        lectureRepository.save(lecture);
        //Redirect back to the same page to show the updated content
        return "redirect:/course-material-page/" + lectureId;
    }
}
