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
