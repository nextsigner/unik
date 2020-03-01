import QtQuick 2.0

Rectangle {
    id: r
    anchors.fill: parent
    radius: parseInt(r.parent.radius)
    color: app.c1
    opacity: 0.5
    z:r.parent.z-1
}
