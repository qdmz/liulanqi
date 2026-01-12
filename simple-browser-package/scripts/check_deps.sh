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
