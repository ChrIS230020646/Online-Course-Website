package hkmu.comp3820sef._820sef_project_s12992583.repository;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import org.springframework.data.jpa.repository.JpaRepository;

// interface JpaRepository
public interface UserRepository extends JpaRepository<AppUser, Long> {
    AppUser findByUsername(String username);
    AppUser findByEmail(String email);
    AppUser findByPhoneNumber(String phoneNumber);
}
