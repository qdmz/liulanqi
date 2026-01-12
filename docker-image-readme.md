# 简易浏览器 Docker 镜像

这是一个预构建的简易浏览器 Docker 镜像，可以通过以下方式使用：

## 导入镜像

```bash
# 解压并导入镜像
gunzip -c simple-browser-docker-image.tar.gz | docker load
```

或

```bash
# 如果有未压缩的tar文件
docker load -i simple-browser-docker-image.tar
```

## 运行容器

```bash
# 运行容器并映射端口
docker run -d --name simple-browser -p 6080:6080 --shm-size=2g docker-simple-browser:latest
```

## 访问浏览器

- 打开浏览器访问：`http://your-server-ip:6080`
- 页面会显示noVNC界面
- 点击"Connect"按钮开始使用浏览器

## 功能特性

- 通过Web浏览器访问（无需VNC客户端）
- 支持中英文界面切换
- 右键菜单功能（保存页面、查看源码）
- 默认首页：http://ipw.cn
- 基本浏览功能（前进/后退、刷新、地址栏）

## 镜像信息

- 大小：约 1.3GB（解压后）
- 基础镜像：ubuntu:22.04
- 包含：Xvfb, Fluxbox, x11vnc, noVNC, Qt WebEngine
