package com.disasterrelief.service;

import com.disasterrelief.entity.SosRequest;
import com.disasterrelief.entity.User;
import com.disasterrelief.entity.enums.SeverityLevel;
import com.disasterrelief.entity.enums.SosStatus;
import com.disasterrelief.repository.SosRequestRepository;
import com.disasterrelief.repository.JdbcSosLogRepository;
import com.disasterrelief.socket.SosAlertSocketServer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;

/**
 * Service layer for SOS Emergency Request management.
 * 
 * When an SOS is created, this service:
 * 1. Saves the SOS to the database
 * 2. Triggers async notification to volunteers (@Async)
 * 3. Broadcasts via socket to connected volunteer clients (Socket Programming)
 * 4. Logs the action via raw JDBC (JDBC requirement)
 */
@Service
public class SosRequestService {

    @Autowired
    private SosRequestRepository sosRequestRepository;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private JdbcSosLogRepository jdbcSosLogRepository;

    @Autowired
    private SosAlertSocketServer socketServer;

    /**
     * Create a new SOS emergency request.
     * Triggers: async notification + socket broadcast + JDBC audit log
     */
    @Transactional
    public SosRequest createSosRequest(User user, Double latitude, Double longitude,
                                       String locationName, String description, SeverityLevel severity) {
        // 1. Create and save SOS request
        SosRequest sos = new SosRequest(user, latitude, longitude, description, severity);
        sos.setLocationName(locationName);
        SosRequest savedSos = sosRequestRepository.save(sos);

        // 2. Trigger ASYNC notification to all volunteers (Multithreading)
        String message = "🚨 NEW SOS ALERT! Severity: " + severity +
                         " | Location: " + locationName +
                         " | Description: " + description;
        notificationService.broadcastToRole("ROLE_VOLUNTEER", message, "SOS_ALERT");

        // 3. Broadcast via SOCKET to connected volunteer clients (Socket Programming)
        String socketMessage = "SOS|" + savedSos.getId() + "|" + severity + "|" +
                               latitude + "|" + longitude + "|" + locationName + "|" + description;
        runAfterCommitAsync(() -> {
            try {
                socketServer.broadcastMessage(socketMessage);
            } catch (Exception e) {
                System.err.println("[SOCKET] Async SOS broadcast failed: " + e.getMessage());
            }
        });

        // 4. Log via raw JDBC (JDBC Requirement)
        runAfterCommitAsync(() -> {
            try {
                jdbcSosLogRepository.insertAuditLog(savedSos.getId(), "CREATED",
                        "SOS created with severity: " + severity, user.getUsername());
            } catch (Exception e) {
                System.err.println("[JDBC] Async SOS audit logging failed: " + e.getMessage());
            }
        });

        System.out.println("[SOS] Emergency request #" + savedSos.getId() + " created by " + user.getUsername());
        return savedSos;
    }

    private void runAfterCommitAsync(Runnable task) {
        if (TransactionSynchronizationManager.isSynchronizationActive()) {
            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                @Override
                public void afterCommit() {
                    CompletableFuture.runAsync(task);
                }
            });
        } else {
            CompletableFuture.runAsync(task);
        }
    }

    /**
     * Update SOS status and record response time if being assigned.
     */
    @Transactional
    public SosRequest updateStatus(Long sosId, SosStatus newStatus, String performedBy) {
        SosRequest sos = sosRequestRepository.findById(sosId)
                .orElseThrow(() -> new RuntimeException("SOS not found: " + sosId));

        sos.setStatus(newStatus);

        // Calculate response time when first assigned
        if (newStatus == SosStatus.ASSIGNED && sos.getResponseTimeMs() == null) {
            long responseTimeMs = java.time.Duration.between(sos.getCreatedAt(), LocalDateTime.now()).toMillis();
            sos.setResponseTimeMs(responseTimeMs);
        }

        // Set resolved time when resolved
        if (newStatus == SosStatus.RESOLVED) {
            sos.setResolvedAt(LocalDateTime.now());
        }

        SosRequest updated = sosRequestRepository.save(sos);

        // Log status change via JDBC
        jdbcSosLogRepository.insertAuditLog(sosId, "STATUS_CHANGED",
                "Status changed to: " + newStatus, performedBy);

        return updated;
    }

    public List<SosRequest> findAll() {
        return sosRequestRepository.findAll();
    }

    public Optional<SosRequest> findById(Long id) {
        return sosRequestRepository.findById(id);
    }

    public List<SosRequest> findByStatus(SosStatus status) {
        return sosRequestRepository.findByStatus(status);
    }

    public List<SosRequest> findByUserId(Long userId) {
        return sosRequestRepository.findByUserId(userId);
    }

    public List<SosRequest> findUnassignedOlderThan(LocalDateTime threshold) {
        return sosRequestRepository.findUnassignedOlderThan(threshold);
    }

    public long count() {
        return sosRequestRepository.count();
    }

    public long countByStatus(SosStatus status) {
        return sosRequestRepository.countByStatus(status);
    }
}
