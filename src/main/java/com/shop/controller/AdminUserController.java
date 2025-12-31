package com.shop.controller;

import com.shop.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController extends BaseController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("")
    public String users(HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        model.addAttribute("users", userService.getAllUsers());
        return "admin/users";
    }
    
    @GetMapping("/toggle/{id}")
    public String toggleStatus(@PathVariable Integer id,
                               @RequestParam Integer status,
                               HttpSession session) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        userService.updateUserStatus(id, status);
        return "redirect:/admin/users";
    }
}

