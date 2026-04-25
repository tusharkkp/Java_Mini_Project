package com.disasterrelief.entity.enums;

import java.util.Locale;

/**
 * Status tracking for volunteer tasks/assignments.
 * Represents the lifecycle of a task from assignment to completion.
 * 
 * PENDING     - Task created but not yet started
 * ASSIGNED    - Volunteer has been assigned
 * IN_PROGRESS - Volunteer is actively working on the task
 * COMPLETED   - Task has been completed successfully
 * CANCELLED   - Task was cancelled
 */
public enum TaskStatus {
    PENDING,
    ASSIGNED,
    IN_PROGRESS,
    COMPLETED,
    CANCELLED;

    public String getCssClass() {
        return name().toLowerCase(Locale.ROOT);
    }
}
