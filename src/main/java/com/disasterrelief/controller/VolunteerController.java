package com.disasterrelief.controller;

import com.disasterrelief.entity.*;
import com.disasterrelief.entity.enums.TaskStatus;
import com.disasterrelief.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

/**
 * Volunteer Controller — handles volunteer-facing pages.
 * Restricted to users with ROLE_VOLUNTEER.
 */
@Controller
@RequestMapping("/volunteer")
public class VolunteerController {

    @Autowired private UserService userService;
    @Autowired private VolunteerService volunteerService;
    @Autowired private TaskService taskService;
    @Autowired private NotificationService notificationService;

    /** Volunteer dashboard — shows assigned tasks and availability */
    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        Volunteer volunteer = volunteerService.findByUserId(user.getId()).orElse(null);

        if (volunteer != null) {
            List<Task> tasks = taskService.findByVolunteerId(volunteer.getId());
            model.addAttribute("tasks", tasks);
            model.addAttribute("volunteer", volunteer);
        }

        long unreadCount = notificationService.getUnreadCount(user.getId());
        model.addAttribute("user", user);
        model.addAttribute("unreadCount", unreadCount);
        return "volunteer/dashboard";
    }

    /** View volunteer's assigned tasks */
    @GetMapping("/tasks")
    public String tasks(Authentication auth, Model model) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        Volunteer volunteer = volunteerService.findByUserId(user.getId()).orElse(null);

        if (volunteer != null) {
            model.addAttribute("tasks", taskService.findByVolunteerId(volunteer.getId()));
            model.addAttribute("volunteer", volunteer);
        }
        model.addAttribute("user", user);
        return "volunteer/tasks";
    }

    /** Toggle availability status */
    @PostMapping("/toggle-availability")
    public String toggleAvailability(Authentication auth, RedirectAttributes ra) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        Volunteer volunteer = volunteerService.findByUserId(user.getId()).orElse(null);
        if (volunteer != null) {
            volunteerService.toggleAvailability(volunteer.getId());
            ra.addFlashAttribute("message", "Availability updated!");
        }
        return "redirect:/volunteer/dashboard";
    }

    /** Update volunteer location */
    @PostMapping("/update-location")
    public String updateLocation(@RequestParam Double latitude,
                                 @RequestParam Double longitude,
                                 Authentication auth, RedirectAttributes ra) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        Volunteer volunteer = volunteerService.findByUserId(user.getId()).orElse(null);
        if (volunteer != null) {
            volunteerService.updateLocation(volunteer.getId(), latitude, longitude);
            ra.addFlashAttribute("message", "Location updated!");
        }
        return "redirect:/volunteer/dashboard";
    }

    /** Update task status */
    @PostMapping("/task/{taskId}/update")
    public String updateTaskStatus(@PathVariable Long taskId,
                                   @RequestParam String status,
                                   Authentication auth, RedirectAttributes ra) {
        try {
            TaskStatus newStatus = TaskStatus.valueOf(status);
            taskService.updateTaskStatus(taskId, newStatus, auth.getName());
            ra.addFlashAttribute("message", "Task status updated!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Failed to update: " + e.getMessage());
        }
        return "redirect:/volunteer/tasks";
    }

    /** View notifications */
    @GetMapping("/notifications")
    public String notifications(Authentication auth, Model model) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        model.addAttribute("notifications", notificationService.getUserNotifications(user.getId()));
        model.addAttribute("user", user);
        return "volunteer/notifications";
    }
}
