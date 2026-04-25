package com.disasterrelief.controller;

import com.disasterrelief.entity.*;
import com.disasterrelief.service.*;
import com.disasterrelief.socket.SosAlertSocketServer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.List;
import java.util.Map;

/**
 * Admin Controller — handles admin dashboard and management pages.
 * Restricted to users with ROLE_ADMIN.
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private UserService userService;
    @Autowired private SosRequestService sosRequestService;
    @Autowired private VolunteerService volunteerService;
    @Autowired private TaskService taskService;
    @Autowired private SdgMetricsService sdgMetricsService;
    @Autowired private SosAlertSocketServer socketServer;
    @Autowired private NotificationService notificationService;

    /** Admin dashboard — overview with metrics and charts */
    @GetMapping("/dashboard")
    public String dashboard(Authentication auth, Model model) {
        User user = userService.findByUsername(auth.getName()).orElseThrow();
        Map<String, Object> metrics = sdgMetricsService.calculateMetrics();

        model.addAttribute("user", user);
        model.addAttribute("metrics", metrics);
        model.addAttribute("recentSos", sosRequestService.findAll());
        model.addAttribute("connectedClients", socketServer.getConnectedClientCount());
        model.addAttribute("socketRunning", socketServer.isRunning());
        model.addAttribute("socketPort", socketServer.getPort());
        model.addAttribute("unreadCount", notificationService.getUnreadCount(user.getId()));
        return "admin/dashboard";
    }

    /** View all SOS requests */
    @GetMapping("/sos")
    public String allSos(Model model, Authentication auth) {
        model.addAttribute("sosRequests", sosRequestService.findAll());
        model.addAttribute("user", userService.findByUsername(auth.getName()).orElseThrow());
        return "admin/sos-list";
    }

    /** View SOS detail and assign volunteers */
    @GetMapping("/sos/{id}")
    public String sosDetail(@PathVariable Long id, Model model, Authentication auth) {
        SosRequest sos = sosRequestService.findById(id).orElseThrow();
        List<Volunteer> available = volunteerService.findNearestAvailableVolunteers(
                sos.getLatitude(), sos.getLongitude(), 10);
        List<Task> tasks = taskService.findBySosRequestId(id);

        model.addAttribute("sos", sos);
        model.addAttribute("availableVolunteers", available);
        model.addAttribute("tasks", tasks);
        model.addAttribute("user", userService.findByUsername(auth.getName()).orElseThrow());
        return "admin/sos-detail";
    }

    /** Assign a volunteer to an SOS */
    @PostMapping("/sos/{sosId}/assign")
    public String assignVolunteer(@PathVariable Long sosId,
                                  @RequestParam Long volunteerId,
                                  Authentication auth, RedirectAttributes ra) {
        try {
            taskService.assignVolunteer(sosId, volunteerId, auth.getName());
            ra.addFlashAttribute("message", "Volunteer assigned successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Assignment failed: " + e.getMessage());
        }
        return "redirect:/admin/sos/" + sosId;
    }

    /** View all volunteers */
    @GetMapping("/volunteers")
    public String volunteers(Model model, Authentication auth) {
        model.addAttribute("volunteers", volunteerService.findAll());
        model.addAttribute("user", userService.findByUsername(auth.getName()).orElseThrow());
        return "admin/volunteers";
    }

    /** SDG Metrics page */
    @GetMapping("/sdg-metrics")
    public String sdgMetrics(Model model, Authentication auth) {
        Map<String, Object> metrics = sdgMetricsService.calculateMetrics();
        model.addAttribute("metrics", metrics);
        model.addAttribute("user", userService.findByUsername(auth.getName()).orElseThrow());
        return "admin/sdg-metrics";
    }

    /** View all users */
    @GetMapping("/users")
    public String users(Model model, Authentication auth) {
        model.addAttribute("allUsers", userService.findAll());
        model.addAttribute("user", userService.findByUsername(auth.getName()).orElseThrow());
        return "admin/users";
    }
}
