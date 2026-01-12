#include "mainwindow.h"
#include <QWebEngineView>
#include <QWebEngineProfile>
#include <QWebEngineSettings>
#include <QToolBar>
#include <QLineEdit>
#include <QProgressBar>
#include <QAction>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QWidget>
#include <QPushButton>
#include <QUrl>
#include <QStandardPaths>
#include <QDir>
#include <QStyle>
#include <QWebEnginePage>
#include <QWebChannel>
#include <QWebEngineScript>
#include <QTextCodec>

#include <QWebEngineProfile>
#include <QWebEngineSettings>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , m_webView(new QWebEngineView(this))
    , m_urlBar(new QLineEdit(this))
    , m_progressBar(new QProgressBar(this))
    , m_navigationToolBar(new QToolBar(this))
    , m_menuBar(nullptr)
    , m_languageAction(nullptr)
    , m_exitAction(nullptr)
    , m_translator(nullptr)
    , m_isChinese(true)
{
    // 为WebEngine设置禁用沙盒（仅在必要时使用，注意安全风险）
    // 这是为了解决在root用户下运行的问题
    QWebEngineProfile *profile = m_webView->page()->profile();
    profile->setHttpCacheType(QWebEngineProfile::NoCache);
    
    // 启用自动检测编码
    profile->settings()->setAttribute(QWebEngineSettings::AutoLoadIconsForPage, true);
    profile->settings()->setAttribute(QWebEngineSettings::JavascriptEnabled, true);
    profile->settings()->setAttribute(QWebEngineSettings::LocalContentCanAccessRemoteUrls, true);
    profile->settings()->setAttribute(QWebEngineSettings::ErrorPageEnabled, true);
    
    setupUI();
    setupMenu();
}

MainWindow::~MainWindow()
{
    // 确保资源被正确释放
    m_webView->stop();
    m_webView->page()->deleteLater();
    m_webView->deleteLater();
}

void MainWindow::setupUI()
{
    // 设置窗口标题
    setWindowTitle(QString::fromUtf8("简易浏览器"));
    resize(1024, 768);

    // 创建导航工具栏
    m_navigationToolBar->setMovable(false);
    addToolBar(m_navigationToolBar);

    // 创建导航动作
    m_backAction = new QAction(QString::fromUtf8("后退"), this);
    m_backAction->setIcon(QIcon::fromTheme("go-previous")); // Fallback icon for back button
    m_backAction->setStatusTip(QString::fromUtf8("返回上一页"));
    connect(m_backAction, &QAction::triggered, this, &MainWindow::back);

    m_forwardAction = new QAction(QString::fromUtf8("前进"), this);
    m_forwardAction->setIcon(QIcon::fromTheme("go-next")); // Fallback icon for forward button
    m_forwardAction->setStatusTip(QString::fromUtf8("前往下一页"));
    connect(m_forwardAction, &QAction::triggered, this, &MainWindow::forward);

    m_refreshAction = new QAction(QString::fromUtf8("刷新"), this);
    m_refreshAction->setIcon(QIcon::fromTheme("view-refresh")); // Fallback icon for refresh button
    m_refreshAction->setStatusTip(QString::fromUtf8("刷新当前页面"));
    connect(m_refreshAction, &QAction::triggered, this, &MainWindow::refresh);

    m_homeAction = new QAction(QString::fromUtf8("主页"), this);
    m_homeAction->setIcon(QIcon::fromTheme("go-home")); // Fallback icon for home button
    m_homeAction->setStatusTip(QString::fromUtf8("返回主页"));
    connect(m_homeAction, &QAction::triggered, this, &MainWindow::home);

    // 添加导航按钮到工具栏
    m_navigationToolBar->addAction(m_backAction);
    m_navigationToolBar->addAction(m_forwardAction);
    m_navigationToolBar->addAction(m_refreshAction);
    m_navigationToolBar->addAction(m_homeAction);

    // 添加地址栏
    m_navigationToolBar->addWidget(m_urlBar);
    m_urlBar->setMinimumWidth(400);
    connect(m_urlBar, &QLineEdit::returnPressed, this, &MainWindow::loadPage);

    // 创建中央部件
    QWidget *centralWidget = new QWidget(this);
    QVBoxLayout *layout = new QVBoxLayout(centralWidget);

    // 添加进度条
    m_progressBar->setVisible(false);
    layout->addWidget(m_progressBar);

    // 添加网页视图
    layout->addWidget(m_webView);
    setCentralWidget(centralWidget);

    // 连接信号槽
    connect(m_webView, &QWebEngineView::urlChanged, this, &MainWindow::updateUrlBar);
    connect(m_webView, &QWebEngineView::loadProgress, this, &MainWindow::updateLoadingProgress);
    connect(m_webView, &QWebEngineView::loadFinished, this, &MainWindow::finishLoading);
    
    // 连接右键菜单信号
    connect(m_webView, &QWebEngineView::customContextMenuRequested, this, &MainWindow::contextMenuRequested);

    // 加载默认页面
    m_webView->setUrl(QUrl("http://ipw.cn"));
    m_urlBar->setText("http://ipw.cn");
}

