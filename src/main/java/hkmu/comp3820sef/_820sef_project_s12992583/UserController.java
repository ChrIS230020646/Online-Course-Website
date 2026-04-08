package hkmu.comp3820sef._820sef_project_s12992583;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.security.Principal;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private final String UPLOAD_DIR = "uploads/";

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String showRegistrationForm() {
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@RequestParam String username,
                               @RequestParam String fullName,
                               @RequestParam String email,
                               @RequestParam String phoneNumber,
                               @RequestParam String role,
                               @RequestParam String password,
                               @RequestParam String confirmPassword) {

        if (!username.matches(".*[a-zA-Z].*")) {
            return redirectWithError("Username must contain at least one letter.");
        }

        if (userRepository.findByUsername(username) != null) return redirectWithError("Username exists.");
        if (userRepository.findByEmail(email) != null) return redirectWithError("Email exists.");
        if (userRepository.findByPhoneNumber(phoneNumber) != null) return redirectWithError("Phone exists.");

        if (!password.equals(confirmPassword)) return redirectWithError("Passwords do not match.");

        String strongPasswordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        if (!password.matches(strongPasswordPattern)) {
            return redirectWithError("Password too weak.");
        }
        if(!(role.equals("TEACHER")||role.equals("STUDENT")))
            return "redirect:/register?error=role not exists";
        AppUser newUser = new AppUser();
        newUser.setUsername(username);
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhoneNumber(phoneNumber);
        newUser.setPassword(passwordEncoder.encode(password));
        newUser.setRole(role);

        userRepository.save(newUser);
        return "redirect:/login?registered=true";
    }

    @GetMapping("/profile")
    public String showProfile(Principal principal, Model model) {
        if (principal == null) return "redirect:/login";
        AppUser user = userRepository.findByUsername(principal.getName());
        model.addAttribute("user", user);
        return "profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(Principal principal,
                                @RequestParam String fullName,
                                @RequestParam String email,
                                @RequestParam String phoneNumber,
                                @RequestParam(required = false) String password,
                                @RequestParam(required = false) String confirmPassword,
                                @RequestParam("avatar") MultipartFile avatarFile) throws IOException {

        AppUser user = userRepository.findByUsername(principal.getName());

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);

        if (password != null && !password.isEmpty()) {
            if (!password.equals(confirmPassword)) {
                return redirectWithProfileError("Passwords do not match.");
            }
            String strongPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
            if (!password.matches(strongPattern)) {
                return redirectWithProfileError("Password must be 8+ chars with uppercase, lowercase, number, and special character.");
            }
            user.setPassword(passwordEncoder.encode(password));
        }

        if (!avatarFile.isEmpty()) {
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);

            String fileName = user.getUsername() + "_" + System.currentTimeMillis() + ".jpg";
            Path filePath = uploadPath.resolve(fileName);
            Files.copy(avatarFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            user.setProfilePicture("/uploads/" + fileName);
        }

        userRepository.save(user);
        return "redirect:/profile?success=true";
    }

    private String redirectWithProfileError(String msg) {
        return "redirect:/profile?error=" + URLEncoder.encode(msg, StandardCharsets.UTF_8);
    }

    private String redirectWithError(String errorMessage) {
        String encodedMsg = URLEncoder.encode(errorMessage, StandardCharsets.UTF_8);
        return "redirect:/register?error=" + encodedMsg;
    }
}



