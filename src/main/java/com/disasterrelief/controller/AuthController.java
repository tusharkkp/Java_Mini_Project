package com.disasterrelief.controller;

import com.disasterrelief.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Authentication Controller — handles login and registration pages.
 * Uses Spring MVC @Controller for JSP view rendering.
 */
@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    /**
     * Display the login page.
     */
    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error,
                           @RequestParam(value = "logout", required = false) String logout,
                           Model model) {
        if (error != null) {
            model.addAttribute("error", "Invalid username or password");
        }
        if (logout != null) {
            model.addAttribute("message", "You have been logged out successfully");
        }
        return "login";
    }

    /**
     * Display the registration page.
     */
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    /**
     * Process registration form submission.
     */
    @PostMapping("/register")
    public String processRegistration(@RequestParam String username,
                                      @RequestParam String password,
                                      @RequestParam String email,
                                      @RequestParam String fullName,
                                      @RequestParam(required = false) String phone,
                                      @RequestParam String role,
                                      RedirectAttributes redirectAttributes) {
        try {
            userService.registerUser(username, password, email, fullName, phone, role);
            redirectAttributes.addFlashAttribute("message", "Registration successful! Please login.");
            return "redirect:/login";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/register";
        }
    }

    /**
     * Root URL redirects to login page.
     */
    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }
}
