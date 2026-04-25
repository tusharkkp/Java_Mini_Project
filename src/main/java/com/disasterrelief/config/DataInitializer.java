package com.disasterrelief.config;

import com.disasterrelief.entity.Location;
import com.disasterrelief.entity.Role;
import com.disasterrelief.repository.LocationRepository;
import com.disasterrelief.repository.RoleRepository;
import com.disasterrelief.repository.JdbcSosLogRepository;
import com.disasterrelief.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Data Initializer — runs on application startup.
 * Seeds the database with initial roles, admin user, and sample locations.
 */
@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private LocationRepository locationRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private JdbcSosLogRepository jdbcSosLogRepository;

    @Override
    public void run(String... args) throws Exception {
        // Create roles if they don't exist
        createRoleIfNotExists("ROLE_ADMIN");
        createRoleIfNotExists("ROLE_VOLUNTEER");
        createRoleIfNotExists("ROLE_USER");

        // Create JDBC audit table
        jdbcSosLogRepository.createAuditTableIfNotExists();

        // Create default admin user
        try {
            userService.registerUser("admin", "admin123", "admin@disasterrelief.com",
                    "System Administrator", "9999999999", "ROLE_ADMIN");
            System.out.println("[INIT] Default admin user created (admin/admin123)");
        } catch (RuntimeException e) {
            System.out.println("[INIT] Admin user already exists");
        }

        // Create sample volunteer user
        try {
            userService.registerUser("volunteer1", "vol123", "vol1@disasterrelief.com",
                    "John Volunteer", "8888888888", "ROLE_VOLUNTEER");
            System.out.println("[INIT] Sample volunteer created (volunteer1/vol123)");
        } catch (RuntimeException e) {
            System.out.println("[INIT] Sample volunteer already exists");
        }

        // Create sample regular user
        try {
            userService.registerUser("user1", "user123", "user1@disasterrelief.com",
                    "Jane User", "7777777777", "ROLE_USER");
            System.out.println("[INIT] Sample user created (user1/user123)");
        } catch (RuntimeException e) {
            System.out.println("[INIT] Sample user already exists");
        }

        // Seed sample locations
        if (locationRepository.count() == 0) {
            locationRepository.save(new Location("City Center", 18.5204, 73.8567, "URBAN"));
            locationRepository.save(new Location("Industrial Area", 18.5504, 73.9067, "SUBURBAN"));
            locationRepository.save(new Location("Riverside Area", 18.4904, 73.8267, "RURAL"));
            locationRepository.save(new Location("Coastal Zone", 18.4604, 73.7967, "COASTAL"));
            locationRepository.save(new Location("Hospital District", 18.5104, 73.8467, "URBAN"));
            System.out.println("[INIT] Sample locations seeded");
        }

        System.out.println("[INIT] Data initialization complete");
    }

    private void createRoleIfNotExists(String roleName) {
        if (!roleRepository.existsByName(roleName)) {
            roleRepository.save(new Role(roleName));
            System.out.println("[INIT] Created role: " + roleName);
        }
    }
}
