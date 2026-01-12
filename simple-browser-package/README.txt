简易浏览器 - 部署说明
=====================

文件结构:
- bin/simple-browser     # 浏览器主程序
- scripts/run_browser.sh # 启动脚本
- scripts/deploy.sh      # 部署脚本
- scripts/check_deps.sh  # 依赖检查脚本
- docker/                # Docker部署相关文件
  - Dockerfile.web       # Web版Docker镜像定义
  - docker-compose.yml   # Docker Compose配置
  - DOCKER-README.md     # Docker部署说明
  - build-and-run.sh     # 一键构建运行脚本
- run.sh                 # 简化启动脚本

部署方式:

方式一：传统部署
1. 直接运行部署脚本 (推荐):
   sudo ./scripts/deploy.sh

2. 手动部署:
   - 安装依赖: 参考下面的依赖列表
   - 运行浏览器: ./scripts/run_browser.sh

方式二：Docker部署（推荐用于服务器部署）
1. 使用Docker Compose:
   cd docker
   docker-compose up -d --build
   
2. 使用Docker命令:
   docker build -f docker/Dockerfile.web -t simple-browser .
   docker run -d --name simple-browser -p 6080:6080 --shm-size=2g simple-browser

3. 使用一键脚本:
   cd docker
   ./build-and-run.sh

运行依赖:
- Qt5 WebEngine (qtwebengine5-dev 或 libqt5webenginewidgets5)
- 中文字体 (fonts-wqy-microhei)
- X11图形库
- OpenGL库

服务器环境运行:
如果在无图形界面的服务器上运行，推荐使用Docker部署方案:
  通过Docker容器化部署，用户可通过Web浏览器访问(http://服务器IP:6080)

功能特性:
- 默认首页: http://ipw.cn
- 支持中英文界面切换
- 右键菜单支持保存页面和查看源码
- 地址栏、前进/后退、刷新等基本功能
- 完整的Docker化部署方案
