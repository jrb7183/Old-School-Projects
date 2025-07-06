
import java.sql.Timestamp;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Joshua Bassin
 */
public class ScheduleEntry {
    private String semester;
    private String studentID;
    private String courseCode;
    private String status;
    private java.sql.Timestamp timestamp;

    public ScheduleEntry(String semester, String studentID, String courseCode, String status, Timestamp timestamp) {
        this.semester = semester;
        this.studentID = studentID;
        this.courseCode = courseCode;
        this.status = status;
        this.timestamp = timestamp;
    }

    public String getSemester() {
        return semester;
    }

    public String getStudentID() {
        return studentID;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public String getStatus() {
        return status;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }
}
