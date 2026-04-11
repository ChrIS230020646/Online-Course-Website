package hkmu.comp3820sef._820sef_project_s12992583.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "comments")
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String description;

    @Column(nullable = false)
    private LocalDateTime commentTime;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private AppUser user;

    @ManyToOne
    @JoinColumn(name = "lecture_id")
    private Lecture lecture;


    @ManyToOne
    @JoinColumn(name = "parent_id")
    private Comment parentComment;

    @OneToMany(mappedBy = "parentComment", cascade = CascadeType.ALL)
    @OrderBy("commentTime ASC")
    private List<Comment> replies = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "reply_to_user_id")
    private AppUser replyToUser;


    // -----------------------
    public AppUser getReplyToUser() { return replyToUser; }
    public void setReplyToUser(AppUser replyToUser) { this.replyToUser = replyToUser; }

    public Comment() {}
    @Column(nullable = false)
    private String targetType;

    @Column(nullable = false)
    private Long targetId;

    // Getter and Setter
    public String getTargetType() { return targetType; }
    public void setTargetType(String targetType) { this.targetType = targetType; }

    public Long getTargetId() { return targetId; }
    public void setTargetId(Long targetId) { this.targetId = targetId; }
    @PrePersist
    protected void onCreate() {
        this.commentTime = LocalDateTime.now();
    }

    // Getter and Setter
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getCommentTime() { return commentTime; }
    public void setCommentTime(LocalDateTime commentTime) { this.commentTime = commentTime; }

    public AppUser getUser() { return user; }
    public void setUser(AppUser user) { this.user = user; }

    public Lecture getLecture() { return lecture; }
    public void setLecture(Lecture lecture) { this.lecture = lecture; }

    public Comment getParentComment() { return parentComment; }
    public void setParentComment(Comment parentComment) { this.parentComment = parentComment; }

    public List<Comment> getReplies() { return replies; }
    public void setReplies(List<Comment> replies) { this.replies = replies; }



    public void setUpdatedAt(LocalDateTime localDateTime) {
    }
}