package hkmu.comp3820sef._820sef_project_s12992583.dto;

import lombok.Getter;

import java.util.List;

@Getter
public class PollDTO {
    // Getters and Setters
    private Long id;
    private String question;
    private List<String> options;
    private int[] votes;
    private int totalVotes;
    private int userChoice;
    private Long courseId;
    private boolean instructor;
    private CourseDTO course;
    private  String title;

    public void setCourse(CourseDTO course) { this.course = course; }

    public void setTitle(String title) { this.title = title;  }
    public void setId(Long id) { this.id = id; }

    public void setQuestion(String question) { this.question = question; }

    public void setOptions(List<String> options) { this.options = options; }

    public void setVotes(int[] votes) { this.votes = votes; }
    public void setVotes(List<Integer> voteList) {
        if (voteList == null || voteList.isEmpty()) {
            this.votes = new int[0];
            this.totalVotes = 0;
            return;
        }

        this.votes = voteList.stream()
                .mapToInt(Integer::intValue)
                .toArray();
        this.totalVotes = 0;
        for (int v : this.votes) {
            this.totalVotes += v;
        }
    }

    public void setTotalVotes(int totalVotes) { this.totalVotes = totalVotes; }

    public void setUserChoice(int userChoice) { this.userChoice = userChoice; }

    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public void setInstructor(boolean instructor) { this.instructor = instructor; }
}