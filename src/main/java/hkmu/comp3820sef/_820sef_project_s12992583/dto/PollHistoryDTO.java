package hkmu.comp3820sef._820sef_project_s12992583.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
public class PollHistoryDTO {
    private Long pollId;
    private Long courseId;
    private String pollQuestion;
    private String selectedOption;
    private LocalDateTime voteTime;
    private String voterName;
    private Long voterId;


}