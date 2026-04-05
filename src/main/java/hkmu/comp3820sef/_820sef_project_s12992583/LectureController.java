package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CommentRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/lectures")
public class LectureController {

    @Autowired
    private LectureRepository lectureRepository;

    @Autowired
    private CommentRepository commentRepository;


    @RequestMapping("/lectures/{lectureId}")
    @GetMapping(path = "/lectures/{lectureId}")
    public String viewLectureDetail(@PathVariable Long lectureId, Model model) {

        // 1. 抓取 Lecture 基本資料
        Lecture lecture = lectureRepository.findById(lectureId)
                .orElseThrow(() -> new IllegalArgumentException("Lecture not found: " + lectureId));

        // 2. 抓取主留言
        List<Comment> comments = commentRepository.findByLectureIdAndParentCommentIsNullOrderByCommentTimeDesc(lectureId);

        // 3. 傳入 Model
        model.addAttribute("lecture", lecture);
        model.addAttribute("commentList", comments);
        model.addAttribute("lectureId", lectureId);

        // 返回視圖名稱，Spring 會自動尋找 /WEB-INF/jsp/lecture-detail.jsp
        return "lecture-detail";
    }
}