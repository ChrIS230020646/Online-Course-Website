package hkmu.comp3820sef._820sef_project_s12992583.dto;

import java.util.List;

public class PollDTO {
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
    public CourseDTO getCourse() { return course; }
    public void setCourse(CourseDTO course) { this.course = course; }
    // Getters and Setters
    public Long getId() { return id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title;  }
    public void setId(Long id) { this.id = id; }
    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }
    public List<String> getOptions() { return options; }
    public void setOptions(List<String> options) { this.options = options; }
    public int[] getVotes() { return votes; }
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

    public int getTotalVotes() { return totalVotes; }
    public void setTotalVotes(int totalVotes) { this.totalVotes = totalVotes; }
    public int getUserChoice() { return userChoice; }
    public void setUserChoice(int userChoice) { this.userChoice = userChoice; }
    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }
    public boolean isInstructor() { return instructor; }
    public void setInstructor(boolean instructor) { this.instructor = instructor; }
}