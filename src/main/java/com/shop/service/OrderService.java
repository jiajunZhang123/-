package com.shop.service;

import com.shop.entity.*;
import com.shop.repository.*;
import com.shop.util.OrderUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class OrderService {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private OrderItemRepository orderItemRepository;
    
    @Autowired
    private CartRepository cartRepository;
    
    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private UserLogRepository userLogRepository;
    
    @Transactional
    public Order createOrderFromCart(Integer userId) {
        List<Cart> carts = cartRepository.findByUserIdOrderByCreatedAtDesc(userId);
        if (carts.isEmpty()) {
            throw new RuntimeException("购物车为空");
        }
        
        // 先计算总金额并验证
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Cart cart : carts) {
            Product product = productRepository.findById(cart.getProductId())
                    .orElseThrow(() -> new RuntimeException("商品不存在"));
            
            if (product.getStatus() != 1) {
                throw new RuntimeException("商品 " + product.getName() + " 已下架");
            }
            
            if (product.getStock() < cart.getQuantity()) {
                throw new RuntimeException("商品 " + product.getName() + " 库存不足");
            }
            
            totalAmount = totalAmount.add(product.getPrice().multiply(new BigDecimal(cart.getQuantity())));
        }
        
        // 创建订单
        Order order = new Order();
        order.setOrderNo(OrderUtil.generateOrderNo());
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setStatus(1); // 已支付（模拟支付）
        order = orderRepository.save(order);
        
        // 保存订单明细并减少库存
        for (Cart cart : carts) {
            Product product = productRepository.findById(cart.getProductId())
                    .orElseThrow(() -> new RuntimeException("商品不存在"));
            
            OrderItem item = new OrderItem();
            item.setOrderId(order.getId());
            item.setProductId(product.getId());
            item.setProductName(product.getName());
            item.setProductPrice(product.getPrice());
            item.setQuantity(cart.getQuantity());
            item.setSubtotal(product.getPrice().multiply(new BigDecimal(cart.getQuantity())));
            orderItemRepository.save(item);
            
            // 减少库存
            product.setStock(product.getStock() - cart.getQuantity());
            productRepository.save(product);
            
            // 记录购买日志
            UserLog log = new UserLog();
            log.setUserId(userId);
            log.setProductId(product.getId());
            log.setActionType("purchase");
            userLogRepository.save(log);
        }
        
        // 清空购物车
        cartRepository.deleteByUserId(userId);
        
        return order;
    }
    
    public List<Order> getOrdersByUserId(Integer userId) {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }
    
    public Optional<Order> getOrderById(Integer id) {
        return orderRepository.findById(id);
    }
    
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }
    
    @Transactional
    public Order updateOrderStatus(Integer orderId, Integer status) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("订单不存在"));
        order.setStatus(status);
        return orderRepository.save(order);
    }
}

