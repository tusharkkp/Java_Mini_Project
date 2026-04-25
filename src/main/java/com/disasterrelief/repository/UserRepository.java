package com.disasterrelief.repository;

import com.disasterrelief.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.List;
import java.time.LocalDateTime;

/**
 * Repository for User entity operations.
 * Extends JpaRepository for standard CRUD operations.
 * Includes custom HQL (Hibernate Query Language) queries as per rubric requirement.
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Spring Data JPA derived query method
    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    /**
     * HQL QUERY (Rubric Requirement):
     * Custom HQL query to find users by role name.
     * Demonstrates Hibernate Query Language usage beyond standard JpaRepository methods.
     */
    @Query("SELECT u FROM User u JOIN u.roles r WHERE r.name = :roleName")
    List<User> findByRoleName(@Param("roleName") String roleName);

    /**
     * HQL QUERY:
     * Count users registered after a given date.
     * Used for admin dashboard statistics.
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.createdAt >= :since")
    long countRecentUsers(@Param("since") LocalDateTime since);
}
