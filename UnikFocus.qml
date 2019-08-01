import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width+w
    height: parent.height+w
    anchors.centerIn: parent
    property var objFocus: r.parent
    property int w: app.fs*0.4
    property color c: 'red'
    color: 'transparent'
    border.width: w
    border.color: c
    radius: !r.parent.radius?app.fs*0.2:r.parent.radius
    onVisibleChanged: {
        if(visible)app.objFocus=r.objFocus
    }
}
