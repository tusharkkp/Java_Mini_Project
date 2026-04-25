package com.disasterrelief.repository;

import com.disasterrelief.entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Repository for Location entity operations.
 */
@Repository
public interface LocationRepository extends JpaRepository<Location, Long> {
    List<Location> findByAreaType(String areaType);
    List<Location> findByNameContainingIgnoreCase(String name);
}
