import QtQuick 2.0
import Qt.labs.settings 1.0

Settings{
    id: appSettingsUnik
    category: 'conf-unik'
    property string lang
    property int currentNumColor
    property var colors
    property bool sound
    property bool showBg
    property int numberRun
    property real zoom
    Component.onCompleted: {
        appSettingsUnik.colors= [["black", "white", "#666", "#aaa"], ["white", "black", "#aaa", "#666"], ["red", "black", "#ff6666", "white"], ["#ff3333", "black", "#ff9999", "white"], ["#1fbc05", "black", "green", "white"], ["black", "#1fbc05", "white", "green"]]
        if(numberRun===0){
            lang='es'
            zoom=0.5
        }
    }

}

