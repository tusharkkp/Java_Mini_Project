package com.disasterrelief.entity;

import com.disasterrelief.entity.enums.TaskStatus;
import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Task entity - represents a volunteer assignment linked to an SOS request.
 * 
 * JPA Relationships:
 * - @ManyToOne with SosRequest (many tasks can be assigned to one SOS)
 * - @ManyToOne with Volunteer (many tasks can be assigned to one volunteer)
 * 
 * Status Lifecycle: PENDING → ASSIGNED → IN_PROGRESS → COMPLETED (or CANCELLED)
 * 
 * Table: tasks
 */
@Entity
@Table(name = "tasks")
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Many-to-One: multiple tasks can be created for one SOS request.
     * For example, multiple volunteers may be dispatched for a critical SOS.
     */
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "sos_request_id", nullable = false)
    private SosRequest sosRequest;

    /**
     * Many-to-One: a volunteer can have multiple tasks assigned.
     * JoinColumn creates foreign key 'volunteer_id' in tasks table.
     */
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "volunteer_id", nullable = false)
    private Volunteer volunteer;

    /**
     * Task status stored as String for database readability.
     * Tracks the lifecycle: PENDING → ASSIGNED → IN_PROGRESS → COMPLETED
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TaskStatus status = TaskStatus.PENDING;

    @Column(name = "assigned_at")
    private LocalDateTime assignedAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Column(length = 500)
    private String notes;

    // --- Lifecycle callback ---
    @PrePersist
    protected void onCreate() {
        this.assignedAt = LocalDateTime.now();
    }

    // --- Constructors ---
    public Task() {}

    public Task(SosRequest sosRequest, Volunteer volunteer) {
        this.sosRequest = sosRequest;
        this.volunteer = volunteer;
        this.status = TaskStatus.ASSIGNED;
    }

    // --- Getters and Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public SosRequest getSosRequest() { return sosRequest; }
    public void setSosRequest(SosRequest sosRequest) { this.sosRequest = sosRequest; }

    public Volunteer getVolunteer() { return volunteer; }
    public void setVolunteer(Volunteer volunteer) { this.volunteer = volunteer; }

    public TaskStatus getStatus() { return status; }
    public void setStatus(TaskStatus status) { this.status = status; }

    public LocalDateTime getAssignedAt() { return assignedAt; }
    public void setAssignedAt(LocalDateTime assignedAt) { this.assignedAt = assignedAt; }

    public LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt) { this.completedAt = completedAt; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
