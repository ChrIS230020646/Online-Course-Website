package hkmu.comp3820sef._820sef_project_s12992583.repository;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Poll;
import hkmu.comp3820sef._820sef_project_s12992583.model.PollResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface PollResponseRepository extends JpaRepository<PollResponse, Long> {
    List<PollResponse> findByPoll(Poll poll);
    Optional<PollResponse> findByUserAndPoll(AppUser user, Poll poll);
    void deleteByUserAndPoll(AppUser user, Poll poll);
    void deleteByPoll(Poll poll); // 用於刪除 Poll 時連帶刪除紀錄
    List<PollResponse> findByUserOrderByVoteTimeDesc(AppUser user); // 用於歷史紀錄
    long countByPollAndSelectedOptionIndex(Poll poll, int selectedOptionIndex);
}