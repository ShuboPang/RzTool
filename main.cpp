#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "filetool.h"
#include <QQmlContext>

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    FileTool fileTool;
    engine.rootContext()->setContextProperty("fileTool",&fileTool);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
