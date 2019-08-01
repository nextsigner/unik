import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

RadioButton {
    id: r
    text: "Radio Button"
    property int radio: app.fs*0.5
    style: RadioButtonStyle {
        indicator: Rectangle {
            implicitWidth: r.radio*2
            implicitHeight: r.radio*2
            radius: app.fs*0.5
            border.color: control.activeFocus ? app.c3 : app.c1
            border.width: app.fs*0.1
            color: 'transparent'
            Rectangle {
                anchors.fill: parent
                visible: control.checked
                color: app.c3
                radius: width*0.5
                anchors.margins: 4
                Rectangle {
                    width: parent.width-3
                    height: parent.height-3
                    anchors.centerIn: parent
                    color: app.c1
                    opacity: 0.75
                    radius: width*0.5
                    anchors.margins: 4
                }
            }
        }
    }
}
