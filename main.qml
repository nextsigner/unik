import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.0
import QtQuick.LocalStorage 2.12
import QtQuick.Particles 2.12

import QtQuick.XmlListModel 2.12
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.12
import QtQuick.Templates 2.5
import QtWebView 1.1
import Qt.labs.calendar 1.0
import Qt.labs.folderlistmodel 2.12
import QtGraphicalEffects 1.0
import QtPositioning 5.12
import QtLocation 5.12
import QtWebSockets 1.1

ApplicationWindow {
    id: app
    objectName: 'unik-main-errors'
    visible: true
    flags: Qt.FramelessWindowHint//Qt.Window | Qt.FramelessWindowHint
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    title: qsTr("uniK-status")
    color: app.c2
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    property int fs: Qt.platform.os !=='android'?app.width*0.02:app.width*0.05
    property color c1: "#1fbc05"
    property color c2: "#222222"
    property color c3: "black"
    property color c4: "white"
    property int area: 0
    property string pws: pws
    UnikSettings{
        id: unikSettings
        Component.onCompleted: {
            var nc=unikSettings.currentNumColor
            var cc1=unikSettings.defaultColors.split('|')
            var cc2=cc1[nc].split('-')
            app.c1=cc2[0]
            app.c2=cc2[1]
            app.c3=cc2[2]
            app.c4=cc2[3]
        }
    }
    Item{
        id:xApp
        width: parent.width
        height: parent.height
        Timer{
            running: Qt.platform.os!=='android'
            repeat: true
            interval: 500
            onTriggered: {
                xApp.height=xApp.parent.height-Qt.inputMethod.height
            }
        }
        Item{
            id: xTools
            width: app.fs*1.5
            height: parent.height
            z:99999
            Column{
                id: colTools
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                spacing:  Qt.platform.os !=='android'?width*0.5:width*0.25
                anchors.verticalCenter: parent.verticalCenter

                Boton{//Show Debug Panel
                    id:btnShowDP
                    w:parent.width
                    h: w
                    t: '\uf188'
                    d:'Ver panel de la salida estandar de esta y otras instancias de unik para depurar errores y conocer eventos'
                    b:app.c1
                    c: app.c2
                    opacity: app.area===0?1.0:0.75
                    onClicking: {
                        app.area=0
                    }
                }
                Boton{//Config
                    w:parent.width
                    h: w
                    t: '\uf013'
                    d:'Editar cfg.json de unik y unik-tools'
                    b:app.c1
                    c: app.c2
                    opacity: app.area===1?1.0:0.75
                    onClicking: {
                        app.area = 1
                    }
                }
                Boton{//Actualizar Unik-Tools
                    id:btnUpdate
                    w:parent.width
                    h: w
                    t: '\uf021'
                    d:'Actualizar el còdigo fuente de unik-tools desde GitHub.com'
                    b: up ? 'red':app.c2
                    c: up ? app.c2:app.c1
                    property bool up: false
                    onClicking: {
                        if(Qt.platform.os!=='android'){
                            unik.restartApp("-git=https://github.com/nextsigner/unik-tools.git")
                        }else{
                            var gitDownloaded=unik.downloadGit('https://github.com/nextsigner/unik-tools', appsDir+'/unik-tools')
                            if(gitDownloaded){
                                var j=appsDir+'/temp_cfg.json'
                                var c='{"arg0":"-folder='+appsDir+'/unik-tools'+'"}'
                                unik.setFile(j, c)
                                unik.restartApp()
                            }
                        }
                    }
                }
                Boton{//Restart
                    w:parent.width
                    h: w
                    t: '\uf021'
                    d:'Reiniciar unik'
                    b:app.c1
                    c: app.c2
                    onClicking: {
                        if(Qt.platform.os==='android')unik.restartApp()
                        if(Qt.platform.os!=='android')unik.restartApp("")
                    }
                    Text {
                        text: "\uf011"
                        font.family: "FontAwesome"
                        font.pixelSize: parent.height*0.3
                        anchors.centerIn: parent
                        color: app.c2
                    }
                }
                Boton{//Set Colors
                    w:parent.width
                    h: w
                    t: "\uf1fc"
                    d:'Color'
                    b:app.c1
                    c: app.c2
                    opacity: appColorsThemes.visible?1.0:0.65
                    onClicking: {
                        appColorsThemes.visible=!appColorsThemes.visible
                    }
                    AppColorsThemes{
                        id:appColorsThemes;
                        z:parent.z-1;
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: app.fs
                        visible: false
                    }
                }

                Boton{//Quit
                    w:parent.width
                    h: w
                    t: "\uf011"
                    d:'Apagar unik'
                    b:app.c1
                    c: app.c2
                    onClicking: {
                        Qt.quit()
                    }
                }
            }
        }
        Column{
            width: parent.width-xTools.width-app.fs*2
            height: parent.height
            anchors.left: xTools.right
            anchors.leftMargin: app.fs
            Row{
                id: row1
                height: app.fs*4
                spacing: app.fs
                Image {
                    source: "qrc:/resources/logo_unik_500x500.png"
                    width: app.fs*3
                    height: app.fs*3
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: tit
                    text: '<b>Unik Qml Engine</b>'
                    font.pixelSize: app.fs
                    color: app.c1
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Rectangle{
                id: xTaLog
                width: parent.width
                height: parent.height-app.fs*4
                color: 'transparent'
                visible: app.area===0
                clip: true
                Flickable{
                    id:fkAndroid
                    width: xTaLog.width
                    height: xTaLog.height
                    contentWidth: xTaLog.width
                    contentHeight: taLogAndroid.contentHeight
                    visible: Qt.platform.os==='android'
                    Text {
                        id: taLogAndroid
                        text: taLog.text
                        width: xTaLog.width
                        color: 'yellow'
                        onTextChanged: {
                            fkAndroid.contentY=taLogAndroid.contentHeight
                        }
                        font.pixelSize: app.fs
                        wrapMode: Text.WordWrap
                    }
                }
                ScrollView {
                    id: view
                    width: parent.width
                    height: parent.height
                    visible: Qt.platform.os!=='android'
                    TextArea {
                        id: taLog
                        text: qsTr("Unik Main Qml")
                        width: xTaLog.width
                        height: xTaLog.height
                        onTextChanged: {
                            //taLog.flickableItem.contentY=taLog.flickableItem.contentHeight
                        }
                        color: app.c1
                        textFormat: Text.RichText
                        /*backgroundVisible: false
                        textColor: app.c1
                        style: TextAreaStyle{
                            selectedTextColor: app.c2
                            selectionColor: app.c1
                        }*/
                        font.pixelSize: app.fs
                        wrapMode: Text.WordWrap
                    }
                }
                Connections{
                    target: unik;
                    onUkStdChanged:{
                        //taLog.text+=(unik.ukStd).replace(/\/\n/g, '<br />')
                        taLog.text+=unik.ukStd
                        if(Qt.platform.os==='android'){
                            fkAndroid.contentY=taLogAndroid.contentHeight
                        }
                    }
                }
            }
            Rectangle{
                id: xEditor
                width: parent.width
                height: parent.height-row1.height
                color: app.c3
                visible: app.area===1
                onVisibleChanged: {
                    if(visible){
                        if(unik.fileExist(appsDir+'/cfg.json')){
                            txtEdit.text = unik.getFile(appsDir+'/cfg.json')
                        }
                    }
                }
                TextEdit {
                    id: txtEdit
                    width: parent.width*0.98
                    height: parent.height/3
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: app.width*0.02
                    color: app.c1
                }
                Rectangle{
                    width: labelbtn2.contentWidth*1.2
                    height: app.width*0.02
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: app.width*0.005
                    anchors.left: parent.left
                    anchors.leftMargin: app.width*0.005
                    Text {
                        id:labelbtn2
                        text: "Cancel"
                        font.pixelSize: app.width*0.015
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            app.area=0
                        }
                    }
                }
                Rectangle{
                    width: labelbtnDelete.contentWidth*1.2
                    height: app.width*0.02
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: app.width*0.005
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        id:labelbtnDelete
                        text: "Delete Config File"
                        font.pixelSize: app.width*0.015
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var p = appsDir+'/cfg.json'
                            console.log("Config File Deleted: "+p)
                            console.log("Unik have unik-tools a default app.")
                            unik.deleteFile(p)
                            app.area=0
                        }
                    }
                }
                Rectangle{
                    width: labelbtn3.contentWidth*1.2
                    height: app.width*0.02
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: app.width*0.005
                    anchors.right: parent.right
                    anchors.rightMargin: app.width*0.005
                    Text {
                        id:labelbtn3
                        text: "Set Config"
                        font.pixelSize: app.width*0.015
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var p = appsDir+'/cfg.json'
                            console.log("Config Path: "+p)
                            console.log("New Config Data: "+txtEdit.text)
                            unik.setFile(p, txtEdit.text)
                            app.area=0
                        }
                    }
                }
            }
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Component.onCompleted: {


        setColors()
        if(Qt.platform.os==='windows'){
            var a1 = Screen.desktopAvailableHeight
            var altoBarra = a1-unik.frameHeight(app)
            app.height = a1-altoBarra
        }
        var s=unik.initStdString
        var stdinit='Start Unik Init Message:<br/>'+s+'<br/>End Unik Init Message.<br/>'
        var txt ='<br/>'
        txt += "OS: "+Qt.platform.os+'<br/>'
        txt += 'Doc location: '+appsDir+'<br/>'
        txt += 'WorkSpace location: '+pws+'<br/>'
        txt += '<br/>UAP Arguments:'+uap+'<br/>'
        txt+="<br/>"+appStatus+'<br/>'

        txt += "<br/>Unik Init Errors:<br/>"
        txt += 'sourcePath: '+sourcePath+'<br/>'
        if(unik.fileExist(appsDir+'/cfg.json')){
            txt += '\ncfg.json:<br/>'+unik.getFile(appsDir+'/cfg.json')+'<br/>'
        }else{
            txt += '\ncfg.json:<br/>No cfg.json file seted.<br/>'
        }
        txt+="<br/><br/><br/>"
        taLog.text+=stdinit.replace(/\n/g, '<br />')
        taLog.text+=txt.replace(/\n/g, '<br />')
    }
    function setColors(){
        var nc=unikSettings.currentNumColor
        var cc1=unikSettings.defaultColors.split('|')
        var cc2=cc1[nc].split('-')
        app.c1=cc2[0]
        app.c2=cc2[1]
        app.c3=cc2[2]
        app.c4=cc2[3]
    }
}
