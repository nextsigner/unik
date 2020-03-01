import QtQuick 2.0
import QtQuick.Window 2.0
Rectangle{
    id:r
    width: Qt.platform.os==='android'?Screen.width-app.fs:Screen.width/2//app.width-app.fs//rowTit.width+app.fs*2//rowTit.width>(cantColors/4)*app.fs*3+app.fs?rowTit.width+app.fs:(cantColors/2)*app.fs*3+app.fs
    height: gridPackColor.height+app.fs*3
    color:app.c4
    border.width: unikSettings.borderWidth
    border.color: app.c2
    radius: unikSettings.radius*0.5
    property alias showBtnClose: btnCloseACT.visible
    property int currentFocus: -1
    property int cantColors//: gridPackColor.children.length-1
    Timer{
        running: true
        repeat: true
        interval: 500
        onTriggered: {
            if(unikSettings.defaultColors){
                var ac=unikSettings.defaultColors.split('|')
                rep1.model=ac
            }
        }
    }
    Boton{//Close
        id: btnCloseACT
        w:app.fs
        h: w
        t: "\uf00d"
        d:'Close'
        b:app.c1
        c: app.c2
        anchors.right: parent.right
        anchors.rightMargin: app.fs*0.1
        anchors.top: parent.top
        anchors.topMargin: app.fs*0.1
        onClicking: {
            r.visible=false
        }
        UBg{}
    }
    Column{
        anchors.centerIn: r
        spacing: app.fs*0.5
        Row{
            id: rowTit
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: app.fs
            Text {
                text: unikSettings.lang==='es'?'<b>Color de Unik actual: '+parseInt(unikSettings.currentNumColor+1)+'</b>':'<b>Current Unik Colors: '+parseInt(unikSettings.currentNumColor+1)+'</b>'
                font.pixelSize: app.fs
                color: app.c1
            }
        }
        Flow{
            id: gridPackColor
            spacing: app.fs*0.5
            anchors.horizontalCenter: parent.horizontalCenter
            width: r.width-app.fs
            //rows: 4
            Repeater{
                id:rep1
                Rectangle{
                    width: app.fs*4
                    height: width
                    border.width: unikSettings.currentNumColor===index&&!uf.visible?4:1
                    border.color: '#000'
                    color: 'transparent'
                    UnikFocus{id: uf; radius:0;visible: r.currentFocus===index}
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            r.currentFocus=index
                            unikSettings.currentNumColor=index
                            setColors()
                        }
                    }
                    Grid{
                        id: gridColors
                        spacing: app.fs*0.1
                        anchors.centerIn: parent
                        columns: 2
                        property var arr: modelData.split('-')
                        Rectangle{
                            width: app.fs*1.5
                            height: width
                            //border.width: 2
                            //border.color: app.c2
                            color: 'transparent'
                            Rectangle{
                                width: parent.width-2
                                height: parent.width-2
                                color: gridColors.arr[0]
                                anchors.centerIn: parent
                            }
                        }
                        Rectangle{
                            width: app.fs*1.5
                            height: width
                            //border.width: 2
                            //border.color: app.c2
                            color: 'transparent'
                            Rectangle{
                                width: parent.width-2
                                height: parent.width-2
                                color: gridColors.arr[1]
                                anchors.centerIn: parent
                            }
                        }
                        Rectangle{
                            width: app.fs*1.5
                            height: width
                            //border.width: 2
                            //border.color: app.c2
                            color: 'transparent'
                            Rectangle{
                                width: parent.width-2
                                height: parent.width-2
                                color: gridColors.arr[2]
                                anchors.centerIn: parent
                            }
                        }
                        Rectangle{
                            width: app.fs*1.5
                            height: width
                            //border.width: 2
                            //border.color: app.c2
                            color: 'transparent'
                            Rectangle{
                                width: parent.width-2
                                height: parent.width-2
                                color: gridColors.arr[3]
                                anchors.centerIn: parent
                            }
                        }
                    }
                    Component.onCompleted: r.cantColors++
                }
            }
        }
    }
    function run(){
        unikSettings.currentNumColor=r.currentFocus
        setColors()
    }
}
