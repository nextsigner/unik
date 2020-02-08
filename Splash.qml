import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
ApplicationWindow {
    id: appSplash
    objectName: 'awsplash'
    visible: true
    visibility:  Qt.platform.os==='android'?"FullScreen":"Maximized"
    width: Screen.width
    height: Screen.height
    color: "transparent"
    flags: Qt.platform.os==='android'?Qt.Window:Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    property int fs: Qt.platform.os!=='android'?appSplash.width*0.02*unikSettings.zoom:appSplash.width*0.035*unikSettings.zoom
    property bool ver: true
    property color c1: "black"
    property color c2: "black"
    property color c3: "black"
    property color c4: "black"

    property int uProgressBarPorc: 0
    Connections {target: unik;onUkStdChanged: logtxt.setTxtLog(''+unik.ukStd);}
    Connections {target: unik;onStdErrChanged: logtxt.setTxtLog(''+unik.getStdErr());}
    onVerChanged: xLogTxt.opacity=0.0
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
            //close.accepted = true;
        }
    }
    USettings{
        id: unikSettings
        url: pws+'/unik/unik.json'//unik.getPath(3)+'/unik/unik/unik.json'
        function refresh(){
            //unik.setFile('/sdcard/Documents/unik/s.dat', 'File exits '+unik.getPath(3)+'/unik/unik/unik.json'+': '+unik.fileExist(unik.getPath(3)+'/unik/unik/unik.json'))
            var nc=unikSettings.currentNumColor
            if(unikSettings.defaultColors){
                var cc1=unikSettings.defaultColors.split('|')
                var cc2=cc1[nc].split('-')
                appSplash.c1=cc2[0]
                appSplash.c2=cc2[1]
                appSplash.c3=cc2[2]
                appSplash.c4=cc2[3]
                appSplash.fs = appSplash.width*0.02*unikSettings.zoom
            }
        }
        Component.onCompleted: refresh()
        onDataChanged:  refresh()
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
        opacity: xLogTxt.opacity
        /*onOpacityChanged: {
            if(opacity===0.0){
                appSplash.visible=false
            }
        }*/
        Behavior on opacity{
            NumberAnimation{
                duration:500
            }
        }
        Image {
            anchors.fill: parent
            source: "qrc:/resources/logo_unik_500x500.png"
        }
        Text{
            text: "by <b>unikode.org</b>"
            font.pixelSize: parent.width*0.05
            anchors.right: parent.right
            anchors.rightMargin: appSplash.width*0.01
            anchors.top: parent.top
            color: appSplash.c2
            anchors.topMargin: appSplash.width*0.005
        }
    }
    Item{
        id:xLogTxt
        width: appSplash.fs*30
        height: colData.height+appSplash.fs//logtxt.contentHeight+appSplash.fs*0.2
        anchors.top: r.bottom
        anchors.topMargin: appSplash.fs
        anchors.horizontalCenter: r.horizontalCenter
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
        Rectangle{
            width: parent.height
            height: parent.width
            rotation: -90
            anchors.centerIn: parent
            radius: unikSettings.radius
            border.width:unikSettings.borderWidth
            border.color: appSplash.c4
            color: appSplash.c1
        }
        Column{
            id: colData
            spacing: appSplash.fs
            anchors.centerIn: parent
            Text{
                id: logtxt
                color: appSplash.c2
                font.pixelSize: appSplash.fs*0.5
                //anchors.verticalCenter: parent.verticalCenter
                width: parent.parent.width-appSplash.fs
                height: contentHeight
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WrapAnywhere
                //anchors.verticalCenterOffset: appSplash.fs*0.5
                function setTxtLog(t){
                    var  d=(''+t).replace(/\n/g, ' ')
                    var p=true
                    if(d.indexOf('Socket')>=0){
                        p=false
                    }else if(d.indexOf('download git')>=0){
                        var m0=''+d.replace('download git ','')
                        var m1=m0.split(' ')
                        if(m1.length>1){
                            if((''+m1[1]).indexOf('%inf')>=0){
                                logtxt.text=unikSettings.lang==='es'?'Descargando modulo git...':'Downloading git module...'
                                return
                            }
                            var m2=(''+m1[1]).replace('%','')
                            //unik.setFile('/home/nextsigner/nnn', ''+m2)
                            var m3=parseInt(m2.replace(/ /g,''))
                            if(m3>appSplash.uProgressBarPorc){
                                pb.width=pb.parent.width/100*m3
                                appSplash.uProgressBarPorc=m3
                            }
                        }
                    }
                    if(unikSettings.lang==='es'){
                        d=d.replace('download git ', 'Descargando modulo git ')
                    }else{
                        d=d.replace('download git ', 'Downloading git module ')
                    }
                    if(p){
                        logtxt.text=d
                    }
                }
            }

            Rectangle{
                id:pb
                height: appSplash.fs*0.2
                width: 1
                color: appSplash.c2
            }
        }
    }
    /*MouseArea{
        anchors.fill: parent
        onClicked: r.opacity = 0.0
    }*/
}
