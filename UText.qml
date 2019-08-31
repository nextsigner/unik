import QtQuick 2.0
Text{
    id:r
    property string fontFamily: unikSettings.fontFamily
    font.family: fontFamily
    font.pixelSize: app.fs
    color: app.c2
}
