package com.disasterrelief.service;

import com.disasterrelief.repository.SosRequestRepository;
import com.disasterrelief.repository.VolunteerRepository;
import com.disasterrelief.repository.TaskRepository;
import com.disasterrelief.entity.enums.SosStatus;
import com.disasterrelief.entity.enums.TaskStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.Map;

/**
 * SDG METRICS SERVICE (Rubric Requirement):
 * 
 * Calculates Sustainable Development Goal (SDG) impact metrics:
 * - Average response time to SOS emergencies
 * - Percentage of SOS handled within threshold time
 * - Volunteer engagement and performance statistics
 * 
 * SDG 11: Sustainable Cities and Communities
 * SDG 13: Climate Action
 */
@Service
public class SdgMetricsService {

    @Autowired
    private SosRequestRepository sosRequestRepository;

    @Autowired
    private VolunteerRepository volunteerRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Value("${sdg.response.threshold.minutes:30}")
    private int responseThresholdMinutes;

    /**
     * Calculate all SDG metrics and return as a map for dashboard display.
     */
    public Map<String, Object> calculateMetrics() {
        Map<String, Object> metrics = new HashMap<>();

        // Total SOS requests
        long totalSos = sosRequestRepository.count();
        metrics.put("totalSosRequests", totalSos);

        // SOS by status
        metrics.put("newSos", sosRequestRepository.countByStatus(SosStatus.NEW));
        metrics.put("activeSos", sosRequestRepository.countByStatus(SosStatus.ACTIVE));
        metrics.put("assignedSos", sosRequestRepository.countByStatus(SosStatus.ASSIGNED));
        metrics.put("resolvedSos", sosRequestRepository.countByStatus(SosStatus.RESOLVED));
        metrics.put("escalatedSos", sosRequestRepository.countByStatus(SosStatus.ESCALATED));

        // Average response time (in minutes)
        Double avgResponseMs = sosRequestRepository.findAverageResponseTime();
        double avgResponseMinutes = (avgResponseMs != null) ? avgResponseMs / 60000.0 : 0.0;
        metrics.put("avgResponseTimeMinutes", Math.round(avgResponseMinutes * 100.0) / 100.0);

        // % SOS handled within threshold
        long thresholdMs = (long) responseThresholdMinutes * 60 * 1000;
        long resolvedWithinThreshold = sosRequestRepository.countResolvedWithinThreshold(thresholdMs);
        long totalResolved = sosRequestRepository.countResolved();
        double percentWithinThreshold = (totalResolved > 0)
                ? (resolvedWithinThreshold * 100.0 / totalResolved) : 0.0;
        metrics.put("percentHandledWithinThreshold", Math.round(percentWithinThreshold * 100.0) / 100.0);
        metrics.put("responseThresholdMinutes", responseThresholdMinutes);

        // Volunteer metrics
        long totalVolunteers = volunteerRepository.count();
        long availableVolunteers = volunteerRepository.countAvailableVolunteers();
        metrics.put("totalVolunteers", totalVolunteers);
        metrics.put("availableVolunteers", availableVolunteers);

        // Task metrics
        metrics.put("pendingTasks", taskRepository.countByStatus(TaskStatus.PENDING));
        metrics.put("completedTasks", taskRepository.countByStatus(TaskStatus.COMPLETED));

        return metrics;
    }
}
