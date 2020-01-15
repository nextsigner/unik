import QtQuick 2.0
import Qt.labs.settings 1.0
import QtQuick.Window 2.0

Item{
    id: r
    property string url: 'conf-unik'
    property alias lang: appSettingsUnik.lang
    property alias currentNumColor: appSettingsUnik.currentNumColor
    property alias defaultColors: appSettingsUnik.defaultColors
    property alias sound: appSettingsUnik.sound
    property alias showBg: appSettingsUnik.showBg
    property alias numberRun: appSettingsUnik.numberRun
    property alias zoom: appSettingsUnik.zoom
    property alias padding: appSettingsUnik.padding
    property alias radius: appSettingsUnik.radius
    property alias borderWidth: appSettingsUnik.borderWidth
    property alias fontFamily: appSettingsUnik.fontFamily
    Settings{
        id: appSettingsUnik
        category: r.url
        property string lang
        property int currentNumColor
        property var defaultColors//: 'black-white-#666-#aaa|white-black-#aaa-#666|black-red-#ff6666-white|black-#ff6666-red-white|red-black-#ff6666-white|#ff2200-#ff8833-black-white|black-#ff8833-#ff3388-#ddcccc|#1fbc05-black-green-white|black-#1fbc05-white-green|green-white-red-blue'
        property bool sound
        property bool showBg
        property int numberRun
        property real zoom
        property real padding
        property int radius
        property int borderWidth
        property string fontFamily

        property bool loaded: false

        onCurrentNumColorChanged: {
            if(loaded){
                setCfgFile()
            }
        }
        onDefaultColorsChanged: {
            if(loaded){
                setCfgFile()
            }
        }
        onSoundChanged: {
            if(loaded){
                setCfgFile()
            }
        }
        onShowBgChanged: {
            if(loaded){
                setCfgFile()
            }
        }
        onZoomChanged: {
            if(loaded){
                setCfgFile()
            }
        }
        onPaddingChanged: {
            if(loaded){
                setCfgFile()
            }
        }
        onRadiusChanged: {
            if(loaded){
                setCfgFile()
            }
        }
        onBorderWidthChanged: {
            if(loaded){
                setCfgFile()
            }
        }
        onFontFamilyChanged: {
            if(loaded){
                setCfgFile()
            }
        }
    }
    Component.onCompleted: {
        if(r.url!=='conf-unik'){
            console.log('Archivo Unik Settings: '+r.url)
            if(!unik.fileExist(r.url)){
                console.log('Archivo Unik Settings inexistente.')
                setCfgFile()
            }else{
                console.log('Archivo Unik Settings existente.')
            }
            getCfgFile()
        }
        numberRun++
    }
    function getCfgFile(){
        console.log('getCfgFile()...')
        var unikCfgFile=r.url
        console.log('unikCfgFile: '+unikCfgFile)
        var unikCfgFileData=unik.getFile(unikCfgFile)
        console.log('unikCfgFileData: '+unikCfgFileData)
        var json
        if(unikCfgFileData!=='error') {
            try {
                json = JSON.parse(unikCfgFileData);
            } catch(e) {
                console.log('Error when loading unik-cfg.json file: '+e)
            }
            if(json){
                appSettingsUnik.zoom = json['cfg'].zoom
                appSettingsUnik.padding = json['cfg'].padding
                appSettingsUnik.radius = json['cfg'].radius
                appSettingsUnik.borderWidth = json['cfg'].borderWidth
                appSettingsUnik.fontFamily = json['cfg'].fontFamily
                appSettingsUnik.lang = json['cfg'].lang
                appSettingsUnik.currentNumColor = json['cfg'].currentNumColor
                appSettingsUnik.showBg = json['cfg'].showBg
                appSettingsUnik.sound = json['cfg'].sound
                appSettingsUnik.defaultColors = json['cfg'].defaultColors
            }
            appSettingsUnik.loaded=true
        }else{
            var jsonCode='{
"cfg":{"zoom":1.2,"padding":0.5,"radius":38,"borderWidth":2,"fontFamily":"Arial", "sound" : false, "showBg": true, "lang" : "es", "currentNumColor": 0, "defaultColors":"black-white-#666-#aaa|black-white-#aaa-#666|white-black-#aaa-#666|white-black-#666-#aaa|black-red-#ff6666-white|black-red-white-#ff6666|black-#ff6666-red-white|black-#ff6666-white-red|red-black-#ff6666-white|red-black-white-#ff6666|#ff2200-#ff8833-black-white|#ff2200-#ff8833-white-black|black-#ff8833-#ff3388-#ddcccc|black-#ff8833-#ddcccc-#ff3388|#1fbc05-black-green-white|#1fbc05-black-white-green|black-#1fbc05-white-green|black-#1fbc05-green-white|green-white-red-blue|green-white-blue-red" }
}
'
            unik.setFile(unikCfgFile, jsonCode)
             getCfgFile()
        }
    }

    function setCfgFile(){
        console.log('getCfgFile()...')
        var unikCfgFile=r.url
        console.log('unikCfgFile: '+unikCfgFile)
        var unikCfgFileData=unik.getFile(unikCfgFile)
        console.log('unikCfgFileData: '+unikCfgFileData)
        var json
        if(unikCfgFileData!=='error') {
            try {
                json = JSON.parse(unikCfgFileData);
            } catch(e) {
                console.log('Error when loading unik-cfg.json file: '+e)
            }
            if(json){
                json['cfg']={
                    zoom : appSettingsUnik.zoom,
                    padding : appSettingsUnik.padding,
                    radius: appSettingsUnik.radius,
                    borderWidth: appSettingsUnik.borderWidth,
                    fontFamily: appSettingsUnik.fontFamily,
                    lang: appSettingsUnik.lang,
                    currentNumColor: appSettingsUnik.currentNumColor,
                    showBg: appSettingsUnik.showBg,
                    sound: appSettingsUnik.sound,
                    defaultColors: appSettingsUnik.defaultColors
                }
                console.log('Settings cfg file '+unikCfgFile+' \n'+JSON.stringify(json))
                unik.setFile(unikCfgFile, JSON.stringify(json))
                unik.setFile('/home/nextsigner/aaa.json', JSON.stringify(json))
            }
        }else{
            var jsonCode='{
"cfg":{"zoom":1.2,"padding":0.5,"radius":38,"borderWidth":2,"fontFamily":"Arial", "sound" : false, "showBg": true, "lang" : "es", "currentNumColor": 0, "defaultColors":"black-white-#666-#aaa|black-white-#aaa-#666|white-black-#aaa-#666|white-black-#666-#aaa|black-red-#ff6666-white|black-red-white-#ff6666|black-#ff6666-red-white|black-#ff6666-white-red|red-black-#ff6666-white|red-black-white-#ff6666|#ff2200-#ff8833-black-white|#ff2200-#ff8833-white-black|black-#ff8833-#ff3388-#ddcccc|black-#ff8833-#ddcccc-#ff3388|#1fbc05-black-green-white|#1fbc05-black-white-green|black-#1fbc05-white-green|black-#1fbc05-green-white|green-white-red-blue|green-white-blue-red" }
}
'
            unik.setFile(unikCfgFile, jsonCode)
            setCfgFile()
        }
    }
}
