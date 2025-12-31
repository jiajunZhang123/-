package com.shop.repository;

import com.shop.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {
    List<Product> findByStatus(Integer status);
    
    @Query("SELECT p FROM Product p WHERE p.status = :status AND " +
           "(p.name LIKE %:keyword% OR p.description LIKE %:keyword%)")
    List<Product> searchProducts(@Param("status") Integer status, @Param("keyword") String keyword);
}

