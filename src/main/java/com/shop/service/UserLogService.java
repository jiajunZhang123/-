package com.shop.service;

import com.shop.entity.UserLog;
import com.shop.repository.UserLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserLogService {
    
    @Autowired
    private UserLogRepository userLogRepository;
    
    public void logUserAction(Integer userId, Integer productId, String actionType, String ipAddress) {
        UserLog log = new UserLog();
        log.setUserId(userId);
        log.setProductId(productId);
        log.setActionType(actionType);
        log.setIpAddress(ipAddress);
        userLogRepository.save(log);
    }
    
    public List<UserLog> getLogsByActionType(String actionType) {
        return userLogRepository.findByActionType(actionType);
    }
    
    public List<UserLog> getAllLogs() {
        return userLogRepository.findAll();
    }
}

