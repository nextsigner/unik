import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.2
ApplicationWindow{
    id: appSplash
    objectName: 'awsplash'
    visible: true
    visibility: "FullScreen"
    //visibility: Qt.platform.os!=='android' ? "Maximized": undefined
    color: "black"
    property bool ver: true
    property color c1: "#1fbc05"
    property color c2: "#4fec35"
    //Connections {target: unik;onUkStdChanged: log.text=(''+unik.ukStd).replace(/\n/g, ' ');}
    //Connections {target: unik;onStdErrChanged: log.text=(''+unik.getStdErr()).replace(/\n/g, ' ');}

    onClosing: {
        close.accepted = false
    }

    Timer{
        running: true
        repeat: true
        interval: 10
        onTriggered: {
            if(!splashvisible){
                appSplash.color = "transparent"
                r.visible=false
            }
        }
        //onTriggered: appSplash.visible=false
    }
    Rectangle{
        id:r
        width: parent.width
        height: parent.height
        color: "transparent"
        anchors.centerIn: parent
        /*onOpacityChanged: {
            if(opacity===0.0){
                //appSplash.visible=false
                appSplash.close()
            }
        }*/
        Behavior on opacity{
            NumberAnimation{
                duration:500
            }
        }
        Image {
            id: logo
            width: parent.width*0.25
            height: width
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.centerIn: parent
            source: "qrc:/resources/logo_unik_300.png"
            opacity: 0.0
            Behavior on opacity {
                NumberAnimation{
                    duration: 1500
                }
            }
        }
        Text{
            text: "by <b>@nextsigner</b>"
            font.pixelSize: 14
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 46
        }
        Rectangle{
            opacity: logo.opacity
            width: Screen.desktopAvailableWidth<Screen.desktopAvailableHeight ? Screen.desktopAvailableWidth*0.9 : Screen.desktopAvailableHeight*0.9
            height: log.contentHeight
            anchors.top: logo.bottom
            anchors.topMargin: -4
            anchors.horizontalCenter: r.horizontalCenter
            color: "#333333"
            radius: 6
            border.width: 1
            border.color: appSplash.c1
            Text{
                id: log
                color: appSplash.c2
                width: appSplash.width<appSplash.height ? appSplash.width*0.9 : appSplash.height*0.9
                height: contentHeight
                wrapMode: Text.WordWrap
                font.pixelSize: 10
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                appSplash.color = "transparent"
                r.visible=false
            }
        }
    }
    Component.onCompleted: logo.opacity=1.0
}
