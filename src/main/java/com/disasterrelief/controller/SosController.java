package com.disasterrelief.controller;

import com.disasterrelief.entity.SosRequest;
import com.disasterrelief.entity.User;
import com.disasterrelief.entity.enums.SeverityLevel;
import com.disasterrelief.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;

/**
 * User Dashboard & SOS Controller — handles user-facing pages.
 * Restricted to users with ROLE_USER.
 */
@Controller
@RequestMapping("/user")
public class SosController {

    @Autowired private UserService userService;
    @Autowired private SosRequestService sosRequestService;
    @Autowired private NotificationService notificationService;

    /** User dashboard — shows SOS history and stats */
    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        List<SosRequest> myRequests = sosRequestService.findByUserId(user.getId());
        long unreadCount = notificationService.getUnreadCount(user.getId());

        model.addAttribute("user", user);
        model.addAttribute("sosRequests", myRequests);
        model.addAttribute("unreadCount", unreadCount);
        return "user/dashboard";
    }

    /** Display SOS creation form */
    @GetMapping("/sos/create")
    public String sosForm(Authentication auth, Model model) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        model.addAttribute("user", user);
        model.addAttribute("severityLevels", SeverityLevel.values());
        return "user/sos-form";
    }

    /** Process SOS form submission */
    @PostMapping("/sos/create")
    public String createSos(@RequestParam Double latitude,
                           @RequestParam Double longitude,
                           @RequestParam String locationName,
                           @RequestParam String description,
                           @RequestParam String severity,
                           Authentication auth,
                           RedirectAttributes redirectAttributes) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        try {
            SeverityLevel level = SeverityLevel.valueOf(severity);
            sosRequestService.createSosRequest(user, latitude, longitude, locationName, description, level);
            redirectAttributes.addFlashAttribute("message", "SOS request created successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to create SOS: " + e.getMessage());
        }
        return "redirect:/user/dashboard";
    }

    /** View notifications */
    @GetMapping("/notifications")
    public String notifications(Authentication auth, Model model) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        model.addAttribute("notifications", notificationService.getUserNotifications(user.getId()));
        model.addAttribute("user", user);
        return "user/notifications";
    }

    /** Mark all notifications as read */
    @PostMapping("/notifications/read-all")
    public String markAllRead(Authentication auth) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        notificationService.markAllAsRead(user.getId());
        return "redirect:/user/notifications";
    }
}
