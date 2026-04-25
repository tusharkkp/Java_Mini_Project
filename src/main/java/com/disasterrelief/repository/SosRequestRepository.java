package com.disasterrelief.repository;

import com.disasterrelief.entity.SosRequest;
import com.disasterrelief.entity.enums.SosStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Repository for SosRequest entity operations.
 */
@Repository
public interface SosRequestRepository extends JpaRepository<SosRequest, Long> {

    List<SosRequest> findByStatus(SosStatus status);

    List<SosRequest> findByUserId(Long userId);

    List<SosRequest> findByStatusIn(List<SosStatus> statuses);

    /**
     * HQL: Find unassigned SOS requests older than a given time (for escalation).
     */
    @Query("SELECT s FROM SosRequest s WHERE s.status = 'NEW' AND s.createdAt < :threshold")
    List<SosRequest> findUnassignedOlderThan(@Param("threshold") LocalDateTime threshold);

    /**
     * HQL: Calculate average response time for resolved SOS requests (SDG metric).
     */
    @Query("SELECT AVG(s.responseTimeMs) FROM SosRequest s WHERE s.status = 'RESOLVED' AND s.responseTimeMs IS NOT NULL")
    Double findAverageResponseTime();

    /**
     * HQL: Count SOS requests resolved within threshold time (SDG metric).
     */
    @Query("SELECT COUNT(s) FROM SosRequest s WHERE s.status = 'RESOLVED' AND s.responseTimeMs IS NOT NULL AND s.responseTimeMs <= :thresholdMs")
    long countResolvedWithinThreshold(@Param("thresholdMs") Long thresholdMs);

    @Query("SELECT COUNT(s) FROM SosRequest s WHERE s.status = 'RESOLVED'")
    long countResolved();

    long countByStatus(SosStatus status);
}
