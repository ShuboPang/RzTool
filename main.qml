import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.3
import QtQuick 2.0
import QtQuick.Controls 1.2

Window {
    visible: true
    width: 800
    height: displayRec.height+headLine.height+70
    title: qsTr("软著源码整理工具")
    Row{
        id:headLine
        spacing: 10
        y:10
        Button{
            id:openFile
            width: 100
            height: 25
            text:qsTr("添加文件")
            onClicked:{
                fileDialog.open()
            }
        }
        Button{
            width: 100
            height: 25
            text:qsTr("清空所有")
            onClicked:{
                filePathModel.clear()
            }
        }
        CheckBox{
            id:rmNoneLine
            text:"去除空行"
        }
        CheckBox{
            id:rmLine
            text:"去除行注释"
        }
        CheckBox{
            id:rmBlock
            text:"去除块注释"
        }
        CheckBox{
            id:res3000Lines
            text:"只保留3000行"
        }
        Button{
            text:"开始生成"
            width: 100
            height: 25
            onClicked:{
                if(filePathModel.count == 0){
                    tip.tipText = "没有输入文件"
                    console.log("没有输入文件")
                    return;
                }
                if(outputPath.text == qsTr("请设置输出文件")){
                    tip.tipText = "没有输出路径"
                    console.log("没有输出路径")
                    return;
                }
                var config = 0;
                if(rmNoneLine.checked){
                    config |= 1;
                }
                if(rmLine.checked){
                    config |= 1<<1;;
                }
                if(rmBlock.checked){
                    config |= 1<<2;;
                }
                if(res3000Lines.checked){
                    config |= 1<<3;;
                }
                var paths = []
                var i = 0;
                for(i =0;i<filePathModel.count;i++){
                    paths.push(filePathModel.get(i).path)
                }
                console.log("config",config)
                var lines = fileTool.outPutFile(paths,config,outputPath.text)
                tip.tipText = "共完成"+lines+"行代码"
            }
        }
    }
    FileDialog{
        id: fileDialog
        title: qsTr("源码位置")
        nameFilters: [ "source files *.h *.cpp *.c (*.h *.cpp *.c)", "UI files *.h *.cpp *.qml *.js (*.h *.cpp *.qml *.js)","All files (*)" ]
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
    FileDialog{
        id: outputFileDialog
        title: qsTr("文件输出位置")
        nameFilters: [ "All files (*)" ]
        selectMultiple: false
        onAccepted: {
            outputPath.text = String(fileUrl)
        }
    }
    ListModel{
        id:filePathModel
    }
    Rectangle{
        id:displayRec
        width: parent.width-10
        x:5
        height: 510
        anchors.top:headLine.bottom
        anchors.topMargin: 10
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
                    onClicked: {
                        filePathModel.remove(index)
                    }
                }
            }
        }
    }
    Text {
        id: outputPath
        text: qsTr("请设置输出文件")
        anchors.top:displayRec.bottom
        anchors.topMargin: 10
    }
    Button {
        id: setOutputPath
        text: qsTr("输出路径")
        width: 100
        height: 25
        anchors.top:displayRec.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        onClicked: {
            outputFileDialog.open()
        }
    }
    Rectangle{
        id: tip
        width: 200
        height: 100
        visible: false
        anchors.centerIn: parent
        border.color: "black"
        border.width: 1
        color: "yellow"
        property string tipText: ""

        Text {
            id:showText
            y:20
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Button{
            text:qsTr("确定")
            anchors.top:showText.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                tip.visible = false
                tip.tipText = ""
            }
        }
        onTipTextChanged: {
            if(tip.tipText.length > 0){
                tip.visible = true
                showText.text = tip.tipText
            }
        }
    }
}
