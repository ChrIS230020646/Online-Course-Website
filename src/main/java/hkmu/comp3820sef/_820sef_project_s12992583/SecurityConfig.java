// Defines the package location for this specific class
package hkmu.comp3820sef._820sef_project_s12992583;

// Imports necessary Spring Security components for configuration and encryption
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration // Tells Spring this class contains bean definitions (configuration settings)
@EnableWebSecurity // Enables Spring Security's web security support for the project
public class SecurityConfig {

    @Bean // Tells Spring to manage the returned object (SecurityFilterChain) as a Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // Starts the section for defining which URLs require which permissions
                .authorizeHttpRequests(auth -> auth
                        // Allows internal system forwards (JSP rendering) and error pages to work without being blocked
                        .dispatcherTypeMatchers(jakarta.servlet.DispatcherType.FORWARD, jakarta.servlet.DispatcherType.ERROR).permitAll()

                        // Makes these specific paths (Home, Login, Register, CSS/JS) public to everyone
                        .requestMatchers("/h2-console/**", "/register", "/login", "/", "/css/**", "/js/**", "/style.css","/poll-detail.css","/uploads/**").permitAll()

                        // Restricts Course creation, editing, and deletion to users with the 'TEACHER' role only
                        .requestMatchers("/courses/add", "/courses/edit/**", "/courses/delete/**").hasRole("TEACHER")
                                .requestMatchers("/courses/*/poll/*").authenticated()
                        // Requires any logged-in user (Student or Teacher) to access general course lists or their dashboard
//                        .requestMatchers("/courses/**", "/my-courses").authenticated()
// 修正 3：加入留言與課程詳情的存取權限
                                .requestMatchers("/courses/**").authenticated()
                                .requestMatchers("/lectures/**").authenticated()
                                .requestMatchers("/comment/**").authenticated()
                                .requestMatchers("/my-courses").authenticated()
                                .requestMatchers("/polls/*/delete").hasRole("TEACHER")
                        // Restricts all paths starting with /admin to users with the 'ADMIN' role
                        .requestMatchers("/admin/**").hasRole("ADMIN")

                        // Catch-all: Any other request not mentioned above MUST be authenticated (logged in)
                        .anyRequest().authenticated()
                )
                // Configures how users log into the application
                .formLogin(form -> form
                        .loginPage("/login") // Specifies the custom login page URL
                        .loginProcessingUrl("/login") // The URL where the login form submits the username/password
                        .defaultSuccessUrl("/courses", true) // Where to send the user after a successful login
                        .permitAll() // Allows everyone to see the login page
                )
                // Configures the logout behavior
                .logout(logout -> logout
                        .logoutUrl("/logout") // The URL that triggers the logout process
                        .logoutSuccessUrl("/") // Where to send the user after they log out
                        .permitAll() // Allows everyone to access the logout functionality
                )
                // Disables Cross-Site Request Forgery protection (often done for testing or H2 console usage)
                .csrf(csrf -> csrf.disable())

                // Configures security headers; specifically allows the H2 database console to run in a frame
                .headers(headers -> headers.frameOptions(frame -> frame.sameOrigin()));

        // Builds and returns the security configuration object
        return http.build();
    }

    @Bean // Registers the password encoder so Spring can securely hash and check passwords
    public PasswordEncoder passwordEncoder() {
        // Uses BCrypt, a strong hashing algorithm, to store passwords safely in the database
        return new BCryptPasswordEncoder();
    }
}

