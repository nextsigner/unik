import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle{
    id: xUWarnings
    width: app.width-app.fs
    height:parent.height
    color: app.c2
    border.width: unikSettings.borderWidth
    border.color: app.c1
    visible: false
    clip: true
    property bool notShowAgain: false
    Connections {
        target: unik
        onUWarningChanged: {
            txtUWarnings.text+=''+unik.getUWarning()+'<br /><br />';
            if(!xUWarnings.notShowAgain){
                xUWarnings.visible=true
            }
        }
    }
    Flickable{
        id: flickUW
        width: parent.width-app.fs
        height: parent.height-app.fs
        contentWidth: width
        contentHeight: txtUWarnings.contentHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: app.fs
        ScrollBar.vertical: ScrollBar {
            parent: flickUW.parent
            anchors.top: flickUW.top
            anchors.topMargin: app.fs*4
            anchors.left: flickUW.right
            anchors.bottom: flickUW.bottom
        }
        Text {
            id: txtUWarnings
            text: unikSettings.lang==='es'?'<b>Unik Advertencias</b><br /><br />':'<b>Unik Warnings</b><br /><br />'
            font.pixelSize: app.fs
            color: app.c1
            width: parent.width-app.fs*3
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            onTextChanged: {
                if(flickUW.contentHeight>xUWarnings.height-app.fs){
                    flickUW.contentY=flickUW.contentHeight-flickUW.height
                }
            }
        }
    }
    Boton{//Close
        id: btnCloseXUWarning
        w:app.fs*3
        h: w
        t: "\uf00d"
        d:unikSettings.lang==='es'?'Cerrar':'Close'
        b:app.c2
        c: app.c1
        anchors.right: parent.right
        anchors.rightMargin: app.fs*0.5
        anchors.top: parent.top
        anchors.topMargin: app.fs*0.5
        onClicking: {
            xUWarnings.visible=false
        }
    }
    Boton{//Close for ever
        id: btnCloseXUWarningNotAgain
        w:app.fs*3
        h: w
        t: "\uf011"
        d:unikSettings.lang==='es'?'Cerrar - No mostrar mas':'Close - Not Show Again'
        b:app.c2
        c: app.c1
        anchors.right: btnCloseXUWarning.right
        anchors.top: btnCloseXUWarning.bottom
        anchors.topMargin: app.fs*0.5
        onClicking: {
            xUWarnings.notShowAgain=true
            xUWarnings.visible=false
        }
    }
    Boton{//Clear
        id: btnCloseXUWarningClear
        w:app.fs*3
        h: w
        t: "\uf12d"
        d:unikSettings.lang==='es'?'Limpiar':'Clear'
        b:app.c2
        c: app.c1
        anchors.right: btnCloseXUWarningNotAgain.right
        anchors.top: btnCloseXUWarningNotAgain.bottom
        anchors.topMargin: app.fs*0.5
        onClicking: {
            txtUWarnings.text=unikSettings.lang==='es'?'<b>Unik Advertencias</b><br /><br />':'<b>Unik Warnings</b><br /><br />'
        }
    }
}
