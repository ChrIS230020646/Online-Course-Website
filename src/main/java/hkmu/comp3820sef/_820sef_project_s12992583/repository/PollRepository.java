package hkmu.comp3820sef._820sef_project_s12992583.repository;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Poll;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PollRepository extends JpaRepository<Poll, Long> {

        List<Poll> findByCourseInstructor(AppUser instructor);

}