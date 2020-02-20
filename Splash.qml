import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
ApplicationWindow {
    id: appSplash
    objectName: 'awsplash'
    visible: true//Qt.platform.os==='android'?ver:true
    visibility:  Qt.platform.os==='android'?"FullScreen":"Maximized"
    width: Screen.width
    height: Screen.height
    color: "transparent"
    flags: Qt.platform.os==='android'?Qt.Window:Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    property int fs: Qt.platform.os!=='android'?appSplash.width*0.02*unikSettings.zoom:appSplash.width*0.05*unikSettings.zoom
    property bool ver: true
    property color c1: "black"
    property color c2: "black"
    property color c3: "black"
    property color c4: "black"

    property int uProgressBarPorc: 0
    Connections {target: unik;onUkStdChanged: logtxt.setTxtLog(''+unik.ukStd);}
    Connections {target: unik;onStdErrChanged: logtxt.setTxtLog(''+unik.getStdErr());}
    onVerChanged: {
        console.log('VERCH!'+ver)
        r.opacity=0.0
        xLogTxt.opacity=0.0
    }
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
    MouseArea{
        anchors.fill: parent
        Rectangle{
            id: xMouseAreaCleanCfg
            anchors.fill: parent
            color: 'red'
            opacity: 0.0
            SequentialAnimation{
                id: anMouseAreaCleanCfg
                running: false
                NumberAnimation {
                    target: xMouseAreaCleanCfg
                    property: "opacity"
                    from: 0.0
                    to: 0.5
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: xMouseAreaCleanCfg
                    property: "opacity"
                    from: 0.5
                    to: 0.0
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
        onClicked: {
            anMouseAreaCleanCfg.restart()
            tWaitHide.v=0
            //tWaitHide.restart()
            tWaitHide.running=!tWaitHide.running
            unik.setProperty("splashsuspend", !unik.getProperty("splashsuspend"))
        }
        onDoubleClicked: {
            anMouseAreaCleanCfg.restart()
            let cfgFileLocation=appsDir+'/cfg.json'
            unik.deleteFile(cfgFileLocation)
            if(Qt.platform.os==='android'){
                unik.restartApp()
            }else{
                unik.restartApp("")
            }
        }
    }
    /*Timer{
        running: true
        repeat: true
        interval: 500
        onTriggered: {
            if(unik.getEngineObjectsCount()>1){
                appSplash.color="red"
            }
            console.log('TS:'+imgLogo.width)
            console.log('TS2:'+unik.getEngineObjectsCount())
            console.log('TS3:'+appSplash.ver)
            r.color='red'
            imgLogo.width=300
            imgLogo.height=50
        }
    }*/
    Timer{
        id: tRaise
        running: true//appSplash.visible
        repeat: true
        interval: 250
        onTriggered: {
            if(unik.getProperty("launcherLoaded")){
                appSplash.color = "transparent"
                r.opacity=0.0
                appSplash.visible=false
                appSplash.close()
                stop()
            }
        }
    }
    Timer{
        id: tWaitHide
        running: true
        repeat: true
        interval: 500
        property int v: 0
        onTriggered: {
            let msg0=unikSettings.lang==='es'?'Iniciando ':'Starting '
            let msg1=unik.getProperty("currentModule")
            if(v===0){
                if(logtxt.text.indexOf(' git ')<0){
                    logtxt.text=''+msg0+' '+msg1
                }
            }else{
                if(logtxt.text.indexOf(' git ')<0){
                    logtxt.text+='.'
                }
            }
            if(v>6){
                unik.notifySplashFinished()
                appSplash.color = "transparent"
                r.opacity=0.0
                appSplash.visible=false
                appSplash.close()
                stop()
            }
            v++
            //console.log('VVVVVVV:'+v)
        }
    }
    Rectangle{
        id:r
        width: Qt.platform.os!=='android'?appSplash.width*0.15:appSplash.width*0.3
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
            id: imgLogo
            anchors.fill: parent
            //width: 500
            //height: 400
            source: "qrc:/resources/logo_unik_500x500.png"
            Text{
                text: "by <b>unikode.org</b>"
                font.pixelSize: appSplash.fs*0.5
                anchors.right: parent.right
                anchors.rightMargin: appSplash.fs*0.25
                anchors.top: parent.top
                anchors.topMargin: appSplash.fs*1.2
                color: appSplash.c2
            }
        }
        Text{
            text: unikSettings.lang==='es'?'Launcher detenido.\nPresionar un vez el logo para reanudar\ny 2 veces para reinicir Unik':'Launcher stopped.\nPress one click for continue\nand two click for restart Unik.'
            width: appSplash.width*0.75
            visible: !tWaitHide.running
            font.pixelSize: Qt.platform.os!=='android'?appSplash.fs:appSplash.fs*2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: appSplash.fs*2
            color: appSplash.c2
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Rectangle{
                width: parent.contentWidth+appSplash.fs*2
                height: parent.contentHeight+appSplash.fs*2
                anchors.centerIn: parent
                color: appSplash.c1
                border.width: unikSettings.borderWidth
                border.color: appSplash.c2
                radius: unikSettings.radius*0.5
                z:parent.z-1
            }
        }
    }
    Item{
        id:xLogTxt
        //width: appSplash.fs*30
        width:  Qt.platform.os!=='android'?appSplash.fs*30:appSplash.width*0.8
        height: colData.height+appSplash.fs//logtxt.contentHeight+appSplash.fs*0.2
        anchors.top: r.bottom
        anchors.topMargin: appSplash.fs
        anchors.horizontalCenter: r.horizontalCenter
        opacity: r.opacity
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
            radius: unikSettings.radius*0.35
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
                font.pixelSize: Qt.platform.os!=='android'?appSplash.fs:appSplash.fs*1.5
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
                        tWaitHide.v=0
                        tWaitHide.running=false
                        unik.setProperty("splashsuspend", true)
                        //tWaitHide.running=false//!tWaitHide.running
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
                    if(logtxt.text.indexOf('Updated: ')===0){
                        tWaitHide.v=0
                        tWaitHide.running=true
                        unik.setProperty("splashsuspend", false)
                    }
                }
            }

            Rectangle{
                id:pb
                height: appSplash.fs*0.2
                opacity: width===1?0.1:1.0
                width: 1
                color: appSplash.c2
                Behavior on opacity {NumberAnimation{duration: 250}}
            }
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            tWaitHide.stop()
            Qt.quit()
        }
    }
    /*MouseArea{
        anchors.fill: parent
        onClicked: r.opacity = 0.0
    }*/
}
