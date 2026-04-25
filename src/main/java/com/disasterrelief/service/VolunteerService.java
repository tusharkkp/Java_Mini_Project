package com.disasterrelief.service;

import com.disasterrelief.entity.Volunteer;
import com.disasterrelief.repository.VolunteerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Service layer for Volunteer management.
 * Handles availability, location updates, and distance-based volunteer selection.
 */
@Service
public class VolunteerService {

    @Autowired
    private VolunteerRepository volunteerRepository;

    /**
     * Toggle volunteer availability (active/inactive).
     */
    public Volunteer toggleAvailability(Long volunteerId) {
        Volunteer volunteer = volunteerRepository.findById(volunteerId)
                .orElseThrow(() -> new RuntimeException("Volunteer not found: " + volunteerId));
        volunteer.setAvailable(!volunteer.getAvailable());
        return volunteerRepository.save(volunteer);
    }

    /**
     * Update volunteer location coordinates.
     */
    public Volunteer updateLocation(Long volunteerId, Double latitude, Double longitude) {
        Volunteer volunteer = volunteerRepository.findById(volunteerId)
                .orElseThrow(() -> new RuntimeException("Volunteer not found: " + volunteerId));
        volunteer.setLatitude(latitude);
        volunteer.setLongitude(longitude);
        return volunteerRepository.save(volunteer);
    }

    /**
     * DISTANCE-BASED VOLUNTEER SELECTION (Advanced Add-On):
     * 
     * Finds available volunteers sorted by proximity to SOS location.
     * Uses HQL query with distance approximation.
     * Returns top N nearest volunteers.
     */
    public List<Volunteer> findNearestAvailableVolunteers(Double latitude, Double longitude, int limit) {
        List<Volunteer> volunteers = volunteerRepository.findAvailableVolunteersByDistance(latitude, longitude);
        // Return only the top N nearest
        return volunteers.stream().limit(limit).toList();
    }

    /**
     * Calculate distance between two points using Haversine formula.
     * Returns distance in kilometers.
     * 
     * This is a utility method used for precise distance calculation
     * when displaying distance info in the UI.
     */
    public static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final double R = 6371; // Earth's radius in kilometers
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                 + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                 * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    public List<Volunteer> findAll() {
        return volunteerRepository.findAll();
    }

    public Optional<Volunteer> findById(Long id) {
        return volunteerRepository.findById(id);
    }

    public Optional<Volunteer> findByUserId(Long userId) {
        return volunteerRepository.findByUserId(userId);
    }

    public List<Volunteer> findAvailable() {
        return volunteerRepository.findByAvailableTrue();
    }

    public long countAvailable() {
        return volunteerRepository.countAvailableVolunteers();
    }

    public List<Volunteer> findTopVolunteers() {
        return volunteerRepository.findTopVolunteers();
    }

    public Volunteer save(Volunteer volunteer) {
        return volunteerRepository.save(volunteer);
    }
}
