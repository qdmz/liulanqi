cmake_minimum_required(VERSION 3.10)

project(simple-browser VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 查找Qt5和QtWebEngine组件
find_package(Qt5 REQUIRED COMPONENTS Core Widgets WebEngineWidgets)

# 设置MOC
set(CMAKE_AUTOMOC ON)

# 定义源文件
set(SOURCES
    main.cpp
    mainwindow.cpp
)

set(HEADERS
    mainwindow.h
)

# 创建可执行文件
add_executable(simple-browser
    ${SOURCES}
    ${HEADERS}
)

# 链接Qt库
target_link_libraries(simple-browser
    Qt5::Core
    Qt5::Widgets
    Qt5::WebEngineWidgets
)

# 设置安装路径
install(TARGETS simple-browser
    RUNTIME DESTINATION bin
)