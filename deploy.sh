#!/bin/bash
#以一种傻瓜交互的形式形式进行原包的Maven打包并可一次成型生成Jar包-完成插桩-封装成完整Docker镜像并自动运行上线。
stty erase ^H

# 交互式输入参数，如果用户不输入则使用默认值
read -p "请输入IAST代理程序的IP地址（默认为172.20.20.11）: " iast_ip
iast_ip=${iast_ip:-172.20.20.11}
iast_url="http://$iast_ip:81/api/agent/api/iast/download?version=MQ=="

read -p "请输入Maven项目所在目录（默认为/root/Hello-Java-Sec）: " project_directory
project_directory=${project_directory:-/root/Hello-Java-Sec}

read -p "请输入Maven项目构建完成后的镜像名称（默认为hellojavasec:v0.1）: " image_name
image_name=${image_name:-hellojavasec:v0.1}

read -p "请输入启用的容器名称（默认为hellojavasec_iast）: " container_name
container_name=${container_name:-hellojavasec_iast}

read -p "请输入对外接口的端口号（默认为8888）: " external_port
external_port=${external_port:-8888}

# 将对外接口的端口号添加到容器名称的最后作为最终的容器名称
final_container_name="${container_name}_${external_port}"

# 下载 IAST 代理程序
curl -o iast_agent.jar "$iast_url"

# 在 Docker 中构建 Maven 项目并运行
docker run -it --rm \
    --name MavenProject \
    -v "$project_directory":/root/Hello-Java-Sec \
    -w /root/Hello-Java-Sec \
    adoptopenjdk/maven-openjdk11:latest \
    mvn clean package -U -DskipTests \
    && docker build -t "$image_name" . \
    && docker run -itd --name "$final_container_name" -p "$external_port":8888  "$image_name"
