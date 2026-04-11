package hkmu.comp3820sef._820sef_project_s12992583.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Getter
public class CommentHistoryDTO {
    private String lectureTitle;
    private String content;
    private String username;
    private LocalDateTime createdAt;
    private long lectureID;
    private Long courseId;


    private String userProfilePicture;

}