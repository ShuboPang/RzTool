#ifndef WORDCONTROL_H
#define WORDCONTROL_H

#include <QObject>
#include <QAxObject>
#include <QAxWidget>


class WordControl: public QObject
{
    Q_OBJECT
public:
    explicit WordControl(QObject *parent = 0);

private:
    QString m_fileName;//存入位置
    QAxWidget *m_pWord;
    QAxObject *m_pDocuments;
    QAxObject *m_pDocument;//

public:
    void createWordDocument(const QString &path,bool wps = false);//创建word文档
    bool insertText(QString Tag, QString text);//往标签处插入文字
    void saveAndQuit(const QString &text);//保存文档并退出

signals:

public slots:

};

#endif // WORDCONTROL_H
