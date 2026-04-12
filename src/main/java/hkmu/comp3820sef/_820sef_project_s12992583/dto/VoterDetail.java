package hkmu.comp3820sef._820sef_project_s12992583.dto;

import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class VoterDetail {
    // Getters 和 Setters
    private String username;
    private String optionText;
    private LocalDateTime voteTime;

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