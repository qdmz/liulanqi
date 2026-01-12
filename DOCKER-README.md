# 简易浏览器 - Docker部署方案

通过Docker部署简易浏览器，用户可以通过Web浏览器访问运行在服务器上的浏览器。

## 功能特性

- 通过Web浏览器访问（无需VNC客户端）
- 支持中英文界面切换
- 右键菜单功能（保存页面、查看源码）
- 默认首页：http://ipw.cn
- 基本浏览功能（前进/后退、刷新、地址栏）

## 部署方法

### 方法一：使用Docker Compose（推荐）

1. 确保已安装Docker和Docker Compose
2. 将此目录下的所有文件复制到服务器
3. 运行以下命令：

```bash
# 构建并启动容器
docker-compose up -d --build

# 查看运行状态
docker-compose logs -f
```

4. 访问 `http://你的服务器IP:6080` 即可使用浏览器

### 方法二：使用Docker命令

1. 构建镜像：
```bash
docker build -f Dockerfile.web -t simple-browser .
```

2. 运行容器：
```bash
docker run -d --name simple-browser -p 6080:6080 --shm-size=2g simple-browser
```

3. 访问 `http://你的服务器IP:6080`

## 访问方式

- 打开浏览器访问：`http://你的服务器IP:6080`
- 页面会显示noVNC界面
- 点击"Connect"按钮即可开始使用浏览器

## 技术架构

- **Xvfb**: 虚拟X11显示服务器
- **Fluxbox**: 轻量级窗口管理器
- **x11vnc**: VNC服务器
- **noVNC**: 基于Web的VNC客户端
- **Supervisor**: 进程管理工具

## 注意事项

1. 服务器需要开放6080端口
2. 首次启动可能需要一些时间（约1-2分钟）
3. 浏览器运行在虚拟桌面环境中
4. 支持中文显示和输入

## 容器管理

```bash
# 查看容器状态
docker ps

# 查看日志
docker logs simple-browser

# 停止容器
docker stop simple-browser

# 启动容器
docker start simple-browser

# 删除容器
docker rm simple-browser

# 删除镜像
docker rmi simple-browser
```

## 性能优化

- 已配置2GB共享内存以支持浏览器运行
- 使用轻量级窗口管理器减少资源占用
- 优化的Qt WebEngine参数设置

## 故障排除

如果无法访问：
1. 检查防火墙是否开放6080端口
2. 查看容器日志：`docker logs simple-browser`
3. 确认服务器资源充足（建议至少2GB内存）