# 设置基础镜像
FROM openjdk:8-jre-slim
# 设置工作目录为 /app
WORKDIR /app
# 将当前目录下的所有文件复制到容器的 /app 目录中
COPY . .
# 后台运行 Java 应用程序，同时使用指定的 Java 代理和jar包
CMD ["java", "-javaagent:/app/iast_agent.jar", "-jar", "/app/target/javasec-1.11.jar"]
