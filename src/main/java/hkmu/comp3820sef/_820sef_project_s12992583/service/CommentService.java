package hkmu.comp3820sef._820sef_project_s12992583.service;

import hkmu.comp3820sef._820sef_project_s12992583.dto.CommentHistoryDTO;
import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.repository.CommentRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.LectureRepository;
import hkmu.comp3820sef._820sef_project_s12992583.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CommentService {
    @Autowired
    private CommentRepository commentRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private LectureRepository lectureRepository;
    @Transactional
    public Comment saveComment(String type, Long targetId, String description, Long parentId, String username) {
        AppUser user = userRepository.findByUsername(username);
        Comment comment = new Comment();
        comment.setDescription(description);
        comment.setUser(user);
        comment.setTargetType(type);
        comment.setTargetId(targetId);

        if (parentId != null) {
            commentRepository.findById(parentId).ifPresent(comment::setParentComment);
        }
        return commentRepository.save(comment);
    }


    public String getRedirectUrl(String type, Long targetId) {
        switch (type.toLowerCase()) {
            case "lecture":
                return "/course-material-page/" + targetId;
            case "assignment":
                return "/assignment-detail/" + targetId;
            case "poll":
                return "/polls/courses/0/poll/" + targetId;
            default:
                return "/";
        }
    }

    public List<Comment> getCommentsByTarget(String targetType, Long targetId) {

        return commentRepository.findByTargetTypeAndTargetIdAndParentCommentIsNull(targetType, targetId);
    }

    public void updateComment(Long id, String newContent) {
        Comment comment = commentRepository.findById(id).orElseThrow();

        comment.setDescription(newContent);
        comment.setCommentTime(LocalDateTime.now());
        commentRepository.save(comment);
    }

    public List<CommentHistoryDTO> getAllCommentHistory() {
        return commentRepository.findAll().stream().map(comment -> {
            CommentHistoryDTO dto = new CommentHistoryDTO();
            if(!comment.getLecture().getTitle().isEmpty())
            dto.setLectureTitle(comment.getLecture().getTitle());
            else {

                dto.setLectureTitle(lectureRepository.findById(comment.getTargetId()).get().getTitle());
            }
            dto.setContent(comment.getDescription());
            dto.setUsername(comment.getUser().getUsername());
            dto.setCreatedAt(comment.getCommentTime());
            return dto;
        }).collect(Collectors.toList());
    }

    public void deleteCommentsByTarget(String poll, Long pollId) {
    }
}