package hkmu.comp3820sef._820sef_project_s12992583.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "poll_responses") // 建議用複數，避開某些資料庫的保留字
public class PollResponse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id") // 明確指定外鍵名稱
    private AppUser user;

    @ManyToOne
    @JoinColumn(name = "poll_id") // 明確指定外鍵名稱
    private Poll poll;

    private int selectedOptionIndex;
    private String selectedOptionText;

    private LocalDateTime voteTime = LocalDateTime.now();

    public PollResponse() {}

    public PollResponse(AppUser user, Poll poll, int selectedOptionIndex) {
        this.user = user;
        this.poll = poll;
        this.selectedOptionIndex = selectedOptionIndex;
        this.voteTime = LocalDateTime.now();
    }

    // --- Getters and Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public AppUser getUser() { return user; }
    public void setUser(AppUser user) { this.user = user; }

    public Poll getPoll() { return poll; }
    public void setPoll(Poll poll) { this.poll = poll; }

    public int getSelectedOptionIndex() { return selectedOptionIndex; }
    public void setSelectedOptionIndex(int selectedOptionIndex) { this.selectedOptionIndex = selectedOptionIndex; }

    public String getSelectedOptionText() { return selectedOptionText; }
    public void setSelectedOptionText(String selectedOptionText) { this.selectedOptionText = selectedOptionText; }

    public LocalDateTime getVoteTime() { return voteTime; }
    public void setVoteTime(LocalDateTime voteTime) { this.voteTime = voteTime; }
}