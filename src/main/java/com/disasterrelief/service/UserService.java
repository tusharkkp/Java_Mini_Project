package com.disasterrelief.service;

import com.disasterrelief.entity.Role;
import com.disasterrelief.entity.User;
import com.disasterrelief.entity.Volunteer;
import com.disasterrelief.repository.RoleRepository;
import com.disasterrelief.repository.UserRepository;
import com.disasterrelief.repository.VolunteerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * Service layer for User management operations.
 * Handles user registration, role assignment, and profile management.
 */
@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private VolunteerRepository volunteerRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Register a new user with the specified role.
     * If registering as a volunteer, also creates a Volunteer profile.
     */
    @Transactional
    public User registerUser(String username, String password, String email,
                             String fullName, String phone, String roleName) {
        // Check for existing username/email
        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("Username already exists: " + username);
        }
        if (userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already exists: " + email);
        }

        // Create user with encoded password (BCrypt)
        User user = new User();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setEmail(email);
        user.setFullName(fullName);
        user.setPhone(phone);

        // Assign role
        Role role = roleRepository.findByName(roleName)
                .orElseThrow(() -> new RuntimeException("Role not found: " + roleName));
        Set<Role> roles = new HashSet<>();
        roles.add(role);
        user.setRoles(roles);

        User savedUser = userRepository.save(user);

        // If registering as volunteer, create volunteer profile
        if ("ROLE_VOLUNTEER".equals(roleName)) {
            Volunteer volunteer = new Volunteer();
            volunteer.setUser(savedUser);
            volunteer.setAvailable(true);
            volunteer.setLatitude(0.0);
            volunteer.setLongitude(0.0);
            volunteerRepository.save(volunteer);
        }

        return savedUser;
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public List<User> findByRoleName(String roleName) {
        return userRepository.findByRoleName(roleName);
    }

    public long getUserCount() {
        return userRepository.count();
    }
}
