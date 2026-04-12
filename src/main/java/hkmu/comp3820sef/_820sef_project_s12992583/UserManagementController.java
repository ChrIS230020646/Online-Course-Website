package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Course;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CommentRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CourseRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.PollResponseRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/users")
public class UserManagementController {
    @Autowired private UserRepository userRepository;
    @Autowired private PasswordEncoder passwordEncoder;
    @Autowired private CourseRepository courseRepository;
    @Autowired private CommentRepository commentRepository;
    @Autowired private PollResponseRepository pollResponseRepository;

    @GetMapping
    @PreAuthorize("hasRole('TEACHER')")
    public String listUsers(Model model) {
        model.addAttribute("users", userRepository.findAll());
        return "user-list";
    }

    //@PostMapping("/delete/{id}")
    //@PreAuthorize("hasRole('TEACHER')")
    //public String deleteUser(@PathVariable Long id) {
      //  AppUser user = userRepository.findById(id).orElseThrow();
        //if ("TEACHER".equals(user.getRole())) {
          //  List<Course> courses = courseRepository.findByInstructor(user);
            //for (Course c : courses) {
              //  c.setInstructor(null);
                //courseRepository.save(c);
            //}
//        }
  //      user.getEnrolledCourses().clear();
    //    userRepository.save(user);
      //  userRepository.deleteById(id);
        //return "redirect:/users";
    //}

    // This handles: GET /users/edit/{id}
    @GetMapping("/edit/{id}")
    @PreAuthorize("hasRole('TEACHER')")
    public String editUserForm(@PathVariable Long id, Model model) {
        AppUser user = userRepository.findById(id).orElseThrow();
        model.addAttribute("user", user);
        return "edit-user"; // Make sure your file is named edit-user.jsp
    }

    // This handles: POST /users/update/{id}
    @PostMapping("/update/{id}")
    @PreAuthorize("hasRole('TEACHER')")
    public String adminUpdateUser(@PathVariable Long id,
                                  @RequestParam(required = false) String fullName,
                                  @RequestParam(required = false) String email,
                                  @RequestParam(required = false) String role,
                                  @RequestParam(required = false) String password,
                                  @RequestParam(required = false) String phoneNumber) {

        AppUser user = userRepository.findById(id).orElseThrow();
        if(!fullName.isEmpty())
        user.setFullName(fullName);
        if(!email.isEmpty())
            user.setEmail(email);
        if(!role.isEmpty())
        user.setRole(role);
        if(!phoneNumber.isEmpty()&&phoneNumber.length()==8)
        user.setPhoneNumber(phoneNumber);
        if(!password.isEmpty())
        user.setPassword(password); // Plain text as requested

        userRepository.save(user);
        return "redirect:/users"; // Go back to the user list
    }
    @Transactional // CRITICAL: Ensures all deletes happen in order
    @PostMapping("/delete/{id}")
    @PreAuthorize("hasRole('TEACHER') or isAuthenticated()")
    public String deleteUser(@PathVariable Long id, Principal principal, HttpServletRequest request) {
        AppUser userToDelete = userRepository.findById(id).orElseThrow();
        String currentUsername = principal.getName();

        boolean isTeacher = request.isUserInRole("ROLE_TEACHER");
        boolean isSelfDeletion = userToDelete.getUsername().equals(currentUsername);

        if (!isTeacher && !isSelfDeletion) {
            return "redirect:/login?error=unauthorized";
        }

        // 1. Cleanup Courses (If teacher)
        if ("TEACHER".equals(userToDelete.getRole())) {
            List<Course> courses = courseRepository.findByInstructor(userToDelete);
            for (Course c : courses) {
                c.setInstructor(null);
                courseRepository.save(c);
            }
        }

        // 2. Clear Enrollments (Join Table)
        userToDelete.getEnrolledCourses().clear();
        userRepository.saveAndFlush(userToDelete);

        // 3. Delete Comments FIRST (The fix for your current error)
        // Ensure this method exists in your CommentRepository
        commentRepository.deleteByUser(userToDelete);
        commentRepository.flush(); // Force the comments to be deleted NOW
        pollResponseRepository.deleteByUser(userToDelete);
        pollResponseRepository.flush();
        commentRepository.flush();
        // 4. Finally delete the user
        userRepository.delete(userToDelete);

        if (isSelfDeletion) {
            try {
                request.logout();
            } catch (ServletException e) {
                e.printStackTrace();
            }
            return "redirect:/login?deleted=self";
        }

        return "redirect:/users";
    }
}
