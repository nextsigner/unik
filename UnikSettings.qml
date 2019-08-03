import QtQuick 2.0
import Qt.labs.settings 1.0
import QtQuick.Window 2.0

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
    property int radius
    property int borderWidth
    Component.onCompleted: {
        appSettingsUnik.colors= [["black", "white", "#666", "#aaa"], ["white", "black", "#aaa", "#666"], ["black", "red", "#ff6666", "white"], ["red", "white", "#ff6666", "black"],["red", "black", "#ff6666", "white"], ["#ff8833", "black", "#ff9999", "white"],["black", "#ff8833", "white", "#ff9999"], ["#1fbc05", "black", "green", "white"], ["black", "#1fbc05", "white", "green"], ["green", "white", "red", "blue"]]
        if(numberRun===0){
            lang='es'
            zoom=0.5
            appSettingsUnik.radius=Screen.width*0.02
            appSettingsUnik.borderWidth=Screen.width*0.005
        }
        numberRun++
    }
}