void MainWindow::loadPage()
{
    QString urlText = m_urlBar->text();
    if (!urlText.startsWith("http://") && !urlText.startsWith("https://")) {
        urlText = "https://" + urlText;
    }
    
    // 设置默认编码为UTF-8
    m_webView->settings()->setDefaultTextEncoding("UTF-8");
    
    // 启用对中文等多语言的支持
    m_webView->settings()->setAttribute(QWebEngineSettings::DnsPrefetchEnabled, true);
    m_webView->settings()->setAttribute(QWebEngineSettings::PluginsEnabled, true);
    m_webView->settings()->setAttribute(QWebEngineSettings::FullScreenSupportEnabled, true);
    
    m_webView->setUrl(QUrl(urlText));
}

void MainWindow::back()
{
    m_webView->back();
}

void MainWindow::forward()
{
    m_webView->forward();
}

void MainWindow::refresh()
{
    m_webView->reload();
}

void MainWindow::home()
{
    // 设置默认编码为UTF-8
    m_webView->settings()->setDefaultTextEncoding("UTF-8");
    
    // 启用对中文等多语言的支持
    m_webView->settings()->setAttribute(QWebEngineSettings::DnsPrefetchEnabled, true);
    m_webView->settings()->setAttribute(QWebEngineSettings::PluginsEnabled, true);
    m_webView->settings()->setAttribute(QWebEngineSettings::FullScreenSupportEnabled, true);
    
    m_webView->setUrl(QUrl("http://ipw.cn"));
    m_urlBar->setText("http://ipw.cn");
}

void MainWindow::updateUrlBar(const QUrl &url)
{
    m_urlBar->setText(url.toString());
}

void MainWindow::updateLoadingProgress(int progress)
{
    if (progress < 100) {
        m_progressBar->setValue(progress);
        m_progressBar->setVisible(true);
    } else {
        m_progressBar->setVisible(false);
    }
}

void MainWindow::finishLoading(bool ok)
{
    Q_UNUSED(ok)
    m_progressBar->setVisible(false);
    m_progressBar->setValue(0);
}

void MainWindow::setupMenu()
{
    m_menuBar = menuBar();
    
    // 创建设置菜单
    QMenu *settingsMenu = m_menuBar->addMenu(QString::fromUtf8("设置"));
    
    // 添加语言切换选项
    m_languageAction = settingsMenu->addAction(QString::fromUtf8("English/中文"));
    m_languageAction->setStatusTip(QString::fromUtf8("切换界面语言"));
    connect(m_languageAction, &QAction::triggered, this, &MainWindow::toggleLanguage);
    
    // 添加退出选项
    m_exitAction = settingsMenu->addAction(QString::fromUtf8("关闭程序"));
    m_exitAction->setStatusTip(QString::fromUtf8("关闭浏览器"));
    connect(m_exitAction, &QAction::triggered, this, &MainWindow::closeApp);
}

