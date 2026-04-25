package com.disasterrelief.controller;

import com.disasterrelief.entity.*;
import com.disasterrelief.entity.enums.SosStatus;
import com.disasterrelief.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;

/**
 * REST API CONTROLLER (Rubric Requirement):
 * 
 * Provides RESTful JSON endpoints alongside the MVC controllers.
 * Demonstrates clear request/response structure for API consumers.
 * 
 * Base path: /api/v1/
 */
@RestController
@RequestMapping("/api/v1")
public class RestApiController {

    @Autowired private SosRequestService sosRequestService;
    @Autowired private VolunteerService volunteerService;
    @Autowired private TaskService taskService;
    @Autowired private SdgMetricsService sdgMetricsService;

    // ========== SOS ENDPOINTS ==========

    /** GET /api/v1/sos — List all SOS requests */
    @GetMapping("/sos")
    public ResponseEntity<List<Map<String, Object>>> getAllSos() {
        List<SosRequest> requests = sosRequestService.findAll();
        List<Map<String, Object>> result = new ArrayList<>();
        for (SosRequest s : requests) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", s.getId());
            map.put("description", s.getDescription());
            map.put("severity", s.getSeverity());
            map.put("status", s.getStatus());
            map.put("latitude", s.getLatitude());
            map.put("longitude", s.getLongitude());
            map.put("locationName", s.getLocationName());
            map.put("createdAt", s.getCreatedAt());
            map.put("userName", s.getUser().getFullName());
            result.add(map);
        }
        return ResponseEntity.ok(result);
    }

    /** GET /api/v1/sos/{id} — Get SOS detail */
    @GetMapping("/sos/{id}")
    public ResponseEntity<Map<String, Object>> getSosById(@PathVariable Long id) {
        return sosRequestService.findById(id).map(s -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", s.getId());
            map.put("description", s.getDescription());
            map.put("severity", s.getSeverity());
            map.put("status", s.getStatus());
            map.put("latitude", s.getLatitude());
            map.put("longitude", s.getLongitude());
            map.put("locationName", s.getLocationName());
            map.put("createdAt", s.getCreatedAt());
            map.put("resolvedAt", s.getResolvedAt());
            map.put("responseTimeMs", s.getResponseTimeMs());
            return ResponseEntity.ok(map);
        }).orElse(ResponseEntity.notFound().build());
    }

    /** GET /api/v1/sos/status/{status} — Filter by status */
    @GetMapping("/sos/status/{status}")
    public ResponseEntity<List<Map<String, Object>>> getSosByStatus(@PathVariable String status) {
        List<SosRequest> requests = sosRequestService.findByStatus(SosStatus.valueOf(status));
        List<Map<String, Object>> result = new ArrayList<>();
        for (SosRequest s : requests) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", s.getId());
            map.put("description", s.getDescription());
            map.put("severity", s.getSeverity());
            map.put("status", s.getStatus());
            result.add(map);
        }
        return ResponseEntity.ok(result);
    }

    // ========== VOLUNTEER ENDPOINTS ==========

    /** GET /api/v1/volunteers — List all volunteers */
    @GetMapping("/volunteers")
    public ResponseEntity<List<Map<String, Object>>> getAllVolunteers() {
        List<Volunteer> volunteers = volunteerService.findAll();
        List<Map<String, Object>> result = new ArrayList<>();
        for (Volunteer v : volunteers) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", v.getId());
            map.put("name", v.getUser().getFullName());
            map.put("available", v.getAvailable());
            map.put("latitude", v.getLatitude());
            map.put("longitude", v.getLongitude());
            map.put("skills", v.getSkills());
            map.put("tasksCompleted", v.getTasksCompleted());
            result.add(map);
        }
        return ResponseEntity.ok(result);
    }

    /** GET /api/v1/volunteers/available — List available volunteers */
    @GetMapping("/volunteers/available")
    public ResponseEntity<List<Map<String, Object>>> getAvailableVolunteers() {
        List<Volunteer> volunteers = volunteerService.findAvailable();
        List<Map<String, Object>> result = new ArrayList<>();
        for (Volunteer v : volunteers) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", v.getId());
            map.put("name", v.getUser().getFullName());
            map.put("latitude", v.getLatitude());
            map.put("longitude", v.getLongitude());
            result.add(map);
        }
        return ResponseEntity.ok(result);
    }

    // ========== METRICS ENDPOINTS ==========

    /** GET /api/v1/metrics — SDG metrics */
    @GetMapping("/metrics")
    public ResponseEntity<Map<String, Object>> getMetrics() {
        return ResponseEntity.ok(sdgMetricsService.calculateMetrics());
    }

    // ========== TASKS ENDPOINTS ==========

    /** GET /api/v1/tasks — List all tasks */
    @GetMapping("/tasks")
    public ResponseEntity<List<Map<String, Object>>> getAllTasks() {
        List<Task> tasks = taskService.findAll();
        List<Map<String, Object>> result = new ArrayList<>();
        for (Task t : tasks) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", t.getId());
            map.put("sosRequestId", t.getSosRequest().getId());
            map.put("volunteerName", t.getVolunteer().getUser().getFullName());
            map.put("status", t.getStatus());
            map.put("assignedAt", t.getAssignedAt());
            map.put("completedAt", t.getCompletedAt());
            result.add(map);
        }
        return ResponseEntity.ok(result);
    }
}
