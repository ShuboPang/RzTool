#ifndef FILETOOL_H
#define FILETOOL_H
#include<QString>
#include<QObject>

class FileTool:public QObject
{
    Q_OBJECT
public:
    FileTool();
    Q_INVOKABLE void outPutFile(QStringList paths,int config,QString path);

private:
    QString outPutPath;
    QStringList inputPath;
    int outPutConfig;
};

#endif // FILETOOL_H
