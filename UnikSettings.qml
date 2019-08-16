import QtQuick 2.0
import Qt.labs.settings 1.0
import QtQuick.Window 2.0

Settings{
    id: appSettingsUnik
    category: 'conf-unik'
    property string lang
    property int currentNumColor
    property var defaultColors
    property bool sound
    property bool showBg
    property int numberRun
    property real zoom
    property real padding
    property int radius
    property int borderWidth
    property string fontFamily
    Component.onCompleted: {
        if(numberRun===0){
            lang='es'
            zoom=0.5
            appSettingsUnik.radius=Screen.width*0.02
            appSettingsUnik.borderWidth=Screen.width*0.005
            padding=0.5
            fontFamily='Arial'
            return
        }
        defaultColors='black-white-#666-#aaa|white-black-#aaa-#666|black-red-#ff6666-white|black-#ff6666-red-white|red-black-#ff6666-white|#ff2200-#ff8833-black-white|black-#ff8833-#ff3388-#ddcccc|#1fbc05-black-green-white|black-#1fbc05-white-green|green-white-red-blue'

        numberRun++
        var cPWS=pws
        if(Qt.platform.os!=='android'){
            var unikCfgFile=''+cPWS+'/unik-tools/unik/unik-cfg.json'
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
                    console.log('unik-cfg: '+json['themes']['colorThemes'])
                    var colors=json['themes']['colorThemes']
                    console.log('colors: '+colors)
                    console.log('colors length: '+Object.keys(colors).length)
                    for(var i=0;i<Object.keys(colors).length;i++){
                        var sc=''
                        sc+='|'+json['themes']['colorThemes'][i][0]
                        sc+='-'+json['themes']['colorThemes'][i][1]
                        sc+='-'+json['themes']['colorThemes'][i][2]
                        sc+='-'+json['themes']['colorThemes'][i][3]
                        console.log('sc'+i+': '+sc)
                        if(unikSettings.defaultColors.indexOf(sc)<0){
                            unikSettings.defaultColors+=sc
                        }
                    }
                    console.log('defaultColors: '+defaultColors)
                }
            }

        }

    }
}

