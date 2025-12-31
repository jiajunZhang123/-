package com.shop.controller;

import com.shop.entity.Product;
import com.shop.service.ProductService;
import com.shop.service.UserLogService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class ProductController extends BaseController {
    
    @Autowired
    private ProductService productService;
    
    @Autowired
    private UserLogService userLogService;
    
    @GetMapping({"/", "/products"})
    public String products(@RequestParam(required = false) String search,
                          @RequestParam(defaultValue = "1") int page,
                          HttpSession session,
                          HttpServletRequest request,
                          Model model) {
        List<Product> products;
        
        if (search != null && !search.trim().isEmpty()) {
            products = productService.searchProducts(search);
            model.addAttribute("search", search);
        } else {
            Page<Product> productPage = productService.getOnlineProducts(page, 12);
            products = productPage.getContent();
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", productPage.getTotalPages());
        }
        
        // 记录浏览日志
        if (isLoggedIn(session)) {
            Integer userId = getUserId(session);
            String ip = getClientIP(request);
            for (Product product : products) {
                userLogService.logUserAction(userId, product.getId(), "view", ip);
            }
        }
        
        model.addAttribute("products", products);
        model.addAttribute("title", "商品列表");
        return "products";
    }
    
    @GetMapping("/product/{id}")
    public String productDetail(@PathVariable Integer id,
                               HttpSession session,
                               HttpServletRequest request,
                               Model model) {
        Product product = productService.getProductById(id)
                .orElse(null);
        
        if (product == null || product.getStatus() != 1) {
            addMessage(model, "error", "商品不存在或已下架");
            return "redirect:/products";
        }
        
        // 记录浏览日志
        if (isLoggedIn(session)) {
            Integer userId = getUserId(session);
            String ip = getClientIP(request);
            userLogService.logUserAction(userId, id, "view", ip);
        }
        
        model.addAttribute("product", product);
        model.addAttribute("title", product.getName());
        return "product_detail";
    }
}

