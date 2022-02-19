#include "wordcontrol.h"

#include <QFileDialog>
#include <QDebug>

WordControl::WordControl(QObject *parent) : QObject(parent)
{
    m_pWord= NULL;
    m_pDocuments= NULL;
    m_pDocument= NULL;
}

void WordControl::createWordDocument(const QString& path)
{
    m_pWord= new QAxWidget("KWPS.Application");//新建一个word应用程序
    m_pWord->setProperty("Visible", false);//不显示窗体

    QAxObject *pDocuments= m_pWord->querySubObject("Documents");
    pDocuments->dynamicCall("Add(Qstring)",path);//模版目录

    m_pDocument= m_pWord->querySubObject("ActiveDocument");//获取当前激活的文档
}

bool WordControl::insertText(QString Tag, QString text)
{
    if (m_pDocument->isNull()) return false;//首先判断有没有获取当前激活的文档&#xff0c;没有则返回失败
    QAxObject *pBookMarkCode= m_pDocument->querySubObject("Bookmarks(QVariant)", Tag);//获取指定标签

    if (pBookMarkCode)
    {
        pBookMarkCode->dynamicCall("Selection");//选择该指定标签
        pBookMarkCode->querySubObject("Range")->setProperty("Text", text);//往标签处插入文字
        delete pBookMarkCode;
        return true;
    }
    return false;
}

void WordControl::saveAndQuit(const QString &text)
{
    m_pDocument->dynamicCall("SaveAs(const QString&)", QDir::toNativeSeparators(text));//“/”换成“\”;否则在windows下保存不成功
    m_pDocument->dynamicCall("Colse(boolean)", true);//关闭
    m_pDocument->dynamicCall("Quit()");//退出
}
