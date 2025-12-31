package com.shop.controller;

import com.shop.entity.Product;
import com.shop.service.ProductService;
import com.shop.util.FileUploadUtil;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/admin/products")
public class AdminProductController extends BaseController {
    
    @Autowired
    private ProductService productService;
    
    @GetMapping("")
    public String products(HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        model.addAttribute("products", productService.getAllProducts());
        return "admin/products";
    }
    
    @GetMapping("/add")
    public String addPage(HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        return "admin/product_add";
    }
    
    @PostMapping("/add")
    public String add(Product product, 
                     @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                     HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        try {
            // 处理图片上传
            if (imageFile != null && !imageFile.isEmpty()) {
                String imagePath = FileUploadUtil.uploadImage(imageFile);
                product.setImage(imagePath);
            }
            
            productService.saveProduct(product);
            addMessage(model, "success", "商品添加成功");
            return "redirect:/admin/products";
        } catch (Exception e) {
            addMessage(model, "error", "商品添加失败：" + e.getMessage());
            return "admin/product_add";
        }
    }
    
    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Integer id, HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        productService.getProductById(id).ifPresent(product -> model.addAttribute("product", product));
        return "admin/product_edit";
    }
    
    @PostMapping("/edit")
    public String edit(Product product,
                      @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                      HttpSession session, Model model) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        try {
            // 如果上传了新图片，处理上传并删除旧图片
            if (imageFile != null && !imageFile.isEmpty()) {
                // 获取旧图片路径
                productService.getProductById(product.getId()).ifPresent(oldProduct -> {
                    if (oldProduct.getImage() != null && !oldProduct.getImage().isEmpty()) {
                        FileUploadUtil.deleteImage(oldProduct.getImage());
                    }
                });
                
                // 上传新图片
                String imagePath = FileUploadUtil.uploadImage(imageFile);
                product.setImage(imagePath);
            } else {
                // 如果没有上传新图片，保持原有图片路径
                productService.getProductById(product.getId()).ifPresent(oldProduct -> {
                    product.setImage(oldProduct.getImage());
                });
            }
            
            productService.saveProduct(product);
            addMessage(model, "success", "商品更新成功");
            return "redirect:/admin/products";
        } catch (Exception e) {
            addMessage(model, "error", "商品更新失败：" + e.getMessage());
            productService.getProductById(product.getId()).ifPresent(p -> model.addAttribute("product", p));
            return "admin/product_edit";
        }
    }
    
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Integer id, HttpSession session) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        // 删除商品时，同时删除关联的图片文件
        productService.getProductById(id).ifPresent(product -> {
            if (product.getImage() != null && !product.getImage().isEmpty()) {
                FileUploadUtil.deleteImage(product.getImage());
            }
        });
        
        productService.deleteProduct(id);
        return "redirect:/admin/products";
    }
    
    @GetMapping("/toggle/{id}")
    public String toggleStatus(@PathVariable Integer id, 
                              @RequestParam Integer status, 
                              HttpSession session) {
        if (!isAdminLoggedIn(session)) {
            return "redirect:/admin/login";
        }
        
        productService.updateProductStatus(id, status);
        return "redirect:/admin/products";
    }
}

