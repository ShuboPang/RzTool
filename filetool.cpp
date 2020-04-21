#include "filetool.h"
#include <QDebug>
#include<QFile>

FileTool::FileTool()
{

}
int FileTool::isNoneLine(QString data)
{
    while(data.indexOf('\r') != -1)
    {
        data.replace('\r',"");
    }
    while(data.indexOf('\n') != -1)
    {
        data.replace('\n',"");
    }
    while(data.indexOf('\t') != -1)
    {
        data.replace('\t',"");
    }
    while(data.indexOf(' ') != -1)
    {
        data.replace(' ',"");
    }
    return data.length();
}


/*
输出文件

*/

int  FileTool::outPutFile(QStringList paths,int config,QString path)
{
    int i = 0;
    QString outputData;
    int count = 0;
    for(i = 0;i<paths.length();i++)
    {
        QString path = paths[i];
        path = path.mid(7);
        QFile file(path);
        if(!file.open(QFile::ReadOnly))
        {
           return -2+i;
        }

        QString data = file.readAll();
        file.close();

        if(config & 0x04)       //去除块注释
        {
            int leftPos = data.indexOf("/*");
            int rightPos = data.indexOf("*/");
            while(leftPos != -1 && rightPos != -1)
            {
                if(rightPos>leftPos)
                {
                    data.remove(leftPos,rightPos-leftPos+2);
                }
                leftPos = data.indexOf("/*");
                rightPos = data.indexOf("*/");
            }
        }

        QStringList lines = data.split('\n');
        QString lineData;
        data = "";
        int j = 0;
        for(j =0;j<lines.length();j++)
        {
            lineData = lines[j];
            if(config & 0x01)       //去除空行
            {
                if(lineData.length() == 0)
                {
                    continue;
                }
            }
            if(config & 0x02)       //去除行注释
            {
                int pos = lineData.indexOf("//");
                if( pos != -1)
                {
                    lineData = lineData.remove(pos,lineData.length()-pos);

                    if(lineData.indexOf('\t') != -1)
                    {
                        lineData.replace('\t',"");
                    }
                    if(lineData.length() == 0)
                    {
                        continue;
                    }
                }
            }
            if(isNoneLine(lineData))
            {
                data += lineData+"\n";
                count++;
            }
            if(config & 0x08)       //只保留3000行代码
            {
                if(count == 3000)
                {
                    break;
                }
            }
        }
        outputData += data;
    }
    QFile outputFile(path.mid(7));
    if(!outputFile.open(QFile::ReadWrite))
    {
       return -1;
    }
    outputFile.write(outputData.toUtf8());
    outputFile.close();
    return count;
}
