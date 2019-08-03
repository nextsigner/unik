import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width//+w
    height: parent.height//+w
    anchors.centerIn: parent
    property var objFocus: parent
    property int w: unikSettings.borderWidth
    property color c: unikSettings.colors[unikSettings.currentNumColor][2]
    color: 'transparent'
    border.width: unikSettings.borderWidth
    border.color: c
    radius: unikSettings.radius+unikSettings.borderWidth*2
    onVisibleChanged: {
        if(visible)app.objFocus=r.objFocus
    }
    Timer{
        running: parent.visible
        repeat: true
        interval: 500
        property int v: 0
        onTriggered: {
            if(v===0){
                parent.c=unikSettings.colors[unikSettings.currentNumColor][2]
                v++
            }else{
                parent.c=unikSettings.colors[unikSettings.currentNumColor][0]
                v=0
            }
        }
    }
}
