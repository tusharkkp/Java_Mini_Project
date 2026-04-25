package com.disasterrelief.entity;

import com.disasterrelief.entity.enums.SeverityLevel;
import com.disasterrelief.entity.enums.SosStatus;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * SosRequest entity - represents an emergency SOS request raised by a user.
 * 
 * JPA Relationships:
 * - @ManyToOne with User (many SOS requests can belong to one user)
 * - @OneToMany with Task (one SOS can have multiple volunteer tasks assigned)
 * 
 * Features:
 * - Location tracking (latitude/longitude) for distance-based volunteer matching
 * - Severity levels (LOW, MEDIUM, HIGH, CRITICAL)
 * - Status lifecycle (NEW → ACTIVE → ASSIGNED → RESOLVED or ESCALATED)
 * - Response time tracking for SDG metrics
 * 
 * Table: sos_requests
 */
@Entity
@Table(name = "sos_requests")
public class SosRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Many-to-One relationship: multiple SOS requests belong to one user.
     * JoinColumn creates foreign key 'user_id' in sos_requests table.
     */
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private Double latitude;

    @Column(nullable = false)
    private Double longitude;

    @Column(name = "location_name", length = 255)
    private String locationName;

    @Column(nullable = false, length = 500)
    private String description;

    /**
     * Enum stored as String in database for readability.
     * Possible values: LOW, MEDIUM, HIGH, CRITICAL
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private SeverityLevel severity;

    /**
     * Enum stored as String in database for readability.
     * Possible values: NEW, ACTIVE, ASSIGNED, RESOLVED, ESCALATED
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private SosStatus status = SosStatus.NEW;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "resolved_at")
    private LocalDateTime resolvedAt;

    /**
     * Response time in milliseconds from creation to first volunteer assignment.
     * Used for SDG metrics calculation.
     */
    @Column(name = "response_time_ms")
    private Long responseTimeMs;

    /**
     * One-to-Many relationship: one SOS request can have multiple tasks assigned.
     * mappedBy indicates Task entity owns the relationship via 'sosRequest' field.
     */
    @OneToMany(mappedBy = "sosRequest", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Task> tasks = new ArrayList<>();

    // --- Lifecycle callback ---
    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    // --- Constructors ---
    public SosRequest() {}

    public SosRequest(User user, Double latitude, Double longitude, String description, SeverityLevel severity) {
        this.user = user;
        this.latitude = latitude;
        this.longitude = longitude;
        this.description = description;
        this.severity = severity;
        this.status = SosStatus.NEW;
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

    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public SeverityLevel getSeverity() { return severity; }
    public void setSeverity(SeverityLevel severity) { this.severity = severity; }

    public SosStatus getStatus() { return status; }
    public void setStatus(SosStatus status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(LocalDateTime resolvedAt) { this.resolvedAt = resolvedAt; }

    public Long getResponseTimeMs() { return responseTimeMs; }
    public void setResponseTimeMs(Long responseTimeMs) { this.responseTimeMs = responseTimeMs; }

    public List<Task> getTasks() { return tasks; }
    public void setTasks(List<Task> tasks) { this.tasks = tasks; }
}
