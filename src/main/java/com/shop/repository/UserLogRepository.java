package com.shop.repository;

import com.shop.entity.UserLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface UserLogRepository extends JpaRepository<UserLog, Integer> {
    List<UserLog> findByActionTypeOrderByCreatedAtDesc(String actionType);
    
    @Query("SELECT ul FROM UserLog ul WHERE ul.actionType = :actionType ORDER BY ul.createdAt DESC")
    List<UserLog> findByActionType(String actionType);
}

