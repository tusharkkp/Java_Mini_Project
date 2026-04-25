package com.disasterrelief.service;

import com.disasterrelief.entity.SosRequest;
import com.disasterrelief.entity.Task;
import com.disasterrelief.entity.Volunteer;
import com.disasterrelief.entity.enums.SosStatus;
import com.disasterrelief.entity.enums.TaskStatus;
import com.disasterrelief.repository.TaskRepository;
import com.disasterrelief.repository.JdbcSosLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Service layer for Task management.
 * Handles volunteer assignment to SOS requests and task lifecycle.
 */
@Service
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private SosRequestService sosRequestService;

    @Autowired
    private VolunteerService volunteerService;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private JdbcSosLogRepository jdbcSosLogRepository;

    @Transactional
    public Task assignVolunteer(Long sosId, Long volunteerId, String assignedBy) {
        SosRequest sos = sosRequestService.findById(sosId)
                .orElseThrow(() -> new RuntimeException("SOS not found"));
        Volunteer volunteer = volunteerService.findById(volunteerId)
                .orElseThrow(() -> new RuntimeException("Volunteer not found"));

        Task task = new Task(sos, volunteer);
        task.setStatus(TaskStatus.ASSIGNED);
        Task saved = taskRepository.save(task);

        sosRequestService.updateStatus(sosId, SosStatus.ASSIGNED, assignedBy);
        notificationService.sendNotificationAsync(volunteer.getUser().getId(),
                "Assigned to SOS #" + sosId + ": " + sos.getDescription(), "TASK_ASSIGNED");
        jdbcSosLogRepository.insertAuditLog(sosId, "ASSIGNED",
                "Volunteer " + volunteer.getUser().getFullName() + " assigned", assignedBy);
        return saved;
    }

    @Transactional
    public Task updateTaskStatus(Long taskId, TaskStatus newStatus, String updatedBy) {
        Task task = taskRepository.findById(taskId)
                .orElseThrow(() -> new RuntimeException("Task not found"));
        task.setStatus(newStatus);
        if (newStatus == TaskStatus.COMPLETED) {
            task.setCompletedAt(LocalDateTime.now());
            Volunteer v = task.getVolunteer();
            v.setTasksCompleted(v.getTasksCompleted() + 1);
            volunteerService.save(v);
            List<Task> all = taskRepository.findBySosRequestId(task.getSosRequest().getId());
            if (all.stream().allMatch(t -> t.getStatus() == TaskStatus.COMPLETED)) {
                sosRequestService.updateStatus(task.getSosRequest().getId(), SosStatus.RESOLVED, updatedBy);
            }
        }
        return taskRepository.save(task);
    }

    public List<Task> findByVolunteerId(Long id) { return taskRepository.findByVolunteerId(id); }
    public List<Task> findBySosRequestId(Long id) { return taskRepository.findBySosRequestId(id); }
    public Optional<Task> findById(Long id) { return taskRepository.findById(id); }
    public List<Task> findAll() { return taskRepository.findAll(); }
    public long countByStatus(TaskStatus s) { return taskRepository.countByStatus(s); }
}
