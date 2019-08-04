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
    //property string pws: pws
    Component.onCompleted: {
        if(numberRun===0){
            lang='es'
            zoom=0.5
            appSettingsUnik.radius=Screen.width*0.02
            appSettingsUnik.borderWidth=Screen.width*0.005
        }
        appSettingsUnik.colors= [["black", "white", "#666", "#aaa"], ["white", "black", "#aaa", "#666"], ["black", "red", "#ff6666", "white"], ["red", "white", "#ff6666", "black"],["red", "black", "#ff6666", "white"], ["#ff8833", "black", "#ff9999", "white"],["black", "#ff8833", "white", "#ff9999"], ["#1fbc05", "black", "green", "white"], ["black", "#1fbc05", "white", "green"], ["green", "white", "red", "blue"]]

        //appSettingsUnik.colors=[]

        var cPWS=pws
        if(Qt.platform.os!=='android'){
            var unikCfgFile=''+cPWS+'/unik-tools/unik-cfg.json'
            var unikCfgFileData=unik.getFile(unikCfgFile)
            console.log('unikCfgFile: '+unikCfgFile)
            console.log('unikCfgFileData: '+unikCfgFileData)
            var json
            if(unikCfgFileData!=='error') {
                try {
                    json = JSON.parse(unikCfgFileData);
                } catch(e) {
                    console.log('Error when loading unik-cfg.json file: '+e)
                }
                if(json){
                    /*console.log('unik-cfg: '+json['themes']['colorThemes'])
                    var arrColors=[]
                    arrColors.push("#ff3300")
                    arrColors.push("#ff0033")
                    arrColors.push("#00ff33")
                    arrColors.push("#330066")
                    //appSettingsUnik.colors.push(json['themes']['colorThemes'][0])
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["red", "red", "red", "red"]
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["red", "red", "red", "red"]
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["red", "red", "red", "red"]
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["red", "red", "red", "red"]
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["red", "red", "red", "red"]
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["red", "red", "red", "red"]
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["red", "red", "red", "red"]
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["red", "red", "red", "red"]
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["red", "red", "red", "red"]
                    appSettingsUnik.colors[appSettingsUnik.colors.length-1]=["yellow", "green", "blue", "pink"]*/
//                    appSettingsUnik.colors[1]=arrColors
//                    appSettingsUnik.colors[2]=arrColors
//                    appSettingsUnik.colors[3]=arrColors
//                    appSettingsUnik.colors[4]=arrColors
//                    appSettingsUnik.colors[5]=arrColors
                    //console.log('Themes: '+appSettingsUnik.colors)
                }
            }

        }
        numberRun++
    }
}

