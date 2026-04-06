package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.repository.CourseRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.PollRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class HomeController {

    @Autowired
    private CourseRepository courseRepo;

    @Autowired
    private LectureRepository lectureRepo;

    @Autowired
    private PollRepository pollRepo;

    @GetMapping("/")
    public String index(ModelMap model) {
        model.addAttribute("courses", courseRepo.findAll());
        model.addAttribute("lectures", lectureRepo.findAll());
        model.addAttribute("polls", pollRepo.findAll());
        return "index";
    }

    @GetMapping("/lecture/{id}")
    public String lecturePage(@PathVariable("id") Long id, ModelMap model) {
        model.addAttribute("lecture", lectureRepo.findById(id).orElse(null));
        return "lecture";
    }

    @GetMapping("/poll/{id}")
    public String pollPage(@PathVariable("id") Long id, ModelMap model) {
        model.addAttribute("poll", pollRepo.findById(id).orElse(null));
        return "poll";
    }
}

