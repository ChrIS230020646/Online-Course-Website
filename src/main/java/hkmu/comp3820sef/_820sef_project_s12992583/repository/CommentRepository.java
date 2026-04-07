package hkmu.comp3820sef._820sef_project_s12992583.repository;

import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import hkmu.comp3820sef._820sef_project_s12992583.model.Comment;
import hkmu.comp3820sef._820sef_project_s12992583.model.Lecture;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface CommentRepository extends JpaRepository<Comment, Long> {
    // 透過父評論物件的 ID 欄位來查詢
    List<Comment> findByParentCommentId(Long parentId);

    // 或是直接傳入整個父評論物件來查詢
    List<Comment> findByParentComment(Comment parentComment);

    List<Comment> findByLectureIdAndParentCommentIsNullOrderByCommentTimeDesc(Long lectureId);

    List<Comment> findByLecture(Lecture lecture);

    List<Comment> findByUserOrderByCommentTimeDesc(AppUser currentUser);
    @EntityGraph(attributePaths = {"lecture", "user"})
    List<Comment> findByUser(AppUser user, Sort sort);

    @EntityGraph(attributePaths = {"lecture", "user"})
    List<Comment> findByUserAndLectureId(AppUser user, Long lectureId, Sort sort);
}
