package hkmu.comp3820sef._820sef_project_s12992583.repository;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


public interface CommentRepository extends JpaRepository<Comment, Long> {

    List<Comment> findByParentCommentId(Long parentId);


    List<Comment> findByParentComment(Comment parentComment);

    List<Comment> findByLectureIdAndParentCommentIsNullOrderByCommentTimeDesc(Long lectureId);

    List<Comment> findByLecture(Lecture lecture);

    List<Comment> findByUserOrderByCommentTimeDesc(AppUser currentUser);
    @EntityGraph(attributePaths = {"lecture", "user"})
    List<Comment> findByUser(AppUser user, Sort sort);

    @EntityGraph(attributePaths = {"lecture", "user"})
    List<Comment> findByUserAndLectureId(AppUser user, Long lectureId, Sort sort);

    List<Comment> findByTargetTypeAndTargetIdAndParentCommentIsNull(String targetType, Long targetId);

    @Modifying    // Tells Spring this is an update/delete, not a query
    @Transactional
    void deleteByUser(AppUser user);


;
}
