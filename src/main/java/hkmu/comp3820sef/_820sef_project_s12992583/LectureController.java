package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Course;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CommentRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CourseRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.UserRepository;
import hkmu.comp3820sef._820sef_project_s12992583.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

@Controller
public class LectureController {

    @Autowired private LectureRepository lectureRepository;
    @Autowired private CourseRepository courseRepository;
    @Autowired private UserRepository userRepository;

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
    @PostMapping("/courses/{courseId}/lecture/{lectureId}/delete")
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












    @PostMapping("/courses/{courseId}/add-lecture")
    @PreAuthorize("hasRole('TEACHER')")
    public String addLecture(@PathVariable Long courseId,
                             @RequestParam("title") String title,
                             @RequestParam("content") String content,
                             @RequestParam("file") MultipartFile file) throws IOException {

        Course course = courseRepository.findById(courseId).orElseThrow();
        Lecture lecture = new Lecture();
        lecture.setTitle(title);
        lecture.setContent(content);
        lecture.setCourse(course);

        if (!file.isEmpty()) {
            String uploadDir = "uploads/lectures/";
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);

            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            lecture.setFileName(file.getOriginalFilename());
            lecture.setFilePath("uploads/lectures/" + fileName);
        }

        lectureRepository.save(lecture);
        return "redirect:/courses/" + courseId;
    }

    @PostMapping("/courses/{courseId}/kick/{studentId}")
    @PreAuthorize("hasRole('TEACHER')")
    public String kickStudent(@PathVariable Long courseId, @PathVariable Long studentId) {
        Course course = courseRepository.findById(courseId).orElseThrow();
        AppUser student = userRepository.findById(studentId).orElseThrow();

        course.getStudents().remove(student);
        student.getEnrolledCourses().remove(course);

        courseRepository.save(course);
        userRepository.save(student);
        return "redirect:/courses/" + courseId;
    }

    @PostMapping("/course-material-page/{lectureId}/upload")
    @PreAuthorize("hasRole('TEACHER')")
    public String uploadToLecture(@PathVariable("lectureId") Long lectureId, @RequestParam("file") MultipartFile file) throws IOException {
        Lecture lecture = lectureRepository.findById(lectureId).orElseThrow();
        if (!file.isEmpty()) {
            String uploadDir = "uploads/lectures/";
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);

            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            lecture.setFileName(file.getOriginalFilename());
            lecture.setFilePath(filePath.toString());
            lectureRepository.save(lecture);
        }
        return "redirect:/course-material-page/" + lectureId;
    }

    @PostMapping("/course-material-page/{lectureId}/delete-file")
    @PreAuthorize("hasRole('TEACHER')")
    public String deleteLectureFile(@PathVariable("lectureId") Long lectureId) {
        Lecture lecture = lectureRepository.findById(lectureId).orElseThrow();

        if (lecture.getFilePath() != null) {
            try {
                Files.deleteIfExists(Paths.get(lecture.getFilePath()));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        lecture.setFileName(null);
        lecture.setFilePath(null);
        lectureRepository.save(lecture);
        return "redirect:/course-material-page/" + lectureId;
    }

    @GetMapping("/download/lecture/{lectureId}")
    public ResponseEntity<Resource> downloadFile(@PathVariable("lectureId") Long lectureId) throws MalformedURLException {
        Lecture lecture = lectureRepository.findById(lectureId).orElseThrow();
        if (lecture.getFilePath() == null) {
            return ResponseEntity.notFound().build();
        }
        Path path = Paths.get(lecture.getFilePath());
        Resource resource = new UrlResource(path.toUri());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + lecture.getFileName() + "\"")
                .body(resource);
    }
}
