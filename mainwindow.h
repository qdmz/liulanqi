#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QWebEngineView>
#include <QToolBar>
#include <QLineEdit>
#include <QProgressBar>
#include <QAction>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QWidget>
#include <QPushButton>
#include <QMenuBar>
#include <QMenu>
#include <QApplication>
#include <QTranslator>
#include <QContextMenuEvent>
#include <QFileDialog>
#include <QTextEdit>
#include <QDialogButtonBox>
#include <QVBoxLayout>

class MainWindow : public QMainWindow
{
    Q_OBJECT
    Q_PROPERTY(bool isChinese READ isChinese WRITE setIsChinese NOTIFY languageChanged)

public:
    bool isChinese() const;
    void setIsChinese(bool isChinese);
    
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    
signals:
    void languageChanged();

private slots:
    void loadPage();
    void back();
    void forward();
    void refresh();
    void home();
    void updateUrlBar(const QUrl &url);
    void updateLoadingProgress(int progress);
    void finishLoading(bool ok);
    void toggleLanguage();
    void closeApp();
    void contextMenuRequested(const QPoint &pos);

private:
    void setupUI();
    void setupMenu();

    QWebEngineView *m_webView;
    QLineEdit *m_urlBar;
    QProgressBar *m_progressBar;
    QToolBar *m_navigationToolBar;
    QMenuBar *m_menuBar;
    QAction *m_backAction;
    QAction *m_forwardAction;
    QAction *m_refreshAction;
    QAction *m_homeAction;
    QAction *m_languageAction;
    QAction *m_exitAction;
    QTranslator *m_translator;
    bool m_isChinese;
};

#endif // MAINWINDOW_H