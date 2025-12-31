package com.shop.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
    
    @Autowired
    private JavaMailSender mailSender;
    
    @Value("${spring.mail.username}")
    private String fromEmail;
    
    /**
     * 发送订单完成通知邮件
     * @param toEmail 收件人邮箱
     * @param orderNo 订单号
     * @param totalAmount 订单总金额
     */
    public void sendOrderCompletedEmail(String toEmail, String orderNo, String totalAmount) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("订单已完成 - 请确认收货");
            
            String content = String.format(
                "尊敬的客户，您好！\n\n" +
                "您的订单 %s 已完成，请登录平台确认收货。\n\n" +
                "订单详情：\n" +
                "订单号：%s\n" +
                "订单金额：¥%s\n\n" +
                "请点击以下链接登录平台确认收货：\n" +
                "http://localhost:8080/shop_v4/orders\n\n" +
                "感谢您的支持！\n\n" +
                "此邮件由系统自动发送，请勿回复。",
                orderNo, orderNo, totalAmount
            );
            
            message.setText(content);
            mailSender.send(message);
        } catch (Exception e) {
            // 邮件发送失败不影响主流程，只记录日志
            System.err.println("发送邮件失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

