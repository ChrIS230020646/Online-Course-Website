package hkmu.comp3820sef._820sef_project_s12992583.service;

import hkmu.comp3820sef._820sef_project_s12992583.dto.CommentHistoryDTO;
import hkmu.comp3820sef._820sef_project_s12992583.dto.PollHistoryDTO;
import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import hkmu.comp3820sef._820sef_project_s12992583.model.PollResponse;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CommentRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.PollRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.PollResponseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class HistoryService {
    @Autowired
    private CommentRepository commentRepository;
    @Autowired private PollResponseRepository pollResponseRepository;
    @Autowired private LectureRepository lectureRepository;
    @Autowired private PollRepository pollRepository;
    public List<CommentHistoryDTO> getAllCommentHistory() {
        return commentRepository.findAll().stream().map(this::toCommentDTO).toList();
    }

    public List<PollHistoryDTO> getAllPollHistory() {
        return pollResponseRepository.findAll().stream().map(this::toPollDTO).toList();
    }


    private CommentHistoryDTO toCommentDTO(Comment cmt) {
        CommentHistoryDTO dto = new CommentHistoryDTO();
        dto.setContent(cmt.getDescription());
        dto.setUsername(cmt.getUser().getUsername());
        dto.setUserProfilePicture(cmt.getUser().getProfilePicture());
        dto.setCreatedAt(cmt.getCommentTime());

        if (cmt.getTargetId() != null) {
            // 最少改動：使用 ifPresent 確保只有在資料存在時才執行 get()
            lectureRepository.findById(cmt.getTargetId()).ifPresent(lecture -> {
                dto.setLectureID(lecture.getId());
                dto.setLectureTitle(lecture.getTitle());
                if (lecture.getCourse() != null) {
                    dto.setCourseId(lecture.getCourse().getId());
                }
            });
        }
        return dto;
    }


    private PollHistoryDTO toPollDTO(PollResponse res) {
        PollHistoryDTO dto = new PollHistoryDTO();
        dto.setPollId(res.getPoll().getId());
        dto.setCourseId(res.getPoll().getCourse().getId());
        dto.setPollQuestion(res.getPoll().getQuestion());
        dto.setSelectedOption(res.getSelectedOptionText());
        dto.setVoteTime(res.getVoteTime());
        dto.setVoterName(res.getUser().getUsername());
        return dto;
    }

}