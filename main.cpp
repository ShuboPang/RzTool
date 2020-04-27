#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "filetool.h"
#include <QQmlContext>
#include <QScreen>

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    FileTool fileTool;
    QScreen *screen=app.screens()[0];//获取第一个屏幕

    int width=screen->size().width();//得到屏幕的宽
    int height=screen->size().height();//得到屏幕的高

    engine.rootContext()->setContextProperty("fileTool",&fileTool);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
