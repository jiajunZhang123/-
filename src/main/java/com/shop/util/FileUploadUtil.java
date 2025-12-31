package com.shop.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

public class FileUploadUtil {
    
    // 上传目录（项目根目录下的images文件夹）
    private static final String UPLOAD_DIR = "images";
    
    // 允许的图片类型
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"};
    
    /**
     * 上传图片文件
     * @param file 上传的文件
     * @return 保存后的文件路径（相对于项目根目录，如 /images/xxx.png）
     * @throws IOException 文件操作异常
     * @throws IllegalArgumentException 文件类型不支持
     */
    public static String uploadImage(MultipartFile file) throws IOException, IllegalArgumentException {
        if (file == null || file.isEmpty()) {
            return null;
        }
        
        // 检查文件类型
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || originalFilename.isEmpty()) {
            throw new IllegalArgumentException("文件名不能为空");
        }
        
        String extension = getFileExtension(originalFilename);
        if (!isAllowedExtension(extension)) {
            throw new IllegalArgumentException("不支持的文件类型，仅支持：jpg, jpeg, png, gif, bmp, webp");
        }
        
        // 确保上传目录存在
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // 生成唯一文件名
        String fileName = UUID.randomUUID().toString() + extension;
        Path filePath = uploadPath.resolve(fileName);
        
        // 保存文件
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        // 返回相对路径（以/开头，用于URL访问）
        return "/images/" + fileName;
    }
    
    /**
     * 删除图片文件
     * @param imagePath 图片路径（如 /images/xxx.png）
     */
    public static void deleteImage(String imagePath) {
        if (imagePath == null || imagePath.isEmpty()) {
            return;
        }
        
        try {
            // 移除开头的 /images/，获取文件名
            String fileName = imagePath.replaceFirst("^/images/", "");
            Path filePath = Paths.get(UPLOAD_DIR, fileName);
            
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
        } catch (IOException e) {
            // 删除失败不影响主流程，只记录日志
            System.err.println("删除图片失败: " + imagePath + ", 错误: " + e.getMessage());
        }
    }
    
    /**
     * 获取文件扩展名
     */
    private static String getFileExtension(String filename) {
        int lastDotIndex = filename.lastIndexOf('.');
        if (lastDotIndex > 0 && lastDotIndex < filename.length() - 1) {
            return filename.substring(lastDotIndex).toLowerCase();
        }
        return "";
    }
    
    /**
     * 检查文件扩展名是否允许
     */
    private static boolean isAllowedExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equalsIgnoreCase(extension)) {
                return true;
            }
        }
        return false;
    }
}

