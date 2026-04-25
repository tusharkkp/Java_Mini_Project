package com.disasterrelief.entity;

import jakarta.persistence.*;

/**
 * Volunteer entity - represents a registered volunteer with location and availability.
 * 
 * JPA Relationships:
 * - @OneToOne with User (a volunteer is always linked to a user account)
 * 
 * Features:
 * - Latitude/longitude for distance-based task assignment (Haversine formula)
 * - Availability toggle (active/inactive)
 * - Skills field for matching to specific emergencies
 * - Task completion counter for performance tracking
 * 
 * Table: volunteers
 */
@Entity
@Table(name = "volunteers")
public class Volunteer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * One-to-One relationship with User entity.
     * Each volunteer must be linked to exactly one user account.
     * JoinColumn creates a foreign key 'user_id' in the volunteers table.
     */
    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private Double latitude = 0.0;

    @Column(nullable = false)
    private Double longitude = 0.0;

    @Column(nullable = false)
    private Boolean available = true;

    @Column(length = 255)
    private String skills;

    @Column(name = "tasks_completed")
    private Integer tasksCompleted = 0;

    @Column(name = "avg_response_time_ms")
    private Long avgResponseTimeMs = 0L;

    // --- Constructors ---
    public Volunteer() {}

    public Volunteer(User user, Double latitude, Double longitude, String skills) {
        this.user = user;
        this.latitude = latitude;
        this.longitude = longitude;
        this.skills = skills;
    }

    // --- Getters and Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public Boolean getAvailable() { return available; }
    public void setAvailable(Boolean available) { this.available = available; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public Integer getTasksCompleted() { return tasksCompleted; }
    public void setTasksCompleted(Integer tasksCompleted) { this.tasksCompleted = tasksCompleted; }

    public Long getAvgResponseTimeMs() { return avgResponseTimeMs; }
    public void setAvgResponseTimeMs(Long avgResponseTimeMs) { this.avgResponseTimeMs = avgResponseTimeMs; }
}
