#!/bin/bash

# 简易浏览器部署脚本

echo "==================================="
echo "简易浏览器部署脚本"
echo "==================================="

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
    echo "警告: 建议以root权限运行此脚本以安装依赖"
    echo "请使用: sudo $0"
    exit 1
fi

# 检查系统类型
if [ -f /etc/debian_version ] || [ -f /etc/lsb-release ]; then
    DISTRO="DEBIAN"
elif [ -f /etc/redhat-release ] || [ -f /etc/centos-release ]; then
    DISTRO="REDHAT"
else
    echo "未知的Linux发行版，尝试使用Debian系命令"
    DISTRO="DEBIAN"
fi

echo "检测到系统类型: $DISTRO"

# 函数：安装Debian系系统依赖
install_debian_deps() {
    echo "正在更新软件包列表..."
    apt-get update
    
    echo "正在安装浏览器运行依赖..."
    apt-get install -y \
        qtwebengine5-dev \
        qt5-qmake \
        libqt5webenginewidgets5 \
        libqt5webenginecore5 \
        fonts-wqy-microhei \
        fonts-wqy-zenhei \
        xdg-utils \
        libgl1-mesa-glx \
        libglib2.0-0 \
        libxrender1 \
        libxrandr2 \
        libxss1 \
        libgtk-3-0 \
        libnss3 \
        libdrm2 \
        libxkbcommon0 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxrandr2 \
        libasound2 \
        libatspi2.0-0 \
        libcairo-gobject2 \
        libdbus-1-3 \
        libgdk-pixbuf-2.0-0 \
        libgtk-3-0 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libpangoft2-1.0-0 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxinerama1 \
        libxrandr2 \
        libxrender1 \
        libxtst6 \
        libnss3 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcups2 \
        libdrm2 \
        libgbm1 \
        libxss1 \
        libgtk-3-0 \
        libgconf-2-4
}

# 函数：安装RedHat系系统依赖
install_redhat_deps() {
    echo "RedHat系系统的依赖安装暂未完全适配"
    echo "请手动安装以下依赖包："
    echo "qt5-qtwebengine, qt5-qtbase, wqy-microhei-fonts, mesa-libGL, alsa-lib, cups"
    exit 1
}

# 安装依赖
case $DISTRO in
    DEBIAN)
        install_debian_deps
        ;;
    REDHAT)
        install_redhat_deps
        ;;
    *)
        echo "未知系统类型，尝试使用Debian方式安装依赖"
        install_debian_deps
        ;;
esac

# 创建安装目录
INSTALL_DIR="/opt/simple-browser"
echo "创建安装目录: $INSTALL_DIR"
mkdir -p $INSTALL_DIR

# 复制浏览器文件
BROWSER_EXECUTABLE="../build/simple-browser"
if [ -f "$BROWSER_EXECUTABLE" ]; then
    echo "复制浏览器可执行文件..."
    cp "$BROWSER_EXECUTABLE" $INSTALL_DIR/
    chmod +x $INSTALL_DIR/simple-browser
else
    echo "错误: 找不到浏览器可执行文件 $BROWSER_EXECUTABLE"
    exit 1
fi

# 复制启动脚本
LAUNCHER_SCRIPT="../build/run_browser.sh"
if [ -f "$LAUNCHER_SCRIPT" ]; then
    echo "复制启动脚本..."
    cp "$LAUNCHER_SCRIPT" $INSTALL_DIR/
    chmod +x $INSTALL_DIR/run_browser.sh
else
    echo "错误: 找不到启动脚本 $LAUNCHER_SCRIPT"
    exit 1
fi

# 创建桌面快捷方式（如果系统有图形环境）
if command -v xdg-desktop-menu >/dev/null 2>&1; then
    DESKTOP_FILE="$INSTALL_DIR/simple-browser.desktop"
    echo "[Desktop Entry]" > "$DESKTOP_FILE"
    echo "Name=Simple Browser" >> "$DESKTOP_FILE"
    echo "Exec=$INSTALL_DIR/run_browser.sh" >> "$DESKTOP_FILE"
    echo "Type=Application" >> "$DESKTOP_FILE"
    echo "Icon=applications-internet" >> "$DESKTOP_FILE"
    echo "Categories=Network;WebBrowser;" >> "$DESKTOP_FILE"
    echo "Comment=Simple Qt WebEngine Browser" >> "$DESKTOP_FILE"
    
    echo "创建桌面快捷方式..."
    chmod +x "$DESKTOP_FILE"
fi

# 创建启动脚本的符号链接到PATH
ln -sf $INSTALL_DIR/run_browser.sh /usr/local/bin/simple-browser || true

echo "==================================="
echo "安装完成!"
echo "==================================="
echo "启动浏览器请运行: $INSTALL_DIR/run_browser.sh"
echo "或者: simple-browser (如果添加了PATH)"
echo ""
echo "注意事项:"
echo "- 如果在服务器环境运行，需要先启动Xvfb虚拟显示:"
echo "  Xvfb :99 -screen 0 1024x768x24 &"
echo "  export DISPLAY=:99"
echo "  $INSTALL_DIR/run_browser.sh"
echo ""
echo "- 首次运行可能需要一些时间来初始化WebEngine缓存"
echo "==================================="

# 检查是否有图形环境
if [ -z "$DISPLAY" ] && ! command -v Xvfb >/dev/null 2>&1; then
    echo ""
    echo "警告: 未检测到图形环境，您可能需要安装Xvfb:"
    echo "  Debian/Ubuntu: apt-get install xvfb"
    echo "  CentOS/RHEL: yum install xorg-x11-server-Xvfb 或 dnf install xorg-x11-server-Xvfb"
fi