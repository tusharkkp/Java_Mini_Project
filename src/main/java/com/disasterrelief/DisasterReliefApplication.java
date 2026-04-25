package com.disasterrelief;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Main entry point for the Disaster Relief Volunteer Coordination System.
 * 
 * This enterprise application provides:
 * - SOS emergency request management
 * - Real-time volunteer notification via socket programming
 * - Task assignment and tracking
 * - Admin dashboard with SDG metrics
 * 
 * @EnableAsync    - Enables asynchronous method execution (multithreading)
 * @EnableScheduling - Enables scheduled task execution (multithreading)
 */
@SpringBootApplication
@EnableAsync
@EnableScheduling
public class DisasterReliefApplication {

	public static void main(String[] args) {
		SpringApplication.run(DisasterReliefApplication.class, args);
		System.out.println("==============================================");
		System.out.println(" Disaster Relief Coordination System Started ");
		System.out.println(" URL: http://localhost:8081                   ");
		System.out.println(" Socket Server: port 9090                    ");
		System.out.println("==============================================");
	}

}
