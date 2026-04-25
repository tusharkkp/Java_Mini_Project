package com.disasterrelief.entity;

import jakarta.persistence.*;

/**
 * Location entity - represents predefined geographic locations/areas.
 * Used for mapping SOS requests to known areas and volunteer assignment.
 * 
 * Table: locations
 */
@Entity
@Table(name = "locations")
public class Location {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false)
    private Double latitude;

    @Column(nullable = false)
    private Double longitude;

    @Column(name = "area_type", length = 50)
    private String areaType; // URBAN, SUBURBAN, RURAL, COASTAL

    @Column(length = 255)
    private String description;

    // --- Constructors ---
    public Location() {}

    public Location(String name, Double latitude, Double longitude, String areaType) {
        this.name = name;
        this.latitude = latitude;
        this.longitude = longitude;
        this.areaType = areaType;
    }

    // --- Getters and Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
    public String getAreaType() { return areaType; }
    public void setAreaType(String areaType) { this.areaType = areaType; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
