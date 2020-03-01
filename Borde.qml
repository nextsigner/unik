import QtQuick 2.0

Rectangle {
    id: r
    anchors.fill: parent
    property int w: 1
    border.width: w
    border.color: app.c2
    radius: !r.parent.radius?app.fs*0.2:r.parent.radius
}
