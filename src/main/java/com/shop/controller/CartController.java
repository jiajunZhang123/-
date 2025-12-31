package com.shop.controller;

import com.shop.service.CartService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
public class CartController extends BaseController {
    
    @Autowired
    private CartService cartService;
    
    @GetMapping("/cart")
    public String cart(HttpSession session, Model model) {
        if (!isLoggedIn(session)) {
            return "redirect:/login";
        }
        
        Integer userId = getUserId(session);
        var cartItems = cartService.getCartByUserId(userId);
        // 需要加载商品信息
        model.addAttribute("cartItems", cartItems);
        return "cart";
    }
    
    @PostMapping("/api/cart/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addToCart(@RequestParam Integer productId,
                                                         @RequestParam(defaultValue = "1") Integer quantity,
                                                         HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        if (!isLoggedIn(session)) {
            result.put("success", false);
            result.put("message", "请先登录");
            return ResponseEntity.ok(result);
        }
        
        try {
            Integer userId = getUserId(session);
            cartService.addToCart(userId, productId, quantity);
            result.put("success", true);
            result.put("message", "已添加到购物车");
        } catch (RuntimeException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        
        return ResponseEntity.ok(result);
    }
    
    @PostMapping("/api/cart/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateCart(@RequestParam Integer cartId,
                                                          @RequestParam Integer quantity,
                                                          HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            cartService.updateCartQuantity(cartId, quantity);
            result.put("success", true);
            result.put("message", "更新成功");
        } catch (RuntimeException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        
        return ResponseEntity.ok(result);
    }
    
    @PostMapping("/api/cart/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteCart(@RequestParam Integer cartId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            cartService.deleteCartItem(cartId);
            result.put("success", true);
            result.put("message", "删除成功");
        } catch (RuntimeException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        
        return ResponseEntity.ok(result);
    }
}

