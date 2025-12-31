package com.shop.service;

import com.shop.entity.Cart;
import com.shop.entity.Product;
import com.shop.repository.CartRepository;
import com.shop.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class CartService {
    
    @Autowired
    private CartRepository cartRepository;
    
    @Autowired
    private ProductRepository productRepository;
    
    @Transactional
    public Cart addToCart(Integer userId, Integer productId, Integer quantity) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("商品不存在"));
        
        if (product.getStatus() != 1) {
            throw new RuntimeException("商品已下架");
        }
        
        if (product.getStock() < quantity) {
            throw new RuntimeException("库存不足");
        }
        
        Optional<Cart> cartOpt = cartRepository.findByUserIdAndProductId(userId, productId);
        
        if (cartOpt.isPresent()) {
            Cart cart = cartOpt.get();
            int newQuantity = cart.getQuantity() + quantity;
            if (newQuantity > product.getStock()) {
                throw new RuntimeException("库存不足");
            }
            cart.setQuantity(newQuantity);
            return cartRepository.save(cart);
        } else {
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity);
            return cartRepository.save(cart);
        }
    }
    
    public List<Cart> getCartByUserId(Integer userId) {
        List<Cart> carts = cartRepository.findByUserIdOrderByCreatedAtDesc(userId);
        // 加载商品信息
        for (Cart cart : carts) {
            if (cart.getProductId() != null) {
                productRepository.findById(cart.getProductId()).ifPresent(cart::setProduct);
            }
        }
        return carts;
    }
    
    @Transactional
    public void updateCartQuantity(Integer cartId, Integer quantity) {
        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() -> new RuntimeException("购物车项不存在"));
        
        Product product = productRepository.findById(cart.getProductId())
                .orElseThrow(() -> new RuntimeException("商品不存在"));
        
        if (quantity > product.getStock()) {
            throw new RuntimeException("库存不足");
        }
        
        cart.setQuantity(quantity);
        cartRepository.save(cart);
    }
    
    @Transactional
    public void deleteCartItem(Integer cartId) {
        cartRepository.deleteById(cartId);
    }
    
    @Transactional
    public void clearCart(Integer userId) {
        cartRepository.deleteByUserId(userId);
    }
}

