# 简易浏览器 (Simple Browser)

这是一个基于Qt WebEngine的轻量级浏览器，具有基本的网页浏览功能。

## 功能特性

- 前进/后退按钮
- 刷新页面
- 地址栏输入网址
- 进度条显示加载状态
- 主页按钮
- 菜单栏支持中英文切换
- 改进的中文显示支持
- 优化的退出机制

## 系统要求

- Linux操作系统
- Qt5 WebEngine开发库
- X11图形环境或虚拟显示

## 编译说明

如果需要重新编译，请确保已安装以下依赖：

```bash
sudo apt-get install qtwebengine5-dev qt5-qmake build-essential cmake
```

然后执行：
```bash
cd /root/liulanqi
mkdir -p build && cd build
cmake ..
make -j$(nproc)
```

## 运行说明

### 在有图形界面的环境下运行：
```bash
cd /root/liulanqi/build
./run_browser.sh
```

### 在无图形界面的服务器上运行（需要安装虚拟显示）：
```bash
sudo apt-get install xvfb
Xvfb :99 -screen 0 1024x768x24 &
export DISPLAY=:99
cd /root/liulanqi/build
./simple-browser
```

### 重要说明：

1. **沙盒问题**：由于Qt WebEngine基于Chromium内核，当以root用户身份运行时，需要禁用沙盒机制。启动脚本(run_browser.sh)已自动处理此问题，当检测到以root用户运行时会自动添加`--no-sandbox`参数。

2. **中文编码问题**：浏览器默认设置为UTF-8编码，以更好地支持中文网页显示。如遇到中文显示问题，可以尝试在地址栏直接访问网页。

3. **虚拟环境兼容性**：在虚拟显示环境（如Xvfb）中运行时，可能需要额外的启动参数，如`--single-process`和`--disable-gpu`，启动脚本已自动处理这些问题。

## 项目结构

- `main.cpp` - 应用程序入口点
- `mainwindow.h/cpp` - 主浏览器窗口实现
- `CMakeLists.txt` - CMake构建配置
- `simple-browser.pro` - Qt qmake构建配置
- `run_browser.sh` - 浏览器启动脚本

## 维护

该项目为精简浏览器示例，适合学习和定制开发。