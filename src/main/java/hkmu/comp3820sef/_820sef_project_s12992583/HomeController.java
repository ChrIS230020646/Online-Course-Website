package hkmu.comp3820sef._820sef_project_s12992583;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String index() {
        return "index"; // index to /WEB-INF/jsp/index.jsp
    }

    @GetMapping("/lecture/{id}") // 404 error
    public String lecturePage() {
        return "lecture"; // go /WEB-INF/jsp/lecture.jsp
    }

    @GetMapping("/poll/{id}")
    public String pollPage() {
        return "poll"; // go /WEB-INF/jsp/poll.jsp
    }
}
