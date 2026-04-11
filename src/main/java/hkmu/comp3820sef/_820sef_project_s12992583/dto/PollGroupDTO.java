package hkmu.comp3820sef._820sef_project_s12992583.dto;


import hkmu.comp3820sef._820sef_project_s12992583.model.AppUser;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
@Setter
@Getter
public class PollGroupDTO {
    private Long pollId;
    private String pollQuestion;
    private String courseId;
    private List<VoterDetail> voters;
    private String CreatedBy;

}