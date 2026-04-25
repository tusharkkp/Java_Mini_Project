package com.disasterrelief.repository;

import com.disasterrelief.entity.Task;
import com.disasterrelief.entity.enums.TaskStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Repository for Task entity operations.
 */
@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByVolunteerId(Long volunteerId);
    List<Task> findByStatus(TaskStatus status);
    List<Task> findBySosRequestId(Long sosRequestId);
    long countByVolunteerIdAndStatus(Long volunteerId, TaskStatus status);
    long countByStatus(TaskStatus status);
}
