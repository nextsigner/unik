import QtQuick 2.0

Rectangle {
    id: r
    //z:r.parent.z-1
    width: parent.width//+unikSettings.borderWidth/2//+w
    height: parent.height
    anchors.centerIn: parent
    property var objFocus: parent
    property int w: unikSettings.borderWidth
    property color c: app.c3
    property string idSound
    color: 'transparent'
    border.width: unikSettings.borderWidth
    border.color: c
    radius: unikSettings.radius
    onVisibleChanged: {
        if(visible){
            app.objFocus=r.objFocus
            //mp.stop()
            /*if(!unik.fileExist(pws+'/unik-tools/unik/audio/'+r.idSound+'.m4a')){
                return
            }
            mp.source='file://'+pws+'/unik-tools/unik/audio/'+r.idSound+'.m4a'
            mp.play()*/
        }
    }
    Timer{
        running: parent.visible
        repeat: true
        interval: 500
        property int v: 0
        onTriggered: {
            if(v===0){
                parent.c=app.c2
                v++
            }else{
                parent.c=r.parent.border.color
                v=0
            }
        }
    }
}
