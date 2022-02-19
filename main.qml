import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.3
import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQml 2.12

Window {
    visible: true
    minimumWidth: 800
    minimumHeight: 600
    title: qsTr("软著源码整理工具")+"v202202182346"
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
            text:qsTr("清空所有")+"("+filePathModel.count+")"
            onClicked:{
                filePathModel.clear()
            }
        }

        function sync_config(){
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
            return config;
        }
        CheckBox{
            id:rmNoneLine
            text:"去除空行"
            onClicked: {
                fileTool.setConfig(headLine.sync_config())
            }
        }
        CheckBox{
            id:rmLine
            text:"去除行注释"
            onClicked: {
                fileTool.setConfig(headLine.sync_config())
            }
        }
        CheckBox{
            id:rmBlock
            text:"去除块注释"
            onClicked: {
                fileTool.setConfig(headLine.sync_config())
            }
        }
        CheckBox{
            id:res3000Lines
            text:"只保留3000行"
            onClicked: {
                fileTool.setConfig(headLine.sync_config())
            }
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
                if(outputPath.text.length == 0){
                    tip.tipText = "没有输出路径"
                    console.log("没有输出路径")
                    return;
                }
                var config = headLine.sync_config();
                var paths = []
                var i = 0;
                for(i =0;i<filePathModel.count;i++){
                    paths.push(filePathModel.get(i).path)
                }
                var lines = fileTool.outPutFile(paths,config,outputPath.text)
                if(lines >= 0){
                    tip.tipText = "共完成"+lines+"行代码"
                    openFolder.visible = true
                }
                else if(lines == -1){
                    tip.tipText = "输出文件"+outputPath.text+"打开失败"
                }
                else {
                    tip.tipText = "输入文件"+filePathModel.get(lines*-1-2).path+"打开失败"
                }
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
            var arr = [];
            for(i = 0;i<filePathModel.count;i++){
                arr.push(filePathModel.get(i).path)
            }
            for(i =0;i<fileUrls.length;i++){
                var filePath={}
                if(fileTool.isWindowSystem())
                    filePath.path = String(fileUrls[i]).substring(8)
                else{
                    filePath.path = String(fileUrls[i]).substring(7)
                }

                if(arr.indexOf(filePath.path) == -1)
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
            if(fileTool.isWindowSystem())
                outputPath.text = String(fileUrl).substring(8)
            else{
                outputPath.text = String(fileUrl).substring(7)
            }
            fileTool.setCustomSetting("output_path",outputPath.text)
        }
        Component.onCompleted: {


        }

    }
    ListModel{
        id:filePathModel
    }
    Rectangle{
        id:displayRec
        width: parent.width-10
        x:5
        height: parent.height - headLine.height -10 -outputName.height-30
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
                color: filePathListView.currentIndex == index ?"#ADD8E6":"transparent"
                Text {
                    id: name
                    text: path
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width-10-100-10
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
                    visible: filePathListView.currentIndex == index
                    anchors.verticalCenter: parent.verticalCenter
                    height: 25
                    width: 100
                    onClicked: {
                        filePathModel.remove(index)
                    }
                }
            }
        }
        DropArea{
            anchors.fill: parent
            onDropped: {
                if(drop.hasUrls){
                    var i = 0;
                    var arr = [];
                    for(i = 0;i<filePathModel.count;i++){
                        arr.push(filePathModel.get(i).path)
                    }
                    for(i = 0; i < drop.urls.length; i++){
                       var filePath={}
                       if(fileTool.isWindowSystem())
                           filePath.path = String(drop.urls[i]).substring(8)
                       else{
                           filePath.path = String(drop.urls[i]).substring(7)
                       }

                       if(arr.indexOf(filePath.path) == -1)
                           filePathModel.append(filePath)
                   }
               }
            }
        }
    }
    Text {
        id:outputName
        x:10
        anchors.top:displayRec.bottom
        anchors.topMargin: 10
        text: qsTr("输出文件位置:")
    }
    Rectangle{
        anchors.top:displayRec.bottom
        anchors.topMargin: 10
        anchors.left: outputName.right
        anchors.leftMargin: 10
        border.color: "black"
        border.width: 1
        height: outputPath.height+5
        width: parent.width-120 - outputName.width-20
        TextInput{
             id: outputPath
             y:4
             x:10
             width: parent.width-20
             text: ""
             MouseArea{
                anchors.fill: parent
                onClicked: {
                    fileTool.openFolder(outputPath.text)
                }
             }
         }
    }
    Button {
        id: setOutputPath
        text: qsTr("浏览")
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
        color: "#ADD8E6"
        property string tipText: ""

        Text {
            id:showText
            y:20
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Row{
            anchors.top:showText.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            Button{
                text:qsTr("确定")
                onClicked: {
                    tip.visible = false
                    tip.tipText = ""
                    openFolder.visible = false
                }
            }
            Button{
                id:openFolder
                text:qsTr("打开生成文件")
                visible: false
                onClicked: {
                    fileTool.openFolder(outputPath.text)
                    visible = false
                    tip.visible = false
                    tip.tipText = ""
                }
            }
        }

        onTipTextChanged: {
            if(tip.tipText.length > 0){
                tip.visible = true
                showText.text = tip.tipText
            }
        }
    }
    Component.onCompleted: {
        var config = fileTool.getConfig()
        if(config & 0x01){
            rmNoneLine.checked = true;
        }
        if(config & 0x02){
            rmLine.checked = true;
        }
        if(config & 0x04){
            rmBlock.checked = true;
        }
        if(config & 0x08){
            res3000Lines.checked = true;
        }
        outputPath.text = fileTool.currentPath()
        outputPath.text += "/default.doc"
        var output_path = fileTool.getCustomSetting("output_path",outputPath.text)
        outputPath.text = output_path;
    }

}
