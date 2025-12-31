package com.shop.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.ui.Model;

public class BaseController {
    
    protected Integer getUserId(HttpSession session) {
        return (Integer) session.getAttribute("userId");
    }
    
    protected String getUsername(HttpSession session) {
        return (String) session.getAttribute("username");
    }
    
    protected boolean isLoggedIn(HttpSession session) {
        return getUserId(session) != null;
    }
    
    protected boolean isAdminLoggedIn(HttpSession session) {
        return session.getAttribute("adminId") != null;
    }
    
    protected String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
    
    protected void addMessage(Model model, String type, String message) {
        model.addAttribute("messageType", type);
        model.addAttribute("message", message);
    }
}

