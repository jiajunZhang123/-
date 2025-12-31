package com.shop.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 获取项目根目录
        String projectPath = Paths.get("").toAbsolutePath().toString();
        
        // 配置静态资源映射
        // Windows 路径需要转换为正斜杠，且路径必须以 / 结尾
        String imagesPath = projectPath.replace("\\", "/") + "/images/";
        String uploadsPath = projectPath.replace("\\", "/") + "/uploads/";
        
        // 添加静态资源处理器，设置缓存时间为1小时
        registry.addResourceHandler("/images/**")
                .addResourceLocations("file:" + imagesPath)
                .setCachePeriod(3600);
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadsPath)
                .setCachePeriod(3600);
    }
}
