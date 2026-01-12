#!/bin/bash
# 启动脚本 - 简易浏览器

# 检查是否在X11环境下运行
if [ -z "$DISPLAY" ]; then
    echo "错误: 未检测到X11显示环境"
    echo "请在图形桌面环境中运行此浏览器"
    echo ""
    echo "或者使用如下命令启动Xvfb虚拟显示环境:"
    echo "Xvfb :99 -screen 0 1024x768x24 &"
    echo "export DISPLAY=:99"
    echo "./simple-browser"
    exit 1
fi

# 检查依赖库
echo "检查依赖库..."
if ! ldd simple-browser > /dev/null 2>&1; then
    echo "警告: 某些依赖库可能缺失"
fi

# 检查是否以root用户运行，如果是则添加--no-sandbox参数
if [ "$EUID" -eq 0 ] || [ "$USER" = "root" ]; then
    echo "以root用户运行，添加--no-sandbox参数..."
    echo "注意：这会降低安全性，仅用于开发/测试目的"
    # 添加额外参数以改善中文显示和兼容性
    ./simple-browser --no-sandbox --single-process --disable-features=VizDisplayCompositor --disable-gpu "$@"
else
    echo "启动简易浏览器..."
    ./simple-browser "$@"
fi