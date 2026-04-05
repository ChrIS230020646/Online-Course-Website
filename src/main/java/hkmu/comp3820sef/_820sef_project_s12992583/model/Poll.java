package hkmu.comp3820sef._820sef_project_s12992583.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Poll {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String question;

    @ElementCollection // This stores the 5 MC options
    private List<String> options = new ArrayList<>();

    @ElementCollection // This stores the current number of votes for each option
    private List<Integer> votes = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "course_id")
    private Course course;

    // Getters and Setters (Important for JSP!)
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }
    public List<String> getOptions() { return options; }
    public void setOptions(List<String> options) { this.options = options; }
    public List<Integer> getVotes() { return votes; }
    public void setVotes(List<Integer> votes) { this.votes = votes; }
    public Course getCourse() { return course; }
    public void setCourse(Course course) { this.course = course; }
}