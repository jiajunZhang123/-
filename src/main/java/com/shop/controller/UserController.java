package com.shop.controller;

import com.shop.entity.User;
import com.shop.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class UserController extends BaseController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("title", "用户注册");
        return "register";
    }
    
    @PostMapping("/register")
    public String register(@RequestParam String username,
                          @RequestParam String email,
                          @RequestParam String password,
                          @RequestParam String confirmPassword,
                          Model model) {
        try {
            if (!password.equals(confirmPassword)) {
                addMessage(model, "error", "两次输入的密码不一致");
                return "register";
            }
            
            userService.register(username, email, password);
            addMessage(model, "success", "注册成功！请登录");
            return "redirect:/login";
        } catch (RuntimeException e) {
            addMessage(model, "error", e.getMessage());
            return "register";
        }
    }
    
    @GetMapping("/login")
    public String loginPage(HttpSession session, Model model) {
        if (isLoggedIn(session)) {
            return "redirect:/products";
        }
        model.addAttribute("title", "用户登录");
        return "login";
    }
    
    @PostMapping("/login")
    public String login(@RequestParam String email,
                       @RequestParam String password,
                       HttpSession session,
                       Model model) {
        try {
            User user = userService.login(email, password);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("email", user.getEmail());
            return "redirect:/products";
        } catch (RuntimeException e) {
            addMessage(model, "error", e.getMessage());
            return "login";
        }
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}

