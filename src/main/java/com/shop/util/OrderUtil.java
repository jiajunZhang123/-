package com.shop.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Random;

public class OrderUtil {
    private static final Random random = new Random();
    
    public static String generateOrderNo() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        int randomNum = 1000 + random.nextInt(9000);
        return "ORD" + timestamp + randomNum;
    }
}

