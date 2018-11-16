import QtQuick 2.7
import QtQuick.Controls 2.0
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0
ApplicationWindow {
    id: appListLaucher
    objectName: 'awll'
    visible: true
    visibility:  "FullScreen"
    color: appListLaucher.c4
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    property int fs: Qt.platform.os !=='android'?appListLaucher.width*0.02:appListLaucher.width*0.03
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    property color c3: "white"
    property color c4: "black"
    property color c5: "#333333"

    property bool prima: false
    property int sec: 0
    property int ci: 0
    property var al: []
    property string ca: ''

    onClosing: {
        if(Qt.platform.os==='android'){
            close.accepted = false;
            Qt.quit()
        }
    }
    onCiChanged: appListLaucher.ca=appListLaucher.al[appListLaucher.ci]
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Settings{
        id: appSettings
        category: 'conf-appsListLauncher'
        property string uApp
    }
    FolderListModel{
        folder: Qt.platform.os!=='windows'?'file://'+appsDir:'file:///'+appDirs
        id:fl
        showDirs:  false
        showDotAndDotDot: false
        showHidden: false
        showOnlyReadable: true
        sortField: FolderListModel.Name
        nameFilters: "*.ukl"
        property int f: 0
        onCountChanged: {
            console.log('File: '+fl.get(f,"fileName"))
            f++
            //tf.restart()
        }
    }
    Rectangle{
        id:r
        width: appListLaucher.width-appListLaucher.fs
        height:parent.height
        color: appListLaucher.c4
        anchors.centerIn: parent
        focus: true
        Keys.onReturnPressed: {
            run()
        }
        Flickable{
           id:flick
           width: appListLaucher.width
           height: appListLaucher.height
           contentHeight: lv.height
           ListView{
            id:lv
            spacing: appListLaucher.fs*0.25
            model:fl
            delegate: delegate
            width: appListLaucher.width-appListLaucher.fs*2
            height: (appListLaucher.fs*2+appListLaucher.fs*0.25)*lv.count
            anchors.horizontalCenter: r.horizontalCenter
            onCurrentIndexChanged: {
                flick.contentY=(appListLaucher.fs*2+appListLaucher.fs*0.25)*currentIndex-appListLaucher.height/2
            }
        }
    }
        Component{
            id:delegate
            Rectangle{
                id:xItem
                width: txt.contentWidth+appListLaucher.fs*2
                height: appListLaucher.fs*2
                color: xItem.border.width!==0?appListLaucher.c4:appListLaucher.c2
                radius: appListLaucher.fs*0.25
                border.width: fileName===appListLaucher.ca?2:0
                border.color: xItem.border.width!==0?appListLaucher.c2:appListLaucher.c4
                anchors.horizontalCenter: parent.horizontalCenter
                visible:(''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.ukl')>0
                onColorChanged: {
                    if(xItem.border.width!==0){
                        appListLaucher.ca=appListLaucher.al[index]
                        lv.currentIndex=index
                    }

                }//lv.currentIndex=index

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        appListLaucher.ci=index
                        appListLaucher.ca=fileName
                    }
                    onDoubleClicked: {
                        var p=unik.getFile(appsDir+'/'+fileName)
                        unik.ejecutarLineaDeComandoAparte(appExec+' -cfg '+p)
                        appListLaucher.close()
                    }
                }
                Text {
                    id: txt
                    text: (''+fileName).substring(5, (''+fileName).length-4)
                    font.pixelSize: appListLaucher.fs
                    color:xItem.border.width!==0?appListLaucher.c2:appListLaucher.c4
                    anchors.centerIn: parent
                }
                Component.onCompleted: {
                    appListLaucher.al.push(fileName)
                    if((''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.json')>0&&!appListLaucher.prima){
                        appListLaucher.ca=appListLaucher.al[index]
                        appListLaucher.prima=true
                    }
                    tinit.restart()
                }
                Text {
                    text: '\uf061'
                    font.family: "FontAwesome"
                    font.pixelSize: appListLaucher.fs
                    color:appListLaucher.c2
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.left
                    anchors.rightMargin: appListLaucher.fs*0.5
                    visible: xItem.border.width!==0
                }
            }
        }

       Rectangle{
            width:parent.width
            height: 6
            color: appListLaucher.c2
            anchors.bottom: parent.bottom
            Rectangle{
                id:psec
                width: 1
                height: parent.height
                color: 'red'
            }
       }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(appListLaucher.ci<appListLaucher.al.length-1){
                appListLaucher.ci++
            }else{
                appListLaucher.ci=0
            }
            tlaunch.stop()
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            if(appListLaucher.ci>0){
                appListLaucher.ci--
            }else{
                appListLaucher.ci=appListLaucher.al.length-1
            }
            tlaunch.stop()
        }
    }
    Rectangle{
        id:tap
        anchors.fill: parent
        color: 'black'
        Behavior on opacity{NumberAnimation{duration:500}
        }
    }
    Timer{
        id: tinit
        running: false
        repeat: false
        interval: 1500
        onTriggered: {
            tap.opacity=0.0
            if(appSettings.uApp===''){
                appSettings.uApp=appListLaucher.al[0]
            }
            for(var i=0;i<appListLaucher.al.length;i++){
                if(appSettings.uApp===appListLaucher.al[i]){
                    appListLaucher.ca=appListLaucher.al[i]
                }
            }
        }
    }
    Timer{
        id: tlaunch
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            appListLaucher.sec++
            if(appListLaucher.sec===7){
                run()
            }
            psec.width=psec.parent.width/5*(appListLaucher.sec-1)

        }
    }
    function run(){
        appSettings.uApp=appListLaucher.ca
        var p=unik.getFile(appsDir+'/'+appListLaucher.ca)
        unik.ejecutarLineaDeComandoAparte(appExec+' -cfg '+p)
        appListLaucher.close()
    }
    Component.onCompleted: {
        //appListLaucher.ca=appListLaucher.al[0]
    }

}



