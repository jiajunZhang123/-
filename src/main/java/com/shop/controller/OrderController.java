package com.shop.controller;

import com.shop.entity.Order;
import com.shop.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class OrderController extends BaseController {
    
    @Autowired
    private OrderService orderService;
    
    @GetMapping("/checkout")
    public String checkout(HttpSession session, Model model) {
        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        
        // 从购物车获取商品
        model.addAttribute("title", "订单结算");
        return "checkout";
    }
    
    @PostMapping("/checkout")
    public String createOrder(HttpSession session, Model model) {
        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        
        try {
            Integer userId = getUserId(session);
            Order order = orderService.createOrderFromCart(userId);
            return "redirect:/order/" + order.getId();
        } catch (RuntimeException e) {
            addMessage(model, "error", e.getMessage());
            return "redirect:/cart";
        }
    }
    
    @GetMapping("/orders")
    public String orders(HttpSession session, Model model) {
        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        
        Integer userId = getUserId(session);
        List<Order> orders = orderService.getOrdersByUserId(userId);
        model.addAttribute("orders", orders);
        return "orders";
    }
    
    @GetMapping("/order/{id}")
    public String orderDetail(@PathVariable Integer id,
                             HttpSession session,
                             Model model) {
        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        
        Order order = orderService.getOrderById(id)
                .orElse(null);
        
        if (order == null || !order.getUserId().equals(getUserId(session))) {
            addMessage(model, "error", "订单不存在");
            return "redirect:/orders";
        }
        
        model.addAttribute("order", order);
        model.addAttribute("title", "订单详情");
        return "order_detail";
    }
}

