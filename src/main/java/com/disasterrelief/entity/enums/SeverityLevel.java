package com.disasterrelief.entity.enums;

import java.util.Locale;

/**
 * Severity levels for SOS emergency requests.
 * Used to prioritize response and resource allocation.
 * 
 * LOW     - Minor assistance needed (e.g., supplies)
 * MEDIUM  - Moderate emergency (e.g., minor injury)
 * HIGH    - Serious emergency (e.g., trapped person)
 * CRITICAL - Life-threatening situation requiring immediate response
 */
public enum SeverityLevel {
    LOW,
    MEDIUM,
    HIGH,
    CRITICAL;

    public String getCssClass() {
        return name().toLowerCase(Locale.ROOT);
    }
}
