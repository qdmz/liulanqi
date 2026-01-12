#include "mainwindow.h"
#include <QApplication>
#include <QWebEngineProfile>
#include <QWebEngineSettings>
#include <QDir>
#include <QStandardPaths>
#include <unistd.h>
#include <QTextCodec>
#include <QLocale>
#include <QTranslator>

int main(int argc, char *argv[])
{
    // 添加命令行参数来禁用沙盒（仅在必要时使用，注意安全风险）
    // 这是为了解决在root用户下运行的问题
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    
    QApplication app(argc, argv);
    
    // 设置应用程序的编码以支持中文
    QTextCodec *codec = QTextCodec::codecForName("UTF-8");
    QTextCodec::setCodecForLocale(codec);
    
    // 设置系统区域为中文
    QLocale::setDefault(QLocale(QLocale::Chinese, QLocale::China));
    
    // 为Qt设置字体以支持中文显示
    QFont font = app.font();
    font.setFamily("WenQuanYi Micro Hei"); // 使用已安装的中文字体
    app.setFont(font);
    
    app.setApplicationName("Simple Browser");
    app.setApplicationVersion("1.0");
    
    // 设置WebEngine特定的属性并解决数据库锁定问题
    QWebEngineProfile *profile = QWebEngineProfile::defaultProfile();
    profile->setHttpCacheType(QWebEngineProfile::NoCache);
    
    // 设置临时数据路径以避免数据库锁定问题
    QString tempPath = QDir::tempPath() + "/simple_browser_" + QString::number(getpid());
    profile->setPersistentStoragePath(tempPath + "/storage");
    profile->setCachePath(tempPath + "/cache");
    profile->setDownloadPath(tempPath + "/downloads");

    MainWindow window;
    window.show();

    return app.exec();
}