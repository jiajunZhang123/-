package com.shop.controller;

import com.shop.entity.Admin;
import com.shop.repository.AdminRepository;
import com.shop.service.*;
import com.shop.util.PasswordUtil;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController extends BaseController {
    
    @Autowired
    private AdminRepository adminRepository;
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private UserService userService;
    
    
    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        if (isAdminLoggedIn(session)) {
            return "redirect:/admin";
        }
        return "admin/login";
    }
    
    @PostMapping("/login")
    public String login(@RequestParam String username,
                       @RequestParam String password,
                       HttpSession session,
                       Model model) {
        Optional<Admin> adminOpt = adminRepository.findByUsername(username);
        
        if (adminOpt.isEmpty() || !PasswordUtil.matches(password, adminOpt.get().getPassword())) {
            addMessage(model, "error", "用户名或密码错误");
            return "admin/login";
        }
        
        Admin admin = adminOpt.get();
        session.setAttribute("adminId", admin.getId());
        session.setAttribute("adminUsername", admin.getUsername());
        
        return "redirect:/admin";
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("adminId");
        session.removeAttribute("adminUsername");
        return "redirect:/admin/login";
    }
    
    @GetMapping("")
    public String index(HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        // 统计数据
        model.addAttribute("totalUsers", userService.getAllUsers().size());
        model.addAttribute("totalProducts", productService.getAllProducts().size());
        model.addAttribute("totalOrders", orderService.getAllOrders().size());
        
        return "admin/index";
    }
}

