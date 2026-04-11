package hkmu.comp3820sef._820sef_project_s12992583.dto;

import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class VoterDetail {
    // Getters 和 Setters
    private String username;    // 投票學生姓名
    private String optionText;  // 學生選的選項
    private LocalDateTime voteTime; // 投票時間

    public VoterDetail(String username, String optionText, LocalDateTime voteTime) {
        this.username = username;
        this.optionText = optionText;
        this.voteTime = voteTime;
    }

    public VoterDetail() {

    }

    public void setOptionText(String selectedOptionText) {
        this.optionText=selectedOptionText;
    }

    public void setVoteTime(LocalDateTime voteTime) {
        this.voteTime=voteTime;
    }
    public void setUsername(String username) {
        this.username=username;
    }
}