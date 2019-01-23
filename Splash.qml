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
    property int ms: 1500
    property int fs: appSplash.width*0.02
    property bool ver: true
    property color c1: "#ffffff"
    property color c2: "#4fec35"
    Connections {target: unik;onUkStdChanged: logtxt.setTxtLog(''+unik.ukStd);}
    Connections {target: unik;onStdErrChanged: logtxt.setTxtLog(''+unik.getStdErr());}
    onVerChanged: r.opacity=0.0
    onVisibleChanged: {
        if(!visible){
            appSplash.flags =  Qt.Window
            appSplash.close()
        }
    }
    onClosing: {
        if(Qt.platform.os==='android'){
            close.accepted = false;
        }
        console.log('App Splash closed.')
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
        onOpacityChanged:{
            if(opacity===0.0){
                appSplash.visible=false
            }
        }
        Behavior on opacity{
            NumberAnimation{
                duration: appSplash.ms
            }
        }
        Image {
            anchors.fill: parent
            source: "qrc:/resources/logo_unik_500x500.png"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    r.opacity = 0.0
                    if(Qt.platform.os==='android'){
                        unik.restartApp()
                    }else{
                        unik.restartApp('')
                    }
                }
            }
        }
        Text{
            text: "by <b>unikode.org</b>"
            font.pixelSize: parent.width*0.05
            anchors.right: parent.right
            anchors.rightMargin: appSplash.width*0.01
            anchors.top: parent.top
            color: 'white'
            anchors.topMargin: appSplash.width*0.005
        }
        UnikRect{
            id:xLogTxt
            width: logtxt.contentWidth+20
            height: logtxt.contentHeight+appSplash.fs
            color: "black"
            anchors.top: r.bottom
            anchors.topMargin: -4
            anchors.horizontalCenter: r.horizontalCenter
            radius: appSplash.fs*0.25
            opacity: r.opacity
            Rectangle{
                id:pb
                height: parent.height*0.1
                width: 0
                color: 'white'
                anchors.bottom: parent.bottom
            }
            Text{
                id: logtxt
                color: appSplash.c1
                font.pixelSize: appSplash.fs*0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                textFormat: Text.RichText
                height: contentHeight
                function setTxtLog(t){
                    var  d=(''+t).replace(/\n/g, ' ')
                    var p=true
                    if(d.indexOf('Socket')>=0){
                        p=false
                    }else if(d.indexOf('download git')>=0){
                        var m0=''+d.replace('download git ','')
                        var m1=m0.split(' ')
                        if(m1.length>1){
                            var m2=(''+m1[1]).replace('%','')
                            var m3=parseInt(m2.replace(/ /g,''))
                            if(m3>0){
                                pb.width=pb.parent.width/100*m3
                            }else{
                                pb.width=0
                                logtxt.text='Connecting with the git system...'
                            }
                        }
                    }
                    if(p){
                        logtxt.text=t
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        r.opacity = 0.0
                        if(Qt.platform.os==='android'){
                            unik.restartApp()
                        }else{
                            unik.restartApp('')
                        }
                    }
                }
            }
        }
    }
}
