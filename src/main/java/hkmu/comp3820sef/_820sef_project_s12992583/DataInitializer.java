package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.*;
import hkmu.comp3820sef._820sef_project_s12992583.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired private UserRepository userRepository;
    @Autowired private CourseRepository courseRepository;
    @Autowired private LectureRepository lectureRepository;
    @Autowired private PollRepository pollRepository;
    @Autowired private PollResponseRepository pollResponseRepository;
    @Autowired private PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(String... args) throws Exception {

        AppUser teacher = userRepository.findByUsername("t123");
        if (userRepository.findByUsername("t123") == null) {
            teacher = new AppUser();
            teacher.setUsername("t123");
            teacher.setPassword(passwordEncoder.encode("Tpw123@@"));
            teacher.setRole("TEACHER");
            teacher.setFullName("Dr.Chen");
            teacher.setEmail("t123@hkmu.edu.hk");
            teacher.setPhoneNumber("62345678");
            userRepository.save(teacher);
        }

        AppUser student = userRepository.findByUsername("s123");
        if (userRepository.findByUsername("s123") == null) {
            student = new AppUser();
            student.setUsername("s123");
            student.setPassword(passwordEncoder.encode("Spw123@@"));
            student.setRole("STUDENT");
            student.setFullName("ChrisChung");
            student.setEmail("s123@hkmu.edu.hk");
            student.setPhoneNumber("27654321");
            userRepository.save(student);
        }

        if (courseRepository.findAll().isEmpty()) {
            Course course = new Course();
            course.setTitle("Web Application Development");
            course.setCategory("COMPUTER SCIENCE");
            course.setDescription("This course aims to enable students to develop web applications based on the three-tier architecture. Students will apply the techniques in a hands-on mini-project to build a web application.");
            course.setInstructor(teacher);

            student.getEnrolledCourses().add(course);
            course.getStudents().add(student);

            course = courseRepository.save(course);
            userRepository.save(student);

            Lecture lecture = new Lecture();
            lecture.setTitle("Week1");
            lecture.setContent("Course Guideline");
            lecture.setCourse(course);
            lectureRepository.save(lecture);

            Poll poll = new Poll();
            poll.setQuestion("How much do you know about Web Application Development?");
            poll.setCourse(course);

            poll.setOptions(new ArrayList<>(Arrays.asList(
                    "Very Well", "Well", "Basic", "Just Little", "I've never heard of it."
            )));

            poll.setVotes(new ArrayList<>(Arrays.asList(0, 0, 0, 0, 0)));
            poll = pollRepository.save(poll);
        }
    }
}

