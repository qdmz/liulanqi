#!/bin/bash

# 简易浏览器打包脚本

echo "==================================="
echo "简易浏览器打包脚本"
echo "==================================="

# 设置变量
PACKAGE_NAME="simple-browser-package"
BUILD_DIR="../build"
PACKAGE_DIR="./$PACKAGE_NAME"

# 创建打包目录
echo "创建打包目录..."
rm -rf $PACKAGE_DIR
mkdir -p $PACKAGE_DIR/{bin,scripts,deps}

# 复制可执行文件
echo "复制可执行文件..."
cp $BUILD_DIR/simple-browser $PACKAGE_DIR/bin/
chmod +x $PACKAGE_DIR/bin/simple-browser

# 复制启动脚本
echo "复制启动脚本..."
cp $BUILD_DIR/run_browser.sh $PACKAGE_DIR/scripts/
chmod +x $PACKAGE_DIR/scripts/run_browser.sh

# 复制部署脚本
cp deploy.sh $PACKAGE_DIR/scripts/
chmod +x $PACKAGE_DIR/scripts/deploy.sh

# 创建运行依赖检查脚本
cat > $PACKAGE_DIR/scripts/check_deps.sh << 'EOF'
#!/bin/bash

echo "检查系统依赖..."

MISSING_DEPS=()

# 检查Qt WebEngine运行时依赖
REQUIRED_LIBS=(
    "libQt5WebEngineCore.so.5"
    "libQt5WebEngineWidgets.so.5"
    "libQt5Widgets.so.5"
    "libQt5Gui.so.5"
    "libQt5Core.so.5"
    "libGL.so.1"
    "libX11.so.6"
    "libXcomposite.so.1"
    "libXdamage.so.1"
    "libXext.so.6"
    "libXfixes.so.3"
    "libXrandr.so.2"
    "libXrender.so.1"
    "libXtst.so.6"
    "libnss3.so"
    "libnssutil3.so"
    "libnspr4.so"
    "libatk-1.0.so.0"
    "libatk-bridge-2.0.so.0"
    "libdrm.so.2"
    "libxkbcommon.so.0"
    "libgbm.so.1"
    "libasound.so.2"
)

for lib in "${REQUIRED_LIBS[@]}"; do
    if ! ldconfig -p | grep -q "$lib"; then
        MISSING_DEPS+=("$lib")
    fi
done

if [ ${#MISSING_DEPS[@]} -eq 0 ]; then
    echo "✓ 所有必需的库都已安装"
    exit 0
else
    echo "✗ 缺少以下库:"
    for dep in "${MISSING_DEPS[@]}"; do
        echo "  - $dep"
    done
    echo ""
    echo "请安装Qt5 WebEngine运行时依赖:"
    if [ -f /etc/debian_version ]; then
        echo "  sudo apt-get install qtwebengine5-dev libqt5webenginewidgets5 fonts-wqy-microhei fonts-wqy-zenhei"
    elif [ -f /etc/redhat-release ]; then
        echo "  sudo yum install qt5-qtwebengine qt5-qtbase-devel wqy-microhei-fonts"
    fi
    exit 1
fi
EOF

chmod +x $PACKAGE_DIR/scripts/check_deps.sh

# 创建使用说明
cat > $PACKAGE_DIR/README.txt << 'EOF'
简易浏览器 - 部署说明
=====================

文件结构:
- bin/simple-browser     # 浏览器主程序
- scripts/run_browser.sh # 启动脚本
- scripts/deploy.sh      # 部署脚本
- scripts/check_deps.sh  # 依赖检查脚本

部署方式:
1. 直接运行部署脚本 (推荐):
   sudo ./scripts/deploy.sh

2. 手动部署:
   - 安装依赖: 参考下面的依赖列表
   - 运行浏览器: ./scripts/run_browser.sh

运行依赖:
- Qt5 WebEngine (qtwebengine5-dev 或 libqt5webenginewidgets5)
- 中文字体 (fonts-wqy-microhei)
- X11图形库
- OpenGL库

服务器环境运行:
如果在无图形界面的服务器上运行，需要先启动虚拟显示:
  Xvfb :99 -screen 0 1024x768x24 &
  export DISPLAY=:99
  ./scripts/run_browser.sh

功能特性:
- 默认首页: http://ipw.cn
- 支持中英文界面切换
- 右键菜单支持保存页面和查看源码
- 地址栏、前进/后退、刷新等基本功能
EOF

# 创建一个简化的启动脚本（不依赖特定路径）
cat > $PACKAGE_DIR/run.sh << 'EOF'
#!/bin/bash
# 简化启动脚本

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查依赖
if [ -f "$SCRIPT_DIR/scripts/check_deps.sh" ]; then
    "$SCRIPT_DIR/scripts/check_deps.sh"
    if [ $? -ne 0 ]; then
        echo "依赖检查失败，请先解决依赖问题"
        exit 1
    fi
fi

# 运行浏览器
if [ -f "$SCRIPT_DIR/bin/simple-browser" ]; then
    cd "$SCRIPT_DIR/bin"
    ./simple-browser "$@"
else
    echo "错误: 找不到浏览器可执行文件"
    exit 1
fi
EOF

chmod +x $PACKAGE_DIR/run.sh

# 打包成tar.gz
echo "创建压缩包..."
cd $PACKAGE_NAME
tar -czf "../${PACKAGE_NAME}.tar.gz" .
cd ..

echo "==================================="
echo "打包完成!"
echo "生成的包: ${PACKAGE_NAME}.tar.gz"
echo "==================================="

echo ""
echo "部署说明:"
echo "1. 解压: tar -xzf $PACKAGE_NAME.tar.gz"
echo "2. 运行部署脚本: sudo $PACKAGE_NAME/scripts/deploy.sh"
echo "   或直接运行: $PACKAGE_NAME/run.sh"
echo ""
echo "注意: 目标机器需要有图形界面或Xvfb虚拟显示环境"