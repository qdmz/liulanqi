QT += webenginewidgets widgets core gui
CONFIG += c++11

TARGET = simple-browser
TEMPLATE = app

SOURCES += \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    mainwindow.h

# 指定输出目录
DESTDIR = $$PWD/bin
OBJECTS_DIR = $$PWD/.obj

# 启用大页面支持
QMAKE_CXXFLAGS += -O2