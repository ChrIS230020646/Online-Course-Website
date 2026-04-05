package hkmu.comp3820sef._820sef_project_s12992583.model;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    @Column(length = 1000)
    private String description;

    private String category;

    @ManyToOne
    @JoinColumn(name = "instructor_id")
    private AppUser instructor;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL)
    private List<Lecture> lectures = new ArrayList<>();

    @ManyToMany(mappedBy = "enrolledCourses")
    private List<AppUser> students = new ArrayList<>();

    // Add this field near your lectures field
    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL)
    private List<Poll> polls = new ArrayList<>();

    // Add these methods at the bottom of the class
    public List<Poll> getPolls() {
        return polls;
    }

    public void setPolls(List<Poll> polls) {
        this.polls = polls;
    }



    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public AppUser getInstructor() {
        return instructor;
    }

    public void setInstructor(AppUser instructor) {
        this.instructor = instructor;
    }




    public List<Lecture> getLectures() {
        return lectures;
    }

    public void setLectures(List<Lecture> lectures) {
        this.lectures = lectures;
    }

    public List<AppUser> getStudents() { return students; }

    public void setStudents(List<AppUser> students) { this.students = students; }
}

