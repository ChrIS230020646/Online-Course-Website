package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Course;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.model.Poll;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CourseRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.PollRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;

@Controller
public class CourseController {

    @Autowired
    private CourseRepository courseRepository;
    @Autowired
    private LectureRepository lectureRepository;
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/courses")
    public String listCourses(Model model) {
        model.addAttribute("courses", courseRepository.findAll());
        return "courses";
    }

    @GetMapping("/courses/add")
    public String showAddCourseForm(Model model,Authentication auth) {
         Course c= new Course();
        String currentUsername = auth.getName();
        AppUser user =userRepository.findByUsername(currentUsername);
         c.setInstructor(user);
        model.addAttribute("course", c);
        return "add-course";
    }

    @PostMapping("/courses/add")
    public String saveCourse(Course course,Authentication auth)  {
        String currentUsername = auth.getName();
        AppUser user =userRepository.findByUsername(currentUsername);
        course.setInstructor(user);
        courseRepository.save(course);
        return "redirect:/courses";
    }

    @GetMapping("/courses/{courseId}/add-lecture")
    public String showAddLectureForm(@PathVariable("courseId") Long courseId, Model model) {
        model.addAttribute("courseId", courseId);
        model.addAttribute("lecture", new Lecture());
        return "add-lecture";
    }

    @PostMapping("/courses/{courseId}/add-lecture")
    public String saveLecture(@PathVariable("courseId") Long courseId, Lecture lecture) {

        lecture.setId(null);

        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid course Id:" + courseId));

        lecture.setCourse(course);
        lectureRepository.save(lecture);

        return "redirect:/courses/" + courseId;
    }

    @PostMapping("/courses/{courseId}/enroll")
    public String enrollCourse(@PathVariable Long courseId, Authentication authentication, RedirectAttributes redirectAttributes) {
        String username = authentication.getName();
        AppUser user = userRepository.findByUsername(username);
        Course course = courseRepository.findById(courseId).orElseThrow();

        if (!user.getEnrolledCourses().contains(course)) {
            user.getEnrolledCourses().add(course);
            userRepository.save(user);
            redirectAttributes.addFlashAttribute("message", "Enrollment Successful: " + course.getTitle());
        } else {
            redirectAttributes.addFlashAttribute("message", "You are already enrolled.");
        }

        return "redirect:/courses/" + courseId;
    }

    @GetMapping("/my-courses")
    public String myCourses(Model model, Authentication authentication) {
        String username = authentication.getName();
        AppUser user = userRepository.findByUsername(username);
        model.addAttribute("enrolledCourses", user.getEnrolledCourses());
        return "my-courses";
    }

    @GetMapping("/courses/{id}")
    public String courseDetail(@PathVariable Long id, Model model, Authentication authentication) {
        Course course = courseRepository.findById(id).orElseThrow(()-> new IllegalArgumentException("Invalid course Id:" + id));
        model.addAttribute("course", course);


        boolean isEnrolled = false;
        if (authentication != null) {
            String username = authentication.getName();
            AppUser user = userRepository.findByUsername(username);
            if (user != null) {
                isEnrolled = user.getEnrolledCourses().contains(course);
            }
        }
        model.addAttribute("isEnrolled", isEnrolled);

        return "course-detail";
    }

    @GetMapping("/lectures/{lectureId}")
    public String viewLecture(@PathVariable Long lectureId, Model model) {
        // lectureRepository
        // Lecture lecture = lectureRepository.findById(lectureId).orElseThrow();
        // model.addAttribute("lecture", lecture);

        // it need a lecture-detail.jsp to display
        return "lecture-detail";
    }
    @Autowired
    private PollRepository pollRepository;

    @GetMapping("/courses/{courseId}/add-poll")
    public String showAddPollForm(@PathVariable Long courseId, Model model) {
        model.addAttribute("courseId", courseId);
        return "add-poll"; // Directs to your add-poll.jsp
    }

    @PostMapping("/courses/{courseId}/add-poll")
    public String createPoll(@PathVariable Long courseId,
                             @RequestParam String question,
                             @RequestParam List<String> options) {

        Course course = courseRepository.findById(courseId).orElseThrow();

        Poll poll = new Poll();
        poll.setQuestion(question);
        poll.setOptions(options); // This takes the 5 strings from the JSP
        poll.setCourse(course);

        // Initialize 5 zeros for the initial vote counts
        poll.setVotes(new ArrayList<>(List.of(0, 0, 0, 0, 0)));

        pollRepository.save(poll);
        return "redirect:/courses/" + courseId;
    }
    //the edit form
    @GetMapping("/courses/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model) {
        Course course = courseRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid course Id:" + id));
        model.addAttribute("course", course);
        return "edit-course";
    }

    //Process the update
    @PostMapping("/courses/{id}/edit")
    public String updateCourse(@PathVariable Long id,
                               @RequestParam String title,
                               @RequestParam String category,
                               @RequestParam String description,
                               RedirectAttributes redirectAttributes) {

        Course course = courseRepository.findById(id).orElseThrow();

        // Update the values
        course.setTitle(title);
        course.setCategory(category);
        course.setDescription(description);

        courseRepository.save(course);

        redirectAttributes.addFlashAttribute("message", "Course updated successfully!");

        // Redirect back to the course detail page to see changes
        return "redirect:/courses/" + id;
    }
    @PostMapping("/courses/{id}/delete")
    public String deleteCourse(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            courseRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("message", "Course has been successfully deleted.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to delete course. Ensure all related data is cleared.");
        }

        return "redirect:/courses";
    }
}



