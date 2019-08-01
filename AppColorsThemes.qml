import QtQuick 2.0

Rectangle{
    id:r
    width: app.fs*unikSettings.colors.length*2
    height: colColors.height+app.fs*2
    color:'#aaa'
    border.width: 2
    border.color: unikSettings.colors[unikSettings.currentNumColor][0]
    property alias showBtnClose: btnCloseACT.visible
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
    }
    Column{
        id: colColors
        spacing: app.fs*0.5
        anchors.centerIn: parent
        Repeater{
            id:rep1
            model: unikSettings.colors
            Rectangle{
                width: app.fs*unikSettings.colors.length+app.fs*0.5*unikSettings.colors.length-1
                height: app.fs*1.3
                border.width: 1
                border.color: '#000'
                color: 'transparent'
                Text {
                    text: "\uf00c"
                    font.family: "FontAwesome"
                    font.pixelSize: app.fs*0.5
                    anchors.right: parent.left
                    anchors.rightMargin: app.fs*0.2
                    anchors.verticalCenter: parent.verticalCenter
                    color: 'black'
                    visible: unikSettings.currentNumColor===index
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        unikSettings.currentNumColor=index
                        setColors()
                    }
                }
                Row{
                    id: rowColors
                    spacing: app.fs*0.5
                    anchors.centerIn: parent
                    Rectangle{
                        width: app.fs
                        height: width
                        border.width: 2
                        border.color: 'black'
                        color: 'transparent'
                        Rectangle{
                            width: parent.width-8
                            height: parent.width-8
                            color: unikSettings.colors[index][0]
                            anchors.centerIn: parent
                        }
                    }
                    Rectangle{
                        width: app.fs
                        height: width
                        border.width: 2
                        border.color: 'black'
                        color: 'transparent'
                        Rectangle{
                            width: parent.width-8
                            height: parent.width-8
                            color: unikSettings.colors[index][1]
                            anchors.centerIn: parent
                        }
                    }
                    Rectangle{
                        width: app.fs
                        height: width
                        border.width: 2
                        border.color: 'black'
                        color: 'transparent'
                        Rectangle{
                            width: parent.width-8
                            height: parent.width-8
                            color: unikSettings.colors[index][2]
                            anchors.centerIn: parent
                        }
                    }
                    Rectangle{
                        width: app.fs
                        height: width
                        border.width: 2
                        border.color: 'black'
                        color: 'transparent'
                        Rectangle{
                            width: parent.width-8
                            height: parent.width-8
                            color: unikSettings.colors[index][3]
                            anchors.centerIn: parent
                        }
                    }

                }
            }
        }
    }
}
