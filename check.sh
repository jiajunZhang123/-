#!/bin/bash
# 快速诊断脚本 - 检查 Spring Boot 应用部署状态

echo "=========================================="
echo "Spring Boot 应用诊断工具"
echo "=========================================="
echo ""

echo "=== 1. 检查 Java 版本 ==="
java -version 2>&1
echo ""

echo "=== 2. 检查端口 8080 占用情况 ==="
if command -v netstat &> /dev/null; then
    netstat -tlnp | grep 8080 || echo "端口 8080 未被占用"
elif command -v ss &> /dev/null; then
    ss -tlnp | grep 8080 || echo "端口 8080 未被占用"
else
    echo "无法检查端口占用（需要 netstat 或 ss 命令）"
fi
echo ""

echo "=== 3. 检查 Java 进程 ==="
ps aux | grep java | grep -v grep || echo "没有找到 Java 进程"
echo ""

echo "=== 4. 检查 JAR 文件 ==="
if [ -f "/www/wwwroot/shop_v4/target/shop-v4-1.0.0.jar" ]; then
    ls -lh /www/wwwroot/shop_v4/target/shop-v4-1.0.0.jar
    echo "JAR 文件存在"
else
    echo "❌ JAR 文件不存在: /www/wwwroot/shop_v4/target/shop-v4-1.0.0.jar"
fi
echo ""

echo "=== 5. 检查必要目录 ==="
for dir in "/www/wwwroot/shop_v4/images" "/www/wwwroot/shop_v4/uploads" "/www/wwwroot/shop_v4/logs"; do
    if [ -d "$dir" ]; then
        echo "✓ $dir 存在"
        ls -ld "$dir"
    else
        echo "❌ $dir 不存在"
    fi
done
echo ""

echo "=== 6. 检查防火墙规则（如果使用 firewalld）==="
if command -v firewall-cmd &> /dev/null; then
    firewall-cmd --list-ports 2>/dev/null | grep 8080 && echo "✓ 防火墙已开放 8080 端口" || echo "❌ 防火墙未开放 8080 端口"
else
    echo "未使用 firewalld，请手动检查 iptables 或云服务器安全组"
fi
echo ""

echo "=== 7. 检查 MySQL 服务 ==="
if systemctl is-active --quiet mysql || systemctl is-active --quiet mysqld; then
    echo "✓ MySQL 服务正在运行"
else
    echo "❌ MySQL 服务未运行"
fi
echo ""

echo "=== 8. 测试数据库连接 ==="
if command -v mysql &> /dev/null; then
    mysql -u root -p -e "SELECT 1;" 2>/dev/null && echo "✓ 数据库连接正常" || echo "❌ 数据库连接失败（可能需要密码）"
else
    echo "未安装 mysql 客户端，无法测试连接"
fi
echo ""

echo "=== 9. 检查应用日志（最后 20 行）==="
if [ -f "/www/wwwroot/shop_v4/logs/app.log" ]; then
    echo "应用日志："
    tail -20 /www/wwwroot/shop_v4/logs/app.log
else
    echo "日志文件不存在"
fi
echo ""

echo "=========================================="
echo "诊断完成"
echo "=========================================="

