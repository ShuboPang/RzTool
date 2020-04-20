#include "filetool.h"
#include <QDebug>
#include<QFile>

FileTool::FileTool()
{

}

void  FileTool::outPutFile(QStringList paths,int config,QString path)
{
    int i = 0;
    QString outputData;
    for(i = 0;i<paths.length();i++)
    {
        QString path = paths[i];
        path = path.mid(7);
        QFile file(path);
        if(!file.open(QFile::ReadOnly))
        {
           return;
        }

        QString data = file.readAll();
        file.close();

        QStringList lines = data.split('\n');
        QString lineData;
        data = "";
        int j = 0;
        for(j =0;j<lines.length();j++)
        {
            lineData = lines[j];
            if(config & 0x01)
            {
                if(lineData.length() == 0)
                {

                    continue;
                }
            }
            if(config & 0x02)
            {
                if(lineData.indexOf("//") != -1)
                {
                    lineData = lineData.split("//")[0];
                    if(lineData.length() == 0)
                    {
                        continue;
                    }
                }
            }
            data += lineData+"\n";
        }
        outputData += data;
    }
    QFile outputFile(path.mid(7));
    if(!outputFile.open(QFile::ReadWrite))
    {
       return;
    }
    outputFile.write(outputData.toUtf8());
    outputFile.close();
}
