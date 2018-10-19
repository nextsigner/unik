import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
ApplicationWindow {
    id: appSplash
    objectName: 'awsplash'
    visible: true
    visibility:  "Maximized"
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    property bool ver: true
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    Connections {target: unik;onUkStdChanged: logtxt.setTxtLog(''+unik.ukStd);}
    Connections {target: unik;onStdErrChanged: logtxt.setTxtLog(''+unik.getStdErr());}
    onVerChanged: r.opacity=0.0
    onVisibleChanged: {
        if(!visible){
            appSplash.flags =  Qt.Window
            if(Qt.platform.os==='android'){
                    //appSplash.close()
            }
        }
    }
    onClosing: {
        if(Qt.platform.os==='android'){
            close.accepted = false;
        }
    }
    Timer{
        running: !ver
        repeat: false
        interval: 1000
        onTriggered: r.opacity=0.0
    }
    Rectangle{
        id:r
        width: appSplash.width*0.1
        height: width
        color: "transparent"
        anchors.centerIn: parent
        onOpacityChanged: {
            if(opacity===0.0){
                appSplash.visible=false
            }
        }
        Behavior on opacity{
            NumberAnimation{
                duration:500
            }
        }
        Image {
            anchors.fill: parent
            source: "qrc:/resources/logo_unik_300.png"
        }
        Text{
            text: "by <b>@nextsigner</b>"
            font.pixelSize: parent.width*0.05
            anchors.right: parent.right
            anchors.rightMargin: appSplash.width*0.01
            anchors.top: parent.top
            color: appSplash.c2
            anchors.topMargin: appSplash.width*0.005
        }
    }
    Rectangle{
        id:xLogTxt
        width: logtxt.contentWidth+20
        height: logtxt.contentHeight
        anchors.top: r.bottom
        anchors.topMargin: -4
        anchors.horizontalCenter: r.horizontalCenter
        color: "#333333"
        radius: 6
        border.color: appSplash.c1
        Rectangle{
            id:pb
            height: parent.height*0.1
            width: 0
            color: 'red'
            anchors.bottom: parent.bottom
        }
        Text{
            id: logtxt
            color: appSplash.c2
            font.pixelSize: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 5
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignBottom
            function setTxtLog(t){
                var  d=(''+t).replace(/\n/g, ' ')
                var p=true
                if(d.indexOf('Socket')>=0){
                    p=false
                }else if(d.indexOf('download git')>=0){
                    var m0=''+d.replace('download git ','')
                    var m1=m0.split(' ')
                    var m2=(''+m1[1]).replace('%','')
                    //unik.setFile('/home/nextsigner/nnn', ''+m2)
                    var m3=parseInt(m2.replace(/ /g,''))
                    pb.width=pb.parent.width/100*m3
                }
                if(p){
                    logtxt.text=t
                }
            }
        }
        Component.onCompleted: {
            if(!unik.isRPI()){
                xLogTxt.border.width=1
            }else{
                xLogTxt.border.width=0
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: r.opacity = 0.0
    }
}
