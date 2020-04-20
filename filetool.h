#ifndef FILETOOL_H
#define FILETOOL_H
#include<QString>
#include<QObject>

class FileTool:public QObject
{
    Q_OBJECT
public:
    FileTool();
    Q_INVOKABLE int outPutFile(QStringList paths,int config,QString path);
    int isNoneLine(QString data);

private:
    QString outPutPath;
    QStringList inputPath;
    int outPutConfig;
};

#endif // FILETOOL_H
