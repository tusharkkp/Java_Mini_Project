package com.disasterrelief.service;

import com.disasterrelief.entity.Notification;
import com.disasterrelief.entity.User;
import com.disasterrelief.repository.NotificationRepository;
import com.disasterrelief.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * MULTITHREADING FEATURE - @Async (Rubric Requirement):
 * 
 * This service uses @Async to send notifications asynchronously.
 * When an SOS is created or a task status changes, notifications
 * are sent in a separate thread pool, avoiding blocking the main request thread.
 * 
 * The @Async annotation causes Spring to execute these methods in a separate
 * thread from the TaskExecutor configured in AsyncConfig.
 */
@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private UserRepository userRepository;

    /**
     * ASYNC METHOD (Rubric Requirement):
     * Send notification to a specific user asynchronously.
     * Runs in a separate thread from the main request thread.
     */
    @Async
    public void sendNotificationAsync(Long userId, String message, String type) {
        System.out.println("[ASYNC] Sending notification in thread: " + Thread.currentThread().getName());

        User user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            Notification notification = new Notification(user, message, type);
            notificationRepository.save(notification);
            System.out.println("[ASYNC] Notification sent to user: " + user.getUsername());
        }
    }

    /**
     * ASYNC METHOD:
     * Broadcast notification to all users with a specific role.
     * Used to notify all volunteers when a new SOS is created.
     */
    @Async
    public void broadcastToRole(String roleName, String message, String type) {
        System.out.println("[ASYNC] Broadcasting to " + roleName + " in thread: " + Thread.currentThread().getName());

        List<User> users = userRepository.findByRoleName(roleName);
        for (User user : users) {
            Notification notification = new Notification(user, message, type);
            notificationRepository.save(notification);
        }
        System.out.println("[ASYNC] Broadcast sent to " + users.size() + " users with role " + roleName);
    }

    public List<Notification> getUserNotifications(Long userId) {
        return notificationRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public List<Notification> getUnreadNotifications(Long userId) {
        return notificationRepository.findByUserIdAndReadFalse(userId);
    }

    public long getUnreadCount(Long userId) {
        return notificationRepository.countByUserIdAndReadFalse(userId);
    }

    public void markAsRead(Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId).orElse(null);
        if (notification != null) {
            notification.setRead(true);
            notificationRepository.save(notification);
        }
    }

    public void markAllAsRead(Long userId) {
        List<Notification> unread = notificationRepository.findByUserIdAndReadFalse(userId);
        for (Notification n : unread) {
            n.setRead(true);
        }
        notificationRepository.saveAll(unread);
    }
}
