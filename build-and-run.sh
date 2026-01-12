#!/bin/bash

# 简易浏览器 Docker 构建和运行脚本

echo "==========================================="
echo "简易浏览器 Docker 构建和部署脚本"
echo "==========================================="

# 检查是否安装了Docker
if ! command -v docker &> /dev/null; then
    echo "错误: 未找到Docker，请先安装Docker"
    echo "Ubuntu/Debian: curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
    echo "CentOS/RHEL: curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
    exit 1
fi

# 检查是否安装了Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "警告: 未找到docker-compose，将使用docker compose (Docker内置)"
    DOCKER_COMPOSE_CMD="docker compose"
else
    DOCKER_COMPOSE_CMD="docker-compose"
fi

# 检查Docker服务是否运行
if ! docker info &> /dev/null; then
    echo "错误: Docker服务未运行，请启动Docker服务"
    echo "sudo systemctl start docker"
    exit 1
fi

echo "Docker环境检查通过"

# 询问用户是否要构建镜像
echo ""
echo "请选择操作:"
echo "1) 构建并启动容器 (推荐)"
echo "2) 仅构建镜像"
echo "3) 仅启动现有镜像"
echo "4) 停止并删除容器"
echo -n "请输入选择 (1-4): "
read -r choice

case $choice in
    1)
        echo "开始构建并启动容器..."
        $DOCKER_COMPOSE_CMD down 2>/dev/null
        $DOCKER_COMPOSE_CMD build
        $DOCKER_COMPOSE_CMD up -d
        if [ $? -eq 0 ]; then
            echo ""
            echo "==========================================="
            echo "容器启动成功!"
            echo ""
            echo "访问地址: http://$(hostname -I | awk '{print $1}'):6080"
            echo "或者: http://localhost:6080"
            echo ""
            echo "使用方法:"
            echo "1. 打开浏览器访问以上地址"
            echo "2. 点击'Connect'按钮"
            echo "3. 开始使用简易浏览器"
            echo ""
            echo "查看日志: $DOCKER_COMPOSE_CMD logs -f"
            echo "停止服务: $DOCKER_COMPOSE_CMD down"
            echo "==========================================="
        else
            echo "启动失败，请检查错误信息"
            exit 1
        fi
        ;;
    2)
        echo "开始构建镜像..."
        $DOCKER_COMPOSE_CMD build
        if [ $? -eq 0 ]; then
            echo "镜像构建成功!"
            echo "镜像名称: simple-browser"
        else
            echo "构建失败，请检查错误信息"
            exit 1
        fi
        ;;
    3)
        echo "启动现有容器..."
        $DOCKER_COMPOSE_CMD up -d
        if [ $? -eq 0 ]; then
            echo ""
            echo "容器启动成功!"
            echo "访问地址: http://$(hostname -I | awk '{print $1}'):6080"
        else
            echo "启动失败，请检查错误信息"
            exit 1
        fi
        ;;
    4)
        echo "停止并删除容器..."
        $DOCKER_COMPOSE_CMD down
        echo "容器已停止并删除"
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac