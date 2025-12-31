package com.shop.controller;

import com.shop.entity.Order;
import com.shop.entity.OrderItem;
import com.shop.repository.OrderRepository;
import com.shop.repository.OrderItemRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/statistics")
public class AdminStatisticsController extends BaseController {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private OrderItemRepository orderItemRepository;
    
    @GetMapping("")
    public String statistics(HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        // 获取所有已支付的订单
        List<Order> allOrders = orderRepository.findAll();
        List<Order> paidOrders = allOrders.stream()
                .filter(order -> order.getStatus() >= 1) // 已支付及以上
                .collect(Collectors.toList());
        
        // 按日期分组统计（最近30天）
        LocalDate thirtyDaysAgo = LocalDate.now().minusDays(30);
        Map<String, BigDecimal> dailySales = new LinkedHashMap<>();
        
        paidOrders.stream()
                .filter(order -> order.getCreatedAt().toLocalDate().isAfter(thirtyDaysAgo.minusDays(1)))
                .forEach(order -> {
                    String date = order.getCreatedAt().toLocalDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    dailySales.merge(date, order.getTotalAmount(), BigDecimal::add);
                });
        
        // 按日期排序
        List<Map.Entry<String, BigDecimal>> sortedDailySales = dailySales.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByKey().reversed())
                .collect(Collectors.toList());
        
        model.addAttribute("dailySales", sortedDailySales);
        
        // 商品销量排行（Top 10）
        List<OrderItem> allOrderItems = orderItemRepository.findAll();
        Map<String, Map<String, Object>> productStats = new HashMap<>();
        
        for (OrderItem item : allOrderItems) {
            String productName = item.getProductName();
            Map<String, Object> stats = productStats.getOrDefault(productName, new HashMap<>());
            int quantity = (Integer) stats.getOrDefault("quantity", 0);
            BigDecimal amount = (BigDecimal) stats.getOrDefault("amount", BigDecimal.ZERO);
            stats.put("quantity", quantity + item.getQuantity());
            stats.put("amount", amount.add(item.getSubtotal()));
            productStats.put(productName, stats);
        }
        
        // 排序并取Top 10
        List<Map<String, Object>> productRanking = productStats.entrySet().stream()
                .sorted((e1, e2) -> {
                    int qty1 = (Integer) e1.getValue().get("quantity");
                    int qty2 = (Integer) e2.getValue().get("quantity");
                    return Integer.compare(qty2, qty1); // 按销量降序
                })
                .limit(10)
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>(entry.getValue());
                    map.put("name", entry.getKey());
                    return map;
                })
                .collect(Collectors.toList());
        
        model.addAttribute("productRanking", productRanking);
        
        return "admin/statistics";
    }
}
