package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CourseRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.PollRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.security.Principal;

@Controller
public class HomeController {

    @Autowired
    private CourseRepository courseRepo;
    @Autowired
    private LectureRepository lectureRepo;
    @Autowired
    private PollRepository pollRepo;
    @Autowired
    private UserRepository userRepo;

    @GetMapping("/")
    public String index(Principal principal, ModelMap model) {
        model.addAttribute("courses", courseRepo.findAll());
        model.addAttribute("recentLectures", lectureRepo.findAll());
        model.addAttribute("activePolls", pollRepo.findAll());

        if (principal != null) {
            AppUser currentUser = userRepo.findByUsername(principal.getName());
            model.addAttribute("user", currentUser);
        }
        return "index";
    }

    @GetMapping("/course/{id}")
    public String coursePage(@PathVariable("id") Long id, ModelMap model) {
        model.addAttribute("course", courseRepo.findById(id).orElse(null));
        return "course-detail";
    }

    @GetMapping("/lecture/{id}")
    public String lecturePage(@PathVariable("id") Long id, ModelMap model) {
        model.addAttribute("lecture", lectureRepo.findById(id).orElse(null));
        return "course-material-page";
    }

    @GetMapping("/poll/{id}")
    public String pollPage(@PathVariable("id") Long id, ModelMap model) {
        model.addAttribute("poll", pollRepo.findById(id).orElse(null));

        return "poll-detail";
    }
}

