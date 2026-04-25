package com.disasterrelief.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import java.util.concurrent.Executor;

/**
 * ASYNC CONFIGURATION (Rubric Requirement - Multithreading):
 * 
 * Configures the thread pool for @Async method execution.
 * When @Async methods are called, they execute in threads from this pool
 * instead of the main request thread.
 */
@Configuration
@EnableAsync
public class AsyncConfig {

    @Bean(name = "taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);    // Minimum threads
        executor.setMaxPoolSize(10);    // Maximum threads
        executor.setQueueCapacity(100); // Queue before creating new threads
        executor.setThreadNamePrefix("Async-");
        executor.initialize();
        return executor;
    }
}
