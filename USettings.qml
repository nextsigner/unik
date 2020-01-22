import QtQuick 2.0
Item{
    id: r
    property bool loaded: false
    property string url: 'conf-unik'
    property string lang: 'es'
    property int currentNumColor: 0
    property string defaultColors: 'black-white-#666-#aaa'
    property bool sound: false
    property bool showBg: false
    property int numberRun: 0
    property real zoom: 1.0
    property real padding: 1.0
    property int radius: 6
    property int borderWidth: 4
    property string fontFamily: 'Arial'
    signal dataChanged
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

    Component.onCompleted: {
        console.log('Archivo Unik Settings: '+r.url)
        if(!unik.fileExist(r.url)){
            console.log('Archivo Unik Settings inexistente.')
            setCfgFile()
        }else{
            console.log('Archivo Unik Settings existente.')
            getCfgFile()
        }
        numberRun++
        r.loaded=true
    }
    function getCfgFile(){
        //console.log('getCfgFile()...')
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
                r.loaded=false
                r.zoom = json['cfg'].zoom
                r.padding = json['cfg'].padding
                r.radius = json['cfg'].radius
                r.borderWidth = json['cfg'].borderWidth
                r.fontFamily = json['cfg'].fontFamily
                r.lang = json['cfg'].lang
                r.currentNumColor = json['cfg'].currentNumColor
                r.showBg = json['cfg'].showBg
                r.sound = json['cfg'].sound
                r.defaultColors = json['cfg'].defaultColors
            }
            r.loaded=true
        }else{
            var jsonCode='{"cfg":{"zoom":1.2,"padding":0.5,"radius":38,"borderWidth":2,"fontFamily":"Arial", "sound" : false, "showBg": true, "lang" : "es", "currentNumColor": 0, "defaultColors":"black-white-#666-#aaa|black-white-#aaa-#666|white-black-#aaa-#666|white-black-#666-#aaa|black-red-#ff6666-white|black-red-white-#ff6666|black-#ff6666-red-white|black-#ff6666-white-red|red-black-#ff6666-white|red-black-white-#ff6666|#ff2200-#ff8833-black-white|#ff2200-#ff8833-white-black|black-#ff8833-#ff3388-#ddcccc|black-#ff8833-#ddcccc-#ff3388|#1fbc05-black-green-white|#1fbc05-black-white-green|black-#1fbc05-white-green|black-#1fbc05-green-white|green-white-red-blue|green-white-blue-red" }}'
            unik.setFile(unikCfgFile, jsonCode)
            getCfgFile()
        }
    }

    function setCfgFile(){
        console.log('setCfgFile()...')
        var unikCfgFile=r.url
        //console.log('unikCfgFile: '+unikCfgFile)
        var unikCfgFileData=unik.getFile(unikCfgFile)
        console.log('1: url: '+r.url+' unikCfgFileData: '+unikCfgFileData)
        var json
        if(unikCfgFileData!=='error') {
            try {
                json = JSON.parse(unikCfgFileData);
            } catch(e) {
                console.log('Error when loading unik-cfg.json file: '+e)
            }
            if(json){
                json['cfg']={
                    zoom : r.zoom,
                    padding : r.padding,
                    radius: r.radius,
                    borderWidth: r.borderWidth,
                    fontFamily: r.fontFamily,
                    lang: r.lang,
                    currentNumColor: r.currentNumColor,
                    showBg: r.showBg,
                    sound: r.sound,
                    defaultColors: r.defaultColors
                }
                //console.log('Settings cfg file '+unikCfgFile+' \n'+JSON.stringify(json))
                unik.setFile(unikCfgFile, JSON.stringify(json))
                getCfgFile()
                //unik.setFile('/home/nextsigner/aaa.json', JSON.stringify(json))
            }
        }else{
            var jsonCode='{"cfg":{"zoom":1.2,"padding":0.5,"radius":38,"borderWidth":2,"fontFamily":"Arial", "sound" : false, "showBg": true, "lang" : "es", "currentNumColor": 0, "defaultColors":"black-white-#666-#aaa|black-white-#aaa-#666|white-black-#aaa-#666|white-black-#666-#aaa|black-red-#ff6666-white|black-red-white-#ff6666|black-#ff6666-red-white|black-#ff6666-white-red|red-black-#ff6666-white|red-black-white-#ff6666|#ff2200-#ff8833-black-white|#ff2200-#ff8833-white-black|black-#ff8833-#ff3388-#ddcccc|black-#ff8833-#ddcccc-#ff3388|#1fbc05-black-green-white|#1fbc05-black-white-green|black-#1fbc05-white-green|black-#1fbc05-green-white|green-white-red-blue|green-white-blue-red" }}'
            unik.setFile(unikCfgFile, jsonCode)
            getCfgFile()
            setCfgFile()
        }
        //if(r.loaded){
            r.dataChanged()
        //}
    }
}
