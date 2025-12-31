package com.shop.controller;

import com.shop.service.UserLogService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/admin/logs")
public class AdminLogController extends BaseController {
    
    @Autowired
    private UserLogService userLogService;
    
    @GetMapping("")
    public String logs(@RequestParam(required = false) String actionType,
                      HttpSession session,
                      Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        if (actionType != null && !actionType.isEmpty()) {
            model.addAttribute("logs", userLogService.getLogsByActionType(actionType));
            model.addAttribute("actionType", actionType);
        } else {
            model.addAttribute("logs", userLogService.getAllLogs());
        }
        
        return "admin/logs";
    }
}