void MainWindow::toggleLanguage()
{
    m_isChinese = !m_isChinese;
    
    // 重新设置菜单和按钮文本
    if (m_languageAction) {
        m_languageAction->setText(m_isChinese ? QString::fromUtf8("English/中文") : QString::fromUtf8("English/中文"));
    }
    
    // 更新菜单项文本
    if (m_exitAction) {
        m_exitAction->setText(m_isChinese ? QString::fromUtf8("关闭程序") : QString::fromUtf8("Close Program"));
    }
    
    // 更新工具栏按钮文本
    if (m_backAction) {
        m_backAction->setText(m_isChinese ? QString::fromUtf8("后退") : QString::fromUtf8("Back"));
        m_backAction->setStatusTip(m_isChinese ? QString::fromUtf8("返回上一页") : QString::fromUtf8("Go back to previous page"));
    }
    if (m_forwardAction) {
        m_forwardAction->setText(m_isChinese ? QString::fromUtf8("前进") : QString::fromUtf8("Forward"));
        m_forwardAction->setStatusTip(m_isChinese ? QString::fromUtf8("前往下一页") : QString::fromUtf8("Go forward to next page"));
    }
    if (m_refreshAction) {
        m_refreshAction->setText(m_isChinese ? QString::fromUtf8("刷新") : QString::fromUtf8("Refresh"));
        m_refreshAction->setStatusTip(m_isChinese ? QString::fromUtf8("刷新当前页面") : QString::fromUtf8("Refresh current page"));
    }
    if (m_homeAction) {
        m_homeAction->setText(m_isChinese ? QString::fromUtf8("主页") : QString::fromUtf8("Home"));
        m_homeAction->setStatusTip(m_isChinese ? QString::fromUtf8("返回主页") : QString::fromUtf8("Go to home page"));
    }
    
    // 设置标题栏语言
    setWindowTitle(m_isChinese ? QString::fromUtf8("简易浏览器") : QString::fromUtf8("Simple Browser"));
    
    emit languageChanged();
}

void MainWindow::closeApp()
{
    // 明确停止所有活动
    m_webView->stop();
    
    // 退出应用程序
    QApplication::quit();
}

void MainWindow::contextMenuRequested(const QPoint &pos)
{
    QMenu *menu = m_webView->page()->createStandardContextMenu();
    
    if (menu) {
        // 添加额外的菜单项
        menu->addSeparator();
        
        // 添加保存页面功能
        QAction *savePageAction = new QAction(m_isChinese ? QString::fromUtf8("保存页面") : QString::fromUtf8("Save Page"), menu);
        connect(savePageAction, &QAction::triggered, [this]() {
            // 保存当前页面
            QString fileName = QFileDialog::getSaveFileName(this, 
                m_isChinese ? QString::fromUtf8("保存页面") : QString::fromUtf8("Save Page"), 
                "", 
                m_isChinese ? QString::fromUtf8("网页文件 (*.html *.htm)") : QString::fromUtf8("Web Page (*.html *.htm)"));
            if (!fileName.isEmpty()) {
                m_webView->page()->toHtml([fileName](const QString &result) {
                    QFile file(fileName);
                    if (file.open(QIODevice::WriteOnly)) {
                        file.write(result.toUtf8());
                    }
                });
            }
        });
        menu->addAction(savePageAction);
        
        // 添加查看网页源码功能
        QAction *viewSourceAction = new QAction(m_isChinese ? QString::fromUtf8("查看网页源码") : QString::fromUtf8("View Page Source"), menu);
        connect(viewSourceAction, &QAction::triggered, [this]() {
            // 获取并显示网页源码
            m_webView->page()->toHtml([this](const QString &result) {
                QDialog *sourceDialog = new QDialog(this);
                sourceDialog->setWindowTitle(m_isChinese ? QString::fromUtf8("网页源码") : QString::fromUtf8("Page Source"));
                sourceDialog->resize(800, 600);
                
                QVBoxLayout *layout = new QVBoxLayout(sourceDialog);
                QTextEdit *textEdit = new QTextEdit(sourceDialog);
                textEdit->setPlainText(result);
                textEdit->setReadOnly(true);
                
                layout->addWidget(textEdit);
                
                QDialogButtonBox *buttonBox = new QDialogButtonBox(QDialogButtonBox::Close, sourceDialog);
                connect(buttonBox, &QDialogButtonBox::rejected, sourceDialog, &QDialog::reject);
                layout->addWidget(buttonBox);
                
                sourceDialog->show();
            });
        });
        menu->addAction(viewSourceAction);
        
        menu->exec(m_webView->mapToGlobal(pos));
        delete menu;
    }
}

bool MainWindow::isChinese() const
{
    return m_isChinese;
}

void MainWindow::setIsChinese(bool isChinese)
{
    if (m_isChinese != isChinese) {
        m_isChinese = isChinese;
        emit languageChanged();
    }
}