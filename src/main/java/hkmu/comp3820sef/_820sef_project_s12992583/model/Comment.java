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

    // --- 回覆功能的關鍵修正 ---

    // 指向「父評論」，這就是你想要的 reply_id 邏輯
    @ManyToOne
    @JoinColumn(name = "parent_id") // 資料庫會產生 parent_id 欄位
    private Comment parentComment;

    // 一個評論可以有多個回覆
    @OneToMany(mappedBy = "parentComment", cascade = CascadeType.ALL)
    @OrderBy("commentTime ASC") // 讓回覆按時間先後排序
    private List<Comment> replies = new ArrayList<>();

    // -----------------------

    public Comment() {}

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
}