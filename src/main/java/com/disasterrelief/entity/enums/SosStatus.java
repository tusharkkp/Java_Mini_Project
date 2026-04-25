package com.disasterrelief.entity.enums;

import java.util.Locale;

/**
 * Status tracking for SOS emergency requests.
 * Represents the lifecycle of an SOS from creation to resolution.
 * 
 * NEW        - Just created, not yet processed
 * ACTIVE     - Being actively responded to
 * ASSIGNED   - Volunteer(s) assigned to the SOS
 * RESOLVED   - Emergency has been resolved
 * ESCALATED  - Automatically escalated due to no response within threshold
 */
public enum SosStatus {
    NEW,
    ACTIVE,
    ASSIGNED,
    RESOLVED,
    ESCALATED;

    public String getCssClass() {
        return name().toLowerCase(Locale.ROOT);
    }
}
