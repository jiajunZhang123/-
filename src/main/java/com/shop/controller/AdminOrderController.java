package com.shop.controller;

import com.shop.entity.Order;
import com.shop.entity.OrderItem;
import com.shop.repository.OrderItemRepository;
import com.shop.repository.UserRepository;
import com.shop.service.EmailService;
import com.shop.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/orders")
public class AdminOrderController extends BaseController {
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private EmailService emailService;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private OrderItemRepository orderItemRepository;
    
    @GetMapping("")
    public String orders(HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        List<Order> orders = orderService.getAllOrders();
        model.addAttribute("orders", orders);
        return "admin/orders";
    }
    
    @GetMapping("/{id}")
    public String orderDetail(@PathVariable Integer id, HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        orderService.getOrderById(id).ifPresent(order -> {
            model.addAttribute("order", order);
            List<OrderItem> orderItems = orderItemRepository.findByOrderId(id);
            model.addAttribute("orderItems", orderItems);
        });
        return "admin/order_detail";
    }
    
    @PostMapping("/update-status")
    public String updateStatus(@RequestParam Integer orderId,
                              @RequestParam Integer status,
                              HttpSession session) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        Order order = orderService.updateOrderStatus(orderId, status);
        
        // 如果订单状态更新为已完成（status=3），发送邮件通知用户
        if (status == 3) {
            userRepository.findById(order.getUserId()).ifPresent(user -> {
                if (user.getEmail() != null && !user.getEmail().isEmpty()) {
                    String totalAmount = order.getTotalAmount().toString();
                    emailService.sendOrderCompletedEmail(
                        user.getEmail(),
                        order.getOrderNo(),
                        totalAmount
                    );
                }
            });
        }
        
        return "redirect:/admin/orders";
    }
}

