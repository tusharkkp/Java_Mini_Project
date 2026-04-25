package com.disasterrelief.entity;

import jakarta.persistence.*;

/**
 * Role entity - represents user roles for Spring Security authorization.
 * 
 * Roles follow Spring Security naming convention (ROLE_ prefix):
 * - ROLE_ADMIN     : Full system access, dashboard, user management
 * - ROLE_VOLUNTEER : Can accept tasks, update status, view assignments
 * - ROLE_USER      : Can create SOS requests, view own history
 * 
 * Table: roles
 */
@Entity
@Table(name = "roles")
public class Role {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String name;

    // --- Constructors ---
    public Role() {}

    public Role(String name) {
        this.name = name;
    }

    // --- Getters and Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    @Override
    public String toString() {
        return name;
    }
}
