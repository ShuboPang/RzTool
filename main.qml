import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.3
import QtQuick 2.0
import QtQuick.Controls 1.2

Window {
    visible: true
    width: 1000
    height: 720
    title: qsTr("软著源码整理工具")
    Button{
        id:openFile
        width: 100
        height: 50
        text:qsTr("添加文件")
//        anchors.centerIn: parent
        onClicked:{
            fileDialog.open()
        }
    }
    FileDialog{
        id: fileDialog
        title: qsTr("源码位置")
        nameFilters: [ "source files *.h *.cpp *.c (*.h *.cpp *.c)", "ui files *.h *.cpp *.qml *.js (*.h *.cpp *.qml *.js)","All files (*)" ]
        selectMultiple: true
        onAccepted: {
            var i = 0;
            for(i =0;i<fileUrls.length;i++){
                var filePath={}
                filePath.path = String(fileUrls[i])
                filePathModel.append(filePath)
            }

        }
    }
    ListModel{
        id:filePathModel
    }
    Rectangle{
        width: parent.width
        height: 510
        y:100
        border.color: "black"
        border.width: 2
        ListView{
            id:filePathListView
            model: filePathModel
            width: parent.width
            height: 500
            y:5
            x:5
            delegate:Rectangle{
                width: parent.width-10
                height: 30
//                color: filePathListView.currentIndex == index?"blue":"white"
                Text {
                    id: name
                    text: path
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            filePathListView.currentIndex = index
                        }
                    }
                }
                Button{
                    text: "删除"
                    anchors.right: parent.right
                    anchors.rightMargin: 10
//                    visible: filePathListView.currentIndex == index
                    onClicked: {
                        filePathModel.remove(index)
                    }
                }
            }
        }
    }
}
