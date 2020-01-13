import QtQuick 2.7
import QtQuick.Controls 2.12
import QtQuick.Window 2.2
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0
import QtMultimedia 5.0
ApplicationWindow {
    id: app
    objectName: 'awll'
    visibility:  Qt.platform.os !=='android'?"Maximized":"FullScreen"
    visible: true
    flags: Qt.platform.os !=='android'?Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint: undefined
    color: "transparent"
    //color: Qt.platform.os!=='android'?"transparent":app.c1
    //flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    //property int fs: width<height?(Qt.platform.os !=='android'?app.height*0.02*unikSettings.zoom:app.height*0.06*unikSettings.zoom):(Qt.platform.os !=='android'?app.height*0.06*unikSettings.zoom:app.width*0.03*unikSettings.zoom)
    property int fs: Qt.platform.os !=='android'?app.height*0.035*unikSettings.zoom:width<height?app.width*0.04*unikSettings.zoom:app.height*0.035*unikSettings.zoom
    property color c1: "#1fbc05"
    property color c2: "black"
    property color c3: "white"
    property color c4: "green"

    property bool prima: false
    property int sec: 0
    property int ci: 0
    property var al: []
    property string ca: ''
    property string uHoverCa: ''

    property var objFocus
    property bool downloading: false

    property string uSpeaked: ''

    //ColorAnimation on color { to: Qt.platform.os!=='android'?"transparent":app.c2; duration: 1000 }
    Connections {id: con1; target: unik;onUkStdChanged:log.setTxtLog(''+unik.ukStd);}
    Connections {id: con2; target: unik;onUkStdChanged: log.setTxtLog(''+unik.ukStd); }

    onCaChanged: {
        if(unikSettings.sound){
            let a=app.ca.replace('link_', '').replace('.ukl', '').replace(/-/g, '')
            let s=unikSettings.lang==='es'?'Ha seleccionado '+a+'. Presionar intro para iniciar':'Selecting  '+a+'. Press enter for run.'
            speak(s)
        }
    }

    onClosing: {
        if(Qt.platform.os==='android'){
            //close.accepted = false;
        }
    }
    onCiChanged: if(app.al[app.ci])app.ca=app.al[app.ci]
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Settings{
        id: appSettings
        category: 'conf-appsListLauncher'
        property string uApp
        property int runNumber
        onUAppChanged: {
            app.downloading=false
            xPb.opacity=0.0
        }
        Component.onCompleted: {
            //if(runNumber===0)sound=true
            runNumber++
        }
    }
    UnikSettings{
        id: unikSettings
        url:pws+'/launcher.json'
        onCurrentNumColorChanged: {
            if(unikSettings.sound&&currentNumColor>=0){
                let s=unikSettings.lang==='es'?'Color actual ':'Current color  '
                s+=parseInt(currentNumColor+1)
                speak(s)
            }
        }
        Component.onCompleted: {
            console.log('Seted... ')
            console.log('UnikColorTheme currentNumColor: '+unikSettings.currentNumColor)
            console.log('UnikColorTheme defaultColors: '+unikSettings.defaultColors)
            var nc=unikSettings.currentNumColor
            var cc1=unikSettings.defaultColors.split('|')
            var cc2=cc1[nc].split('-')
            app.c1=cc2[0]
            app.c2=cc2[1]
            app.c3=cc2[2]
            app.c4=cc2[3]
            app.visible=true
        }
    }
    FolderListModel{
        folder: Qt.platform.os!=='windows'?'file://'+appsDir:'file:///'+pws
        id: fl
        showDirs:  false
        showDotAndDotDot: false
        showHidden: false
        showOnlyReadable: true
        sortField: FolderListModel.Name
        nameFilters: "*.ukl"
        property int f: 0
        onCountChanged: {
            console.log('File: '+fl.get(f,"fileName"))
            f++
        }
    }
    Rectangle{
        anchors.fill: parent
        color: app.c2
        visible: Qt.platform.os!=='android'?unikSettings.showBg:false
    }
    Rectangle{
        id:xLauncher
        width: app.width-app.fs
        height:parent.height
        color: 'transparent'
        anchors.centerIn: parent
        focus: true
        /*Keys.onReturnPressed: {
            if(xConfig.opacity===0.0)run()
        }*/
        Rectangle{
            id:xP
            visible: false
            width:parent.width*0.33
            height: app.fs*0.125
            color: app.c2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: app.fs*2+app.fs*0.125+unikSettings.padding*2+unikSettings.borderWidth
            Behavior on opacity {NumberAnimation{duration: 1500}}
            Rectangle{
                id:psec
                width: 1
                height: parent.height
                color: 'red'
                onWidthChanged: {
                    if(psec.width===0){
                        xP.opacity=0.0
                    }else{
                        xP.opacity=1.0
                    }
                }
            }
        }

        Flickable{
            id:flick
            width: app.width
            height: app.height
            contentHeight: lv.height
            opacity:0.0
            Behavior on opacity{NumberAnimation{duration: 500}}
            Behavior on contentY{NumberAnimation{duration: 500}}
            ListView{
                id: lv
                visible: Qt.platform.os!=='android'?true:lv.count!==1
                spacing: (app.fs*unikSettings.padding)+2
                model:fl
                delegate: delegate
                width: app.width-app.fs*2
                height: (app.fs*2+app.fs*0.25)*lv.count
                anchors.horizontalCenter: parent.horizontalCenter
                onCurrentIndexChanged: {
                    console.log('UCurrentIndex: '+currentIndex)
                    flick.contentY=(app.fs*2+app.fs*0.25)*currentIndex-app.height/2
                }
            }
        }
        Component{
            id:delegate
            Rectangle{
                id:xItemP
                width:txt.contentWidth+app.fs*2
                height:  !btnDelete.visible?app.fs*2:btnDelete.height+4
                color: 'transparent'
                anchors.horizontalCenter: parent.horizontalCenter
                antialiasing: true
                Row{
                    id: rowLaunchItem
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    height: parent.height
                    spacing: app.fs*0.5*unikSettings.padding
                    BotonUX{
                        id: btnStart
                        text: unikSettings.lang==='es'?'Iniciar':'Start'
                        anchors.verticalCenter: parent.verticalCenter
                        visible: xItem.border.width!==0
                        onClicked: {
                            tlaunch.stop()
                            app.run()
                        }
                        UBg{opacity: 1.0}
                    }
                    Text {
                        text: '\uf061'
                        font.family: "FontAwesome"
                        font.pixelSize: app.fs
                        color:app.c2
                        anchors.verticalCenter: parent.verticalCenter
                        visible: xItem.border.width!==0
                    }
                    Rectangle{
                        id:xItem
                        width: txt.contentWidth+app.fs*2
                        height: app.fs*2
                        color: xItem.border.width!==0?app.c1:app.c2
                        radius: unikSettings.radius
                        border.width: fileName===app.ca?unikSettings.borderWidth:0
                        border.color: fileName===app.ca?app.c2:app.c1
                        anchors.verticalCenter: parent.verticalCenter
                        visible:(''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.ukl')>0
                        antialiasing: true
                        onColorChanged: {
                            if(xItem.border.width!==0){
                                if(app.al[index]){
                                    app.ca=app.al[index]
                                    lv.currentIndex=index
                                    psec.width=0
                                }
                            }
                        }
                        Rectangle{
                            id: borde
                            anchors.fill: parent
                            radius: parent.radius
                            border.width: unikSettings.borderWidth
                            border.color: xItem.border.width!==0?app.c2:app.c4
                            color: 'transparent'
                            antialiasing: true
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                app.ci=index
                                app.ca=fileName
                                lv.currentIndex=index
                                flick.contentY=(app.fs*2+app.fs*0.25)*index-app.height/2

                                if(tlaunch.running){
                                    tlaunch.stop()
                                    app.sec=0
                                    psec.width=0
                                }else{
                                    tlaunch.start()
                                }
                            }
                            onDoubleClicked: {
                                lv.currentIndex=index
                                flick.contentY=(app.fs*2+app.fs*0.25)*index-app.height/2

                                var mn=''
                                if(Qt.platform.os==='android'){
                                    mn='link_android-apps.ukl'
                                }else{
                                    mn='link_unik-tools.ukl'
                                }
                                if(fileName===mn){
                                    return
                                }
                                tlaunch.stop()
                                xConfig.opacity=1.0
                                xLinkEditor.visible=true
                                tiLinkFile.text=fileName.replace('link_', '').replace('.ukl', '')
                                //btnDelete.visible=true
                            }
                        }
                        UText {
                            id: txt
                            text: (''+fileName).substring(5, (''+fileName).length-4)
                            font.pixelSize: app.fs
                            color:xItem.border.width!==0?app.c2:app.c1
                            anchors.centerIn: parent
                        }
                        Timer{
                            running: true
                            repeat: true
                            interval: 250
                            onTriggered: {
                                if(xItem.border.width!==0){
                                    app.ci=index
                                }
                            }
                        }
                        Rectangle{
                            id: xTxtStatus
                            width: app.fs*10
                            height: txtStatus.contentHeight+app.fs
                            border.width: unikSettings.borderWidth
                            border.color: app.c2
                            color: app.c1
                            radius: unikSettings.radius/2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: statusIcon.width+app.fs
                            visible: false
                            antialiasing: true
                            UText {
                                id: txtStatus
                                width: parent.width-app.fs
                                wrapMode: Text.WordWrap
                                anchors.centerIn: parent
                            }
                        }
                        BotonUX{
                            id: btnDelete
                            text: unikSettings.lang==='es'?'Eliminar':'Delete'
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: xTxtStatus.right
                            anchors.leftMargin: app.fs
                            visible: xTxtStatus.visible
                            onClicked: {
                                app.al=[]
                                unik.deleteFile(pws+'/'+fileName)
                            }
                            UBg{opacity: 1.0}
                        }
                    }
                    Rectangle{
                        id: statusIcon
                        width: app.fs*1.2
                        height: app.fs*1.2
                        radius: width*0.5
                        border.width: unikSettings.borderWidth
                        border.color: app.c2
                        color: app.c1
                        visible: txtStatus.text!==''
                        antialiasing: true
                        anchors.verticalCenter: parent.verticalCenter
                        property string uHover: app.uHoverCa
                        onUHoverChanged: {
                            if(uHover!==fileName)xTxtStatus.visible=false
                        }
                        Timer{
                            id: tStatusIcon
                            running: false
                            repeat: false
                            interval: 5000
                            onTriggered: {
                                xTxtStatus.visible=false
                            }
                        }
                        Text{
                            text: '<b>!</b>'
                            color: app.c2
                            font.pixelSize: app.fs
                            anchors.centerIn: parent
                        }
                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                xTxtStatus.visible=true
                                tStatusIcon.restart()
                                app.uHoverCa=fileName
                            }
                            onExited: {
                                tStatusIcon.restart()
                            }
                        }
                    }
                }
                Component.onCompleted: {
                    app.al.push(fileName)
                    var folderMain=fileName.replace('link_','').replace('.ukl','')
                    var mainUrlPWS=pws+'/'+folderMain+'/main.qml'
                    var linkData=unik.getFile(pws+'/'+fileName)
                    if(!unik.fileExist(mainUrlPWS)&&linkData.indexOf('-git=')<0){
                        if(linkData.indexOf('-folder=')>=0){
                            var msg
                            var m0=linkData.split('\n')
                            var m1=m0[0].split('-folder=')
                            var m2=m1[1].split(' ')
                            console.log('Checking Item Launch folder exist: '+m2[0])
                            if(!unik.folderExist(m2[0])){
                                msg=unikSettings.lang==='es'?'La carpeta no existe':'Folder not found'
                                console.log('Item Launch folder no exist!')
                                txtStatus.text=msg
                                tlaunch.stop()
                                return
                            }else{
                                console.log('Item Launch folder exist!')
                                console.log('Checking Item main file exist: '+m2[0]+'/main.qml')
                                if(!unik.fileExist(m2[0]+'/main.qml')){
                                    console.log('Item Launch main file not exist!')
                                    msg=unikSettings.lang==='es'?'El archivo principal no existe':'Main file not exist'
                                    txtStatus.text=msg
                                    tlaunch.stop()
                                    return
                                }
                                console.log('Item Launch main file exist!')
                            }
                        }else{
                            msg=unikSettings.lang==='es'?'Faltan argumentos.':'Arguments not found.'
                            txtStatus.text=msg
                            tlaunch.stop()
                            return
                        }
                    }
                    if((''+fileName).indexOf('link')===0&&(''+fileName).indexOf('.json')>0&&!app.prima){
                        app.ca=app.al[index]
                        app.prima=true
                        tap.color='black'
                        xP.visible=true
                    }
                    if( tlaunch.enabled){
                        tinit.restart()
                    }
                }
            }
        }
        Rectangle{
            id: xConfig
            width: !visible?0:wmax
            height: colConfig.height+app.fs
            color: app.c1
            border.width: unikSettings.borderWidth
            border.color: app.c2
            radius: app.fs*0.25
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: xConfig.height<Screen.desktopAvailableHeight?0:xConfig.currentFocus<8?(xConfig.height-Screen.desktopAvailableHeight)/2:0-(xConfig.height-Screen.desktopAvailableHeight)/2
            anchors.horizontalCenter: parent.horizontalCenter
            visible: opacity!==0.0
            opacity: 0.0
            clip: true
            property int wmax:btnUX5.width+btnUX6.width+btnUX7.width+btnUX8.width<btnUX1.width+btnUX2.width+btnUX3.width+btnUX4.width? btnUX1.width+btnUX2.width+btnUX3.width+btnUX4.width+(btnUX7.width+app.fs*2):btnUX5.width+btnUX6.width+btnUX7.width+btnUX8.width+(btnUX7.width+app.fs*2)
            property int cantFocus: 13
            property int currentFocus: 1
            onVisibleChanged: {
                if(visible){
                    tlaunch.stop()
                    tinit.stop()
                }
            }
            onOpacityChanged:{
                tlaunch.stop()
                tinit.stop()
                if(opacity===0.0){
                    colConfig.opacity=0.0
                }
                if(opacity===1.0){
                    colConfig.opacity=1.0
                }
            }
            Behavior on width{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InExpo
                }
            }
            Behavior on opacity{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InExpo
                }
            }
            Column{
                id: colConfig
                anchors.centerIn: parent
                spacing: (app.fs*unikSettings.padding)+2
                opacity: parent.opacity===1.0?1.0:0.0
                onOpacityChanged:{
                    if(opacity===0.0)xConfig.opacity=0.0
                }
                Behavior on opacity{
                    NumberAnimation{
                        duration: 500;
                        easing.type: Easing.InOutBounce
                    }
                }
                Row{
                    id: rowBtnSettings
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: (app.fs*unikSettings.padding)+2
                    onWidthChanged: xConfig.width=xConfig.wmax
                    BotonUX{
                        id: btnUX1
                        UnikFocus{
                            visible: xConfig.currentFocus===1
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Tamaño de Letra. Para cambiar presinar intro.':'Font size . For change press enter.'
                                    speak(s)
                                }
                            }
                        }
                        text: unikSettings.lang==='es'?'Tamaño Letra '+parseFloat(unikSettings.zoom).toFixed(1):'Font Size '+parseFloat(unikSettings.zoom).toFixed(1)
                        onClicked: {
                            var uzoom=parseFloat(unikSettings.zoom).toFixed(1)
                            if(uzoom>0.5){
                                uzoom-=0.1
                            }else{
                                uzoom=1.2
                            }
                            unikSettings.zoom=uzoom.toFixed(1);
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Tamaño de letra ':'Font size '
                                s+=' '+parseFloat(unikSettings.zoom).toFixed(1);
                                speak(s)
                            }
                        }
                    }
                    BotonUX{
                        id: btnUX2
                        UnikFocus{
                            visible: xConfig.currentFocus===2
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Redondeado de borde del boton. Para cambiar presinar intro.':'Radius border of button . For change press enter.'
                                    speak(s)
                                }
                            }
                        }
                        text: unikSettings.lang==='es'?'Radio de Borde':'Border Radius'
                        onClicked: {
                            if(unikSettings.radius>app.fs*0.5){
                                unikSettings.radius-=app.fs*0.05
                            }else{
                                unikSettings.radius=app.fs*2
                            }
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Tamaño de radio de boton ':'Button Radius size '
                                s+=' '+parseInt(unikSettings.radius)
                                speak(s)
                            }
                        }
                    }
                    BotonUX{
                        id: btnUX3
                        UnikFocus{
                            visible: xConfig.currentFocus===3
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Ancho del borde del boton. Para cambiar presinar intro.':'Border with button . For change  press enter.'
                                    speak(s)
                                }
                            }
                        }
                        text: unikSettings.lang==='es'?'Ancho de Borde':'Width Radius'
                        onClicked: {
                            if(unikSettings.borderWidth>app.fs*0.05){
                                unikSettings.borderWidth-=app.fs*0.05
                            }else{
                                unikSettings.borderWidth=app.fs*0.5
                            }
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Ancho de borde de boton ':'Woth border of Button size '
                                s+=' '+parseInt(unikSettings.borderWidth)
                                speak(s)
                            }
                        }
                    }
                    BotonUX{
                        id: btnUX4
                        UnikFocus{
                            visible: xConfig.currentFocus===4
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Espacio interior del boton. Para cambier presinar intro.':'Space inside of button . For changespacing press enter.'
                                    speak(s)
                                }
                            }
                        }
                        text: unikSettings.lang==='es'?'Espacio':'Space'
                        onClicked: {
                            if(unikSettings.padding>0.1){
                                unikSettings.padding-=0.1
                            }else{
                                unikSettings.padding=1.0
                            }
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Espacio del interior del boton ':'Spacing of inside button  size '
                                s+=' '+parseInt(parseFloat(unikSettings.padding).toFixed(1)*100)
                                s+=unikSettings.lang==='es'?' por ciento ':' percent'
                                speak(s)
                            }
                        }
                    }
                }
                Row{
                    id: rowBtnSettings2
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: (app.fs*unikSettings.padding)+2
                    onWidthChanged: xConfig.width=xConfig.wmax
                    BotonUX{
                        text: unikSettings.lang==='es'?'Languaje':'Lenguaje'
                        onClicked: {
                            unikSettings.lang=unikSettings.lang==='es'?'en':'es'
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Lenguaje seleccionado Español.':'Languaje selected English. '
                                speak(s)
                            }
                        }
                        UnikFocus{
                            visible: xConfig.currentFocus===5
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Seleccionar idioma a ingles. Para cambiar presinar intro.':'Languaje change to Spanish . For change press enter.'
                                    speak(s)
                                }
                            }
                        }
                    }
                    BotonUX{
                        text: unikSettings.lang==='es'?'Sonido '+yesno:'Sound '+yesno
                        property string yes: unikSettings.lang==='es'?'SI':'YES'
                        property string no: unikSettings.lang==='es'?'NO':'NOT'
                        property string yesno: unikSettings.sound?yes:no
                        onClicked: {
                            unikSettings.sound=!unikSettings.sound
                            let s=''
                            if(unikSettings.sound){
                                s=unikSettings.lang==='es'?'Sonido activado ':'Sound enabled '
                            }else{
                                s=unikSettings.lang==='es'?'Sonido desactivado ':'Sound disabled '
                            }
                            speak(s)
                        }
                        UnikFocus{
                            visible: xConfig.currentFocus===6
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Desactivar sonidos. Para desactivar sonidos presionar intro.':'Disable sound . For to disable sounds press enter.'
                                    speak(s)
                                }
                            }
                        }
                    }
                    BotonUX{
                        UnikFocus{
                            visible: xConfig.currentFocus===7
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Fondo transparente. Para el tipo de fonde presinar intro.':'Transparent background . For change background mode press enter.'
                                    speak(s)
                                }
                            }
                        }
                        property string yes: unikSettings.lang==='es'?'SI':'YES'
                        property string no: unikSettings.lang==='es'?'NO':'NOT'
                        property string yesno: unikSettings.showBg?no:yes
                        text: unikSettings.lang==='es'?'Fondo Transparente '+yesno:'Transparent Background '+yesno
                        onClicked: {
                            unikSettings.showBg=!unikSettings.showBg
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Fondo transparente ':'Transparent background '
                                if(unikSettings.lang==='es'){
                                    s+=!unikSettings.showBg?' activado':'desactivado'
                                }else{
                                    s+=!unikSettings.showBg?' enabled':'disabled'
                                }
                                speak(s)
                            }
                        }
                    }
                    BotonUX{
                        id: btnUX8
                        UnikFocus{
                            id:ufBntFF;
                            visible: xConfig.currentFocus===8
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Tipo de Letra. Para seleccionar otro tipo de letra presinar intro.':'Font family . For change font family press enter.'
                                    speak(s)
                                }
                            }
                        }
                        text: unikSettings.lang==='es'?'Tipo de Letra':'Font Family'
                        onClicked: {
                            xFF.visible=true
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Seleccionar tipo de letra ':'Select font family '
                                speak(s)
                            }
                        }
                    }
                }
                AppColorsThemes{
                    id: appColorsThemes
                    anchors.horizontalCenter: parent.horizontalCenter
                    showBtnClose: false
                    currentFocus: ufACT.currentFocus
                    onCurrentFocusChanged: {
                        if(unikSettings.sound){
                            let s=unikSettings.lang==='es'?'Color seleccionado ':'Current color selected '
                            s+=parseInt(currentFocus+1)
                            s+=unikSettings.lang==='es'?'. Para usar esta combinación de color presionar Intro.':'. For use this color combination press enter.'
                            speak(s)
                        }
                    }
                    objectName: 'bbbb'
                    UnikFocus{
                        id: ufACT;
                        visible: xConfig.currentFocus===9
                        objectName: 'aaa'
                        property int currentFocus: -1
                        property int cantFocus: appColorsThemes.cantColors-1
                        onVisibleChanged: {
                            visible?currentFocus=0:currentFocus=-1
                            if(unikSettings.sound&&visible){
                                let s=unikSettings.lang==='es'?'Seleccionar colores.  Para cambiar ir hacia arriba. Para salir de la selección de colores ir hacia abajo.':'Colors selecction . For change color go to up. For exit of colors selection, go to down.'
                                speak(s)
                            }
                        }
                    }
                }
                Row{
                    id: rowBtnSettingsFoot
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: (app.fs*unikSettings.padding)+2
                    BotonUX{
                        id: btnUX9
                        UnikFocus{
                            visible: xConfig.currentFocus===10
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Editar enlace. Para editar o crear enlace presionar Intro.':'Edit or make. For edit or make press enter.'
                                    speak(s)
                                }
                            }
                        }
                        text: tiLinkFile.text!==''?unikSettings.lang==='es'?'Editar Enlace':'Link Edit':unikSettings.lang==='es'?'Crear Enlace':'Link Make'
                        onClicked: {
                            xLinkEditor.visible=true
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Crear o editar enlace de aplicación Unik.':'Make or edit link of unik application. '
                                speak(s)
                            }
                        }
                    }
                    BotonUX{
                        id: btnUX5
                        UnikFocus{
                            visible: xConfig.currentFocus===11
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Ver la ayuda. Para ver la ayuda presionar Intro.':'Show help. For show help press enter.'
                                    speak(s)
                                }
                            }
                        }
                        text: unikSettings.lang==='es'?'Ayuda':'Help'
                        onClicked: {
                            help.visible=true
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Mostrando la Ayuda.':'Showing Help. '
                                speak(s)
                            }
                        }
                    }
                    BotonUX{
                        id: btnUX6
                        text: unikSettings.lang==='es'?'Cerrar ':'Close'
                        onClicked: {
                            xConfig.opacity=0.0
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Cerrando configuración.':'Closing configuration. '
                                speak(s)
                            }
                        }
                        UnikFocus{
                            visible: xConfig.currentFocus===12
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Cerrar area de configuración. Para cerrar presionar Intro.':'Close configuration. For close configuration press enter.'
                                    speak(s)
                                }
                            }
                        }
                    }
                    BotonUX{
                        id: btnUX7
                        text: unikSettings.lang==='es'?'Cerrar Unik':'Close Unik'
                        onClicked:{
                            if(unikSettings.sound){
                                let s=unikSettings.lang==='es'?'Apagando Unik.':'Closing Unik. '
                                speak(s)
                            }
                            Qt.quit()
                        }
                        UnikFocus{
                            visible: xConfig.currentFocus===13
                            onVisibleChanged: {
                                if(unikSettings.sound&&visible){
                                    let s=unikSettings.lang==='es'?'Apagar Unik. Para apagar presionar Intro.':'Close Unik. For quit Unik press enter.'
                                    speak(s)
                                }
                            }
                        }
                    }
                }
            }
            Rectangle{
                id: xFF
                anchors.fill: parent
                border.width: parent.border.width
                border.color: parent.border.color
                color: parent.color
                visible: false
                antialiasing: true
                property var arrY: []
                onVisibleChanged: {
                    if(!visible){
                        xConfig.currentFocus--
                        tCloseFF.start()
                        ufCloseListFF.visible=false
                        lvFF.currentIndex=0
                    }else{
                        var un=lvFF.model.indexOf(unikSettings.fontFamily.replace(/"/g,''))
                        lvFF.currentIndex=un
                        //lvFF.contentY=xFF.arrY[un]
                    }
                }
                Timer{
                    id: tCloseFF
                    interval: 500
                    onTriggered: xConfig.currentFocus++
                }
                Column{
                    id: colXFF1
                    anchors.centerIn: parent
                    spacing: (app.fs*unikSettings.padding)+2
                    width: parent.width
                    Row{
                        id: rowFF1
                        z:rowFF2.z+1
                        spacing: app.fs*unikSettings.padding
                        height: btnUXCloseListFF.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        UText{
                            text: unikSettings.lang==='es'?'Tipo de Fuente Actual: '+unikSettings.fontFamily:'Current Font Family: '+unikSettings.fontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        BotonUX{
                            id: btnUXCloseListFF
                            UBg{opacity: 1.0}
                            UnikFocus{id: ufCloseListFF; visible:false}
                            text: unikSettings.lang==='es'?'Cerrar':'Close'
                            onClicked: {
                                xFF.visible=false
                            }
                        }
                    }
                    Row{
                        id:rowFF2
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: app.fs*2
                        Rectangle{
                            id: xTxtExample
                            width: xFF.width-lvFF.width-app.fs*6
                            height: xFF.height-rowFF1.height-colXFF1.spacing-app.fs
                            color: app.c1
                            border.width: unikSettings.borderWidth
                            border.color: app.c2
                            property string txt: unikSettings.lang==='es'?'Unik fue creado con el framework Qt Open Source.':'Unik was made with the framework Qt Open Source.'
                            Column{
                                anchors.centerIn: parent
                                spacing: app.fs*0.5*unikSettings.padding
                                Text {
                                    text: xTxtExample.txt
                                    color: app.c2
                                    width: xTxtExample.width*0.8
                                    height: contentHeight
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: app.fs*0.5
                                    font.family: unikSettings.fontFamily
                                }
                                Text {
                                    text: xTxtExample.txt
                                    color: app.c2
                                    width: xTxtExample.width*0.8
                                    height: contentHeight
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: app.fs
                                    font.family: unikSettings.fontFamily
                                }
                                Text {
                                    text: xTxtExample.txt
                                    color: app.c2
                                    width: xTxtExample.width*0.8
                                    height: contentHeight
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: app.fs*1.5
                                    font.family: unikSettings.fontFamily
                                }
                            }

                            Rectangle{
                                width: txtTitFFExample.contentWidth+app.fs*2
                                height: txtTitFFExample.contentHeight+app.fs*2
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: app.c1
                                border.width: unikSettings.borderWidth
                                border.color: app.c2
                                antialiasing: true
                                Text {
                                    id: txtTitFFExample
                                    text: unikSettings.lang==='es'?'Ejemplo de Texto':'Example Text'
                                    color: app.c2
                                    height: contentHeight
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: app.fs
                                    font.family: unikSettings.fontFamily
                                    anchors.centerIn: parent
                                }
                            }
                        }
                        ListView{
                            id: lvFF
                            width: app.fs*8
                            height: 1// xFF.height-btnUXCloseListFF.height-spacing-app.fs*unikSettings.padding
                            model: Qt.fontFamilies()
                            delegate: delFF
                            spacing: (app.fs*unikSettings.padding)+2
                            displayMarginBeginning: heightButton*4+spacing*4
                            displayMarginEnd: heightButton*4+spacing*4
                            anchors.verticalCenter: parent.verticalCenter
                            property int uCurrentIndex: currentIndex
                            property int heightButton:app.fs*2
                            onCurrentItemChanged: {
                                //y=currentIndex>uCurrentIndex?0-lvFF.height/2:lvFF.height/2
                                //uCurrentIndex=currentIndex
                                //                                var item = lvFF.i(currentIndex)
                                //                                console.log('XXXXXXXXXXXXXXXXXXXx'+item)
                                //                                lvFF.contentY=item.y
                            }
                            Component{
                                id: delFF
                                BotonUX{
                                    id: itemFF
                                    text: ''
                                    onClicked: unikSettings.fontFamily='"'+modelData+'"'
                                    width:example.contentWidth+app.fs*unikSettings.padding+app.fs
                                    height: example.contentHeight+app.fs*unikSettings.padding+app.fs
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    onYChanged: xFF.arrY[index]=itemFF.y
                                    UnikFocus{visible: lvFF.currentIndex===index}
                                    Text {
                                        id: example
                                        text: modelData
                                        font.family: modelData
                                        font.pixelSize: app.fs
                                        color: app.c2
                                        anchors.centerIn: parent
                                    }
                                    Component.onCompleted: {
                                        if(width>lvFF.width){
                                            lvFF.width=width+app.fs
                                        }
                                        xFF.arrY.push(itemFF.y)
                                        lvFF.heightButton=height
                                    }
                                }
                            }
                        }
                    }

                }
                Component.onCompleted: {
                    var un=lvFF.model.indexOf(unikSettings.fontFamily)
                    lvFF.currentIndex=un
                }
            }
            Rectangle{
                id: xLinkEditor
                width: parent.width
                height: parent.height
                color: app.c1
                border.width: unikSettings.borderWidth
                border.color: app.c2
                radius: app.fs*0.25
                visible: false
                property int currentFocus: -1
                property int uCurrentFocus: -1
                onVisibleChanged: {
                    if(visible){
                        currentFocus=0
                        //labelStatus.text=unikSettings.lang==='es'?'':''
                    }else{
                        currentFocus=-1
                        app.objFocus=btnUX9
                        labelStatus.text=''
                    }
                }
                onCurrentFocusChanged: {
                    if(!btnUXSetLink.visible&&currentFocus===2&&uCurrentFocus<currentFocus){
                        currentFocus++
                    }
                    if(!btnUXSetLink.visible&&currentFocus===2&&uCurrentFocus>currentFocus){
                        currentFocus--
                    }
                    uCurrentFocus=currentFocus
                }
                MouseArea{
                    anchors.fill: parent
                }
                Column{
                    anchors.centerIn: parent
                    spacing: app.fs*0.5
                    property int radius: unikSettings.radius/2
                    UText{
                        text: unikSettings.lang==='es'?'<b>Editor de Enlace</b>':'<b>Link Editor</b>'
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: app.fs*0.5
                        UText{
                            id: labelLE1
                            text: unikSettings.lang==='es'?'Enlace: ':'Link: '
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Rectangle{
                            border.width: unikSettings.borderWidth
                            border.color: app.c2
                            radius: unikSettings.radius
                            width: xLinkEditor.width*0.5
                            height: app.fs*2
                            color: app.c1
                            clip: true
                            anchors.verticalCenter: parent.verticalCenter
                            antialiasing: true
                            function run(){
                                xLinkEditor.currentFocus=btnUXSetLink?2:1
                            }
                            UnikFocus{
                                visible:xLinkEditor.currentFocus===0
                                onVisibleChanged: {
                                    if(visible){
                                        tiLinkFileContent.focus=false
                                        tiLinkFile.focus=true
                                        labelStatus.text=tiLinkFile.text===''?unikSettings.lang==='es'?'Escriba el nuevo nombre del enlace a crear.':'Write the new name for the new link to make.':unikSettings.lang==='es'?'Creando el enlace link_'+tiLinkFile.text+'.ukl':'Making the link link_'+tiLinkFile.text+'.ukl'
                                    }
                                }
                            }
                            TextInput{
                                id: tiLinkFile
                                focus: false
                                //text: app.ca.replace('link_','').replace('.ukl', '')
                                width: parent.width-app.fs
                                height: app.fs
                                color: app.c2
                                font.pixelSize: app.fs
                                anchors.centerIn: parent
                                maximumLength: 25
                                onFocusChanged: if(focus)xLinkEditor.currentFocus=0
                                onTextChanged: {
                                    var linkFileName=pws+'/link_'+tiLinkFile.text+'.ukl'
                                    var linkFileData=unik.getFile(linkFileName)
                                    if(unik.fileExist(linkFileName)){
                                        tiLinkFileContent.text=linkFileData
                                    }
                                    labelStatus.text=tiLinkFile.text===''?unikSettings.lang==='es'?'Escriba el nuevo nombre del enlace a crear.':'Write the new name for the new link to make.':unikSettings.lang==='es'?'Creando el enlace link_'+tiLinkFile.text+'.ukl':'Making the link link_'+tiLinkFile.text+'.ukl'
                                }
                            }
                        }
                        BotonUX{
                            id: btnUXSetLinkCancel
                            UnikFocus{
                                id: ufSetLinkCancel;
                                visible:xLinkEditor.currentFocus===1
                                onVisibleChanged: {
                                    if(visible){
                                        tiLinkFileContent.focus=false
                                        tiLinkFile.focus=false
                                        labelStatus.text=unikSettings.lang==='es'?'Cancelar y Cerrar el Editor de Enlace.':'Cancel and Close the Link Editor.'
                                    }
                                }
                            }
                            text: unikSettings.lang==='es'?'Cancelar':'Cancel'
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                xLinkEditor.visible=false
                            }
                        }
                        BotonUX{
                            id: btnUXSetLink
                            UnikFocus{
                                id: ufSetLink;
                                visible:xLinkEditor.currentFocus===2
                                onVisibleChanged: {
                                    if(visible){
                                        tiLinkFileContent.focus=false
                                        tiLinkFile.focus=false
                                        labelStatus.text=unikSettings.lang==='es'?'Hacer click o presionar retorno para crear este enlace.':'Click or press return for make this link.'
                                    }
                                }
                            }
                            text: unikSettings.lang==='es'?'Crear':'Make'
                            anchors.verticalCenter: parent.verticalCenter
                            visible: Qt.platform.os!=='android'?tiLinkFile.text!=='unik-tools'&&tiLinkFileContent.text!==''&&tiLinkFile.text!=='':tiLinkFile.text!=='android-apps'&&tiLinkFileContent.text!==''&&tiLinkFile.text!==''
                            onClicked: {
                                app.al=[]
                                appSettings.uApp='link_'+tiLinkFile.text+'.ukl'
                                var linkFileName=pws+'/link_'+tiLinkFile.text+'.ukl'
                                unik.setFile(linkFileName, tiLinkFileContent.text)
                                xLinkEditor.visible=false
                            }
                            Timer{
                                running: xLinkEditor.visible
                                repeat: true
                                interval: 500
                                onTriggered: {
                                    var linkFileName=pws+'/link_'+tiLinkFile.text+'.ukl'
                                    var linkFileData=unik.getFile(linkFileName)
                                    if(unik.fileExist(linkFileName)&&tiLinkFileContent.text!==linkFileData){
                                        btnUXSetLink.text=unikSettings.lang==='es'?'Modificar':'Modify'
                                    }else{
                                        btnUXSetLink.text=unikSettings.lang==='es'?'Crear':'Make'
                                    }
                                }
                            }
                        }
                    }
                    Rectangle{
                        border.width: unikSettings.borderWidth
                        border.color: app.c2
                        radius: unikSettings.radius
                        width: xLinkEditor.width-app.fs
                        height: app.fs*4
                        color: app.c1
                        anchors.horizontalCenter: parent.horizontalCenter
                        clip: true
                        antialiasing: true
                        function run(){
                            app.al=[]
                            appSettings.uApp='link_'+tiLinkFile.text+'.ukl'
                            app.ca=appSettings.uApp
                            var linkFileName=pws+'/link_'+tiLinkFile.text+'.ukl'
                            var folderMain=appSettings.uApp.replace('link_','').replace('.ukl','')
                            var mainUrl=pws+'/'+folderMain+'/main.qml'
                            var linkData=tiLinkFileContent.text
                            if(!unik.fileExist(mainUrl)&&tiLinkFileContent.text.indexOf('-git=')<0){
                                if(linkData.indexOf('-folder=')>=0){
                                    var msg
                                    var m0=linkData.split('\n')
                                    var m1=m0[0].split('-folder=')
                                    var m2=m1[1].split(' ')
                                    console.log('Checking Editor Launch folder exist: '+m2[0])
                                    if(!unik.folderExist(m2[0])){
                                        labelStatus.text=unikSettings.lang==='es'?'La carpeta no existe':'Folder not found'
                                        console.log('Editor Launch folder not exist!')
                                        return
                                    }else{
                                        console.log('Editor Launch folder exist!')
                                        console.log('Checking Editor main file exist: '+m2[0]+'/main.qml')
                                        if(!unik.fileExist(m2[0]+'/main.qml')){
                                            console.log('Editor Launch main file not exist!')
                                            labelStatus.text=unikSettings.lang==='es'?'El archivo principal no existe':'Main file not exist'
                                            return
                                        }
                                        console.log('Editor Launch main file exist!')
                                        unik.setFile(linkFileName, tiLinkFileContent.text)
                                        xLinkEditor.visible=false
                                        xConfig.opacity=0.0
                                        tlaunch.start()
                                    }
                                }else{
                                    msg=unikSettings.lang==='es'?'Faltan argumentos.':'Arguments not found.'
                                    txtStatus.text=msg
                                    tlaunch.stop()
                                    return
                                }
                            }else{
                                if(unik.fileExist(mainUrl)&&tiLinkFileContent.text.indexOf('-folder=')<0&&tiLinkFileContent.text.indexOf('-git=')<0){
                                    labelStatus.text=unikSettings.lang==='es'?'Se requiere el argumento -folder=<Carpeta de archivo main.qml>\nPor ejemplo: C:/miApp/':'The argument is required -folder=<Folder to main.qml file>\nFor example: C:/myApp/'
                                }else if(tiLinkFileContent.text.indexOf('-folder=')<0){
                                    unik.setFile(linkFileName, tiLinkFileContent.text+' -folder='+pws+'/'+folderMain)
                                    xLinkEditor.visible=false
                                    xConfig.opacity=0.0
                                    tlaunch.start()
                                }else if(tiLinkFileContent.text.indexOf('-folder=')>=0){
                                    var m0=tiLinkFileContent.text.split('\n')
                                    var m1=m0[0].split('-folder=')
                                    var m2=m1[1].split(' ')
                                    if(!unik.folderExist(m2[0])){
                                        labelStatus.text=unikSettings.lang==='es'?'La carpeta no existe':'Folder not found'
                                    }else{
                                        if(!unik.fileExist(m2[0]+'/main.qml')){
                                            labelStatus.text=unikSettings.lang==='es'?'El archivo principal no existe':'Main file not exist'
                                            //return
                                        }else{
                                            unik.setFile(linkFileName, tiLinkFileContent.text)
                                            xLinkEditor.visible=false
                                            xConfig.opacity=0.0
                                            tlaunch.start()
                                        }
                                    }
                                }else{
                                    unik.setFile(linkFileName, tiLinkFileContent.text)
                                    xLinkEditor.visible=false
                                    xConfig.opacity=0.0
                                    tlaunch.start()
                                }
                            }
                        }
                        UnikFocus{
                            visible:xLinkEditor.currentFocus===3
                            onVisibleChanged: {
                                if(visible){
                                    tiLinkFile.focus=false
                                    tiLinkFileContent.focus=true
                                    labelStatus.text=unikSettings.lang==='es'?'Presionar Intro para lanzamiento rápido.':'Press Return for a Quick Launch'
                                }
                            }
                        }
                        TextInput{
                            id: tiLinkFileContent
                            width: parent.width-app.fs
                            height: parent.height-app.fs
                            wrapMode: Text.WordWrap
                            color: app.c2
                            font.pixelSize: app.fs
                            anchors.centerIn: parent
                            maximumLength: 500
                            onFocusChanged: if(focus)xLinkEditor.currentFocus=3
                        }
                    }
                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: app.fs*0.5
                        UText{
                            id: labelStatus
                            width: xLinkEditor.width-btnUXDelLink.width-app.fs*2
                            wrapMode: Text.WordWrap
                        }
                        BotonUX{
                            id: btnUXDelLink
                            UnikFocus{
                                id: ufDelLink;
                                visible:xLinkEditor.currentFocus===4
                                onVisibleChanged: {
                                    if(visible){
                                        tiLinkFileContent.focus=false
                                        tiLinkFile.focus=false
                                        labelStatus.text=unikSettings.lang==='es'?'Eliminar este enlace.':'Delete this link.'
                                    }
                                }
                            }
                            text: unikSettings.lang==='es'?'Eliminar':'Delete'
                            anchors.verticalCenter: parent.verticalCenter
                            visible: Qt.platform.os!=='android'?tiLinkFile.text!=='unik-tools'&&tiLinkFileContent.text!==''&&tiLinkFile.text!=='':tiLinkFile.text!=='android-apps'&&tiLinkFileContent.text!==''&&tiLinkFile.text!==''
                            onClicked: {
                                app.al=[]
                                var linkFileName=pws+'/link_'+tiLinkFile.text+'.ukl'
                                unik.deleteFile(linkFileName)
                                tiLinkFile.text=''
                                tiLinkFileContent.text=''
                            }
                        }
                    }
                }
            }
        }
        Text {
            text: '\uf061'
            font.family: "FontAwesome"
            font.pixelSize: app.fs*2
            color:app.c2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: app.fs*2
            anchors.left: parent.left
            anchors.leftMargin: app.fs*0.5
            opacity: xConfig.opacity===0.0&&!help.visible?1.0:0.0
            rotation: -180
            z:flick.z+1
            Behavior on opacity{NumberAnimation{duration: 500}}
            BotonUX{
                text: unikSettings.lang==='es'?'Configurar':'Config'
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.left
                anchors.rightMargin: app.fs
                rotation: -180
                onClicked: {
                    tlaunch.stop()
                    xConfig.opacity=1.0
                }
                UBg{opacity: 1.0}
            }
        }
        Rectangle{
            id: help
            visible: false
            width: parent.width
            height: parent.height
            color: app.c1
            border.width: unikSettings.borderWidth
            border.color: app.c2
            anchors.centerIn: parent
            clip: true
            antialiasing: true
            Flickable{
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: txtHelp.height+app.fs*2
                Text {
                    id: txtHelp
                    text: unikSettings.lang==='es'?h1:h2
                    font.pixelSize: app.fs
                    font.family: unikSettings.fontFamily
                    color: app.c2
                    width: parent.width-app.fs*2
                    textFormat: Text.RichText
                    horizontalAlignment: Text.AlignHCenter
                    property string h1
                    property string h2
                    Component.onCompleted: {
                        h1='<h1>Ayuda de Unik Launcher</h1><p><b>Teclas de Navegaciòn</b></p><ul><li>Izquierda: Salir o Retroceder</li><li>Derecha: Entrar o Ejecutar</li><li>Arriba: Navega entrando a areas</li><li>Abajo: Navega saltando areas</li><li>Escape: Escape, cierre o apagado</li><li>Intro: Entrar o Ejecutar</li></ul><p>Màs informaciòn sobre Unik:</p><p>Unik fue creado gracias a Qt Open Source bajo las licencias LGPL. Màs informaciòn en <a href="http://www.qt.io">qt.io</a><</p></p><p>Sitio Web: www.unikode.org</p><p>Correo Electrònico: nextsigner@gmail.com</p><p>Whatsapp: +541138024370</p><p><b>GitHub: </b>https://github.com/nextsigner/unik</p><p><b>Donaciones: </b>patreon.com/unik</p>'

                        h2='<h1>Unik Launcher Help</h1><p><b>Keyboard Navigation</b></p><ul><li>Left: Quit or Back</li><li>Right: Get in or Run</li><li>Up: Navigate getting to area</li><li>Down: Navigate jumping to area</li><li>Escape: Escape, close or quit</li><li>Enter: Get in or Run</li></ul><p>About Unik:</p><p>Unik was made with Qt Open Source under LGPL licence. More information in <a href="http://www.qt.io">qt.io</a><</p><p>Web Site: www.unikode.org</p><p>E-Mail: nextsigner@gmail.com</p><p>Whatsapp: +541138024370</p><p><b>GitHub: </b>https://github.com/nextsigner/unik</p><p><b>Donate: </b>patreon.com/unik</p>'
                    }
                }
            }
            Boton{//Close
                id: btnCloseACT
                w:app.fs*2
                h: w
                t: "\uf00d"
                d:unikSettings.lang==='es'?'Cerrar':'Close'
                b:app.c1
                c: app.c2
                anchors.right: parent.right
                anchors.rightMargin: app.fs
                anchors.top: parent.top
                anchors.topMargin: app.fs
                onClicking: {
                    help.visible=false
                }
            }
        }

        Rectangle{
            id: xPb
            opacity: 0.0
            width: Screen.desktopAvailableWidth<Screen.desktopAvailableHeight ? Screen.desktopAvailableWidth*0.95 : Screen.desktopAvailableHeight*0.95
            height: titDownloadLog.contentHeight+log.contentHeight+pblaunch.height+app.fs
            anchors.centerIn: parent
            color: app.c1
            //radius: unikSettings.radius
            border.width: unikSettings.borderWidth
            border.color: app.c2
            clip:true
            antialiasing: true
            Behavior on opacity{
                NumberAnimation{duration: 1000}
            }
            Column{
                id: colDownloadLog
                anchors.centerIn: parent
                spacing: app.fs*0.5
                Text{
                    id: titDownloadLog
                    color: app.c2
                    width: app.width<app.height ? app.width*0.9 : app.height*0.9
                    height: contentHeight
                    wrapMode: Text.WordWrap
                    font.pixelSize: app.fs
                    horizontalAlignment: Text.AlignHCenter
                    text: unikSettings.lang==='es'?'<b>Descargando '+app.ca+'</b>':'<b>Downloading '+app.ca+'</b>'
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text{
                    id: log
                    color: app.c2
                    width: app.width<app.height ? app.width*0.9 : app.height*0.9
                    height: contentHeight
                    wrapMode: Text.WordWrap
                    font.pixelSize: app.fs*0.5
                    horizontalAlignment: Text.AlignHCenter
                    function setTxtLog(t){
                        var  d=(''+t).replace(/\n/g, ' ')
                        var p=true
                        if(d.indexOf('Socket')>=0){
                            p=false
                        }else if(d.indexOf('download git')>=0){
                            var m0=''+d.replace('download git ','')
                            var m1=m0.split(' ')
                            if(m1.length>1){
                                var m2=(''+m1[1]).replace('%','')
                                //unik.setFile('/home/nextsigner/nnn', ''+m2)
                                var m3=parseInt(m2.replace(/ /g,''))
                                pblaunch.width=pblaunch.parent.width/100*m3
                            }

                        }
                        if(p){
                            log.text=t
                        }
                    }
                }

                Rectangle{
                    id:pblaunch
                    height: app.fs*0.5
                    width: 0
                    color: 'red'
                }
            }

            Boton{//Close
                id: btnCloseDownload
                w:app.fs
                h: w
                t: "\uf00d"
                d:unikSettings.lang==='es'?'Cerrar':'Close'
                b:app.c1
                c: app.c2
                anchors.right: parent.right
                anchors.rightMargin: app.fs*0.5
                anchors.top: parent.top
                anchors.topMargin: app.fs*0.5
                onClicking: {
                    xPb.visible=false
                }
            }
        }
    }
    Shortcut{
        sequence: 'Return'
        onActivated: {
            if(xConfig.opacity===0.0){
                tlaunch.stop()
                app.run()
            }else{
                /*if(ufACT.visible&&xConfig.currentFocus===6){
                    return
                }*/

                if(!ufACT.visible){
                    app.objFocus.run()
                }else{
                    console.log('objFocus objectName:'*appColorsThemes.objectName)
                    appColorsThemes.run()
                }

            }
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(xLinkEditor.visible){
                if(tiLinkFile.focus){
                    tiLinkFile.focus=false
                    xLinkEditor.currentFocus=1
                }else if(tiLinkFileContent.focus){
                    tiLinkFileContent.focus=false
                    xLinkEditor.currentFocus=1
                }else{
                    xLinkEditor.visible=false
                }
                return
            }
            if(xFF.visible){
                xFF.visible=false
                return
            }
            if(help.visible){
                help.visible=false
                return
            }
            if(xConfig.opacity===1.0&&colConfig.opacity===1.0){
                colConfig.opacity=0.0
                return
            }
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {
            tinit.stop()
            tlaunch.stop()
            if(xLinkEditor.visible){
                xLinkEditor.visible=false
                return
            }
            if(xFF.visible){
                lvFF.currentIndex--
                return
            }
            if(xConfig.opacity===0.0){
                tlaunch.stop()
                xConfig.opacity=1.0
                return
            }
            if(xConfig.width!==0&&ufACT.visible&&appColorsThemes.currentFocus===0){
                xConfig.currentFocus--
                return
            }else{
                if(xConfig.width!==0&&ufACT.visible&&appColorsThemes.currentFocus!==0){
                    appColorsThemes.currentFocus--
                    return
                }
            }
            if(help.visible){
                help.visible=false
                return
            }
            if(xConfig.opacity===1.0){
                colConfig.opacity=0.0
                return
            }
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
            if(xLinkEditor.visible){
                if(xLinkEditor.currentFocus<4){
                    xLinkEditor.currentFocus++
                }else{
                    xLinkEditor.currentFocus=1
                }
                console.log('UCurrentFocus xLinkEditor: '+xLinkEditor.currentFocus)
                return
            }
            if(xFF.visible&&!ufCloseListFF.visible){
                ufCloseListFF.visible=true
                return
            }
            if(xFF.visible&&ufCloseListFF.visible){
                ufCloseListFF.visible=false
                return
            }
            tlaunch.stop()
            xP.opacity=0.0
            if(xConfig.opacity!==1.0){
                tlaunch.stop()
                app.run()
            }else{
                if(xConfig.currentFocus<xConfig.cantFocus){
                    xConfig.currentFocus++
                }else{
                    xConfig.currentFocus=1
                }
            }
        }
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(xLinkEditor.visible){
                if(xLinkEditor.currentFocus<4){
                    xLinkEditor.currentFocus++
                }else{
                    xLinkEditor.currentFocus=0
                }
                console.log('UCurrentFocus xLinkEditor: '+xLinkEditor.currentFocus)
                return
            }
            if(xConfig.opacity===0.0){
                if(app.ci<app.al.length-1){
                    app.ci++
                }else{
                    app.ci=0
                }
                tlaunch.stop()

                if(unikSettings.sound){
                    var uModuleName=app.al[app.ci].replace('link_', '').replace('.ukl', '')
                    var selMsg = unikSettings.lang==='es'?'Seleccionando ':'Selecting '
                    unik.speak((selMsg+uModuleName).replace(/-/g, ' ').replace(/_/g, ' '))
                }
            }else{
                console.log('CurrentFocus: '+xConfig.currentFocus)
                if(xFF.visible){
                    lvFF.currentIndex++
                    return
                }
                if(xConfig.currentFocus<xConfig.cantFocus){
                    xConfig.currentFocus++
                }else{
                    xConfig.currentFocus=1
                }

            }
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            if(xLinkEditor.visible){
                if(xLinkEditor.currentFocus>0){
                    xLinkEditor.currentFocus--
                }else{
                    xLinkEditor.currentFocus=4
                }
                console.log('UCurrentFocus xLinkEditor: '+xLinkEditor.currentFocus)
                return
            }
            if(xConfig.opacity===0.0){
                if(app.ci>0){
                    app.ci--
                }else{
                    app.ci=app.al.length-1
                }
                tlaunch.stop()

                if(unikSettings.sound){
                    var uModuleName=app.al[app.ci].replace('link_', '').replace('.ukl', '')
                    var selMsg = unikSettings.lang==='es'?'Seleccionando ':'Selecting '
                    unik.speak((selMsg+uModuleName).replace(/-/g, ' ').replace(/_/g, ' '))
                }
            }else{
                if(xFF.visible){
                    lvFF.currentIndex--
                    return
                }
                console.log('CurrentFocus: '+xConfig.currentFocus)
                if(!ufACT.visible){
                    if(xConfig.currentFocus>1){
                        xConfig.currentFocus--
                    }else{
                        xConfig.currentFocus=xConfig.cantFocus
                    }
                }else{
                    if(ufACT.currentFocus>0){
                        ufACT.currentFocus--
                    }else{
                        ufACT.currentFocus=ufACT.cantFocus
                    }
                }
            }
        }
    }
    Shortcut{
        sequence: 'r'
        onActivated: {
            speak(app.uSpeaked)
        }
    }
    Rectangle{
        id:tap
        anchors.fill: parent
        color: 'transparent'
        opacity:0.0
        Behavior on opacity{NumberAnimation{duration:500}
        }
    }
    Timer{
        id: tinit
        running: true
        repeat: false
        interval: 1000
        onTriggered: {
            tap.opacity=0.0
            if(appSettings.uApp===''&&app.al.length>0){
                appSettings.uApp=app.al[0]
            }
            var vacio=true
            for(var i=0;i<app.al.length;i++){
                if((''+app.al[i]).indexOf('.ukl')>0){
                    //app.visible=true
                    vacio=false
                }
                if(appSettings.uApp===app.al[i]){
                    app.ca=app.al[i]
                }
            }
            if(vacio){
                tlaunch.enabled=false
                tlaunch.stop()
                app.close()
                engine.load(appsDir+'/unik-tools/main.qml')
            }else{
                xP.visible=true
            }
            flick.opacity=1.0
            if(unikSettings.sound){
                let a=app.ca.replace('link_', '').replace('.ukl', '').replace(/-/g, ' ')
                let s=unikSettings.lang==='es'?'Preparando el inicio de '+a:'Preparing the star of '+a
                speak(s)
            }
        }

    }
    Timer{
        id: tlaunch
        running: Qt.platform.os!=='android'
        repeat: true
        interval: 1000
        property bool enabled: true
        onTriggered: {
            if(lv.count===1&&Qt.platform.os==='android'){
                app.run()
                return
            }
            app.sec++
            if(app.sec===7){
                stop()
                app.run()
            }
            if(app.sec>7){
                app.sec=0
            }
            psec.width=psec.parent.width/5*(app.sec-1)
        }
    }
    Rectangle{
        id: xSplashBlanco
        visible: Qt.platform.os==='android'
        anchors.fill: parent
        //color: app.c1
        onOpacityChanged: {
            if(opacity===0.0&&xConfig.opacity===0)tlaunch.start()
        }
        Behavior on opacity {
            NumberAnimation{duration: 3000}
        }
        //ColorAnimation on color { to: app.c2; duration: 2000 }
        Image {
            id: splashBlanco
            source: Qt.platform.os==='android'?"assets:/splash.png":"logo.png"
            width: parent.width*0.25
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            opacity: 0.0
            onOpacityChanged: {
                if(opacity===1.0)xSplashBlanco.opacity=0.0
            }
            Behavior on opacity {
                NumberAnimation{duration: 500}
            }

        }
    }

    Component.onCompleted:{
        splashBlanco.opacity=1.0
        if(Qt.platform.os==='android'){
            unik.debugLog=true
        }
        var ml = (''+ttsLocales).split(',')
        for(var i=0; i < ml.length;i++){
            if(unikSettings.lang==='es'){
                if(ml[i].indexOf('Spanish')>=0){
                    unik.ttsLanguageSelected(i)
                    //console.log('::::::::::::::::::::::::::'+ml[i])
                    break
                }
            }else{
                if(ml[i].indexOf('English')>=0){
                    unik.ttsLanguageSelected(i)
                    //console.log('::::::::::::::::::::::::::'+ml[i])
                    break
                }
            }
        }
        if(Qt.platform.os!=='android'){
            unik.ttsVoiceSelected(0)
        }
    }
    function setColors(){
        var nc=unikSettings.currentNumColor
        var cc1=unikSettings.defaultColors.split('|')
        var cc2=cc1[nc].split('-')
        app.c1=cc2[0]
        app.c2=cc2[1]
        app.c3=cc2[2]
        app.c4=cc2[3]
    }
    function run(){
        if(unikSettings.sound){
            let a=app.ca.replace('link_', '').replace('.ukl', '').replace(/-/g, '')
            let s=unikSettings.lang==='es'?'Iniciando .'+a:'Starting '+a
            unik. speak(s)
        }
        appSettings.uApp=app.ca
        var p=unik.getFile(appsDir+'/'+app.ca)
        var args=(''+p).split(' ')
        var params=''
        for(var i=0; i<args.length;i++){
            if(i===0){
                params+=args[i]
            }else{
                params+=','+args[i]
            }
        }
        console.log('Launching '+appSettings.uApp+'...')

        var m0
        var m1
        var m2
        var mn

        if(Qt.platform.os==='android'){
            if(params.indexOf('-git=')>=0&&params.indexOf('-git=')!==params.length-1&&params.length>5){
                app.downloading=true
                m0=params.split('-git=')
                m1=m0[1].split(',')
                m2=m1[0].split('/')
                mn=m2[m2.length-1].replace(/.git/g, '')

                unik.cd(pws)
                unik.mkdir(pws+'/'+mn)
                xPb.opacity=1.0
                var d = unik.downloadGit(m1[0], pws)
                if(app.downloading){
                    unik.cd(pws+'/'+mn)
                    engine.load(pws+'/'+mn+'/main.qml')
                    app.close()
                    return
                }
            }
            if(params.indexOf('-zip=')>=0&&params.indexOf('-zip=')!==params.length-1&&params.length>5){
                m0=params.split('-zip=')
                m1=m0[1].split(',')
                m2=m1[0].split('/')
                mn=m2[m2.length-1].replace(/.zip/g, '')

                unik.cd(pws)
                unik.mkdir(pws+'/'+mn)
                var d = unik.runAppFromZip(m1[0], pws)
                unik.cd(pws+'/'+mn)
                engine.load(pws+'/'+mn+'/main.qml')
                app.close()
                return

            }

            if(params.indexOf('-folder=')>=0&&params.indexOf('-folder=')!==params.length-1&&params.length>5){
                m0=params.split('-folder=')
                m1=m0[1].split(',')
                m2=m1[0].split('/')
                mn=m2[m2.length-1]

                unik.cd(pws)
                unik.mkdir(pws+'/'+mn)
                engine.load(pws+'/'+mn+'/main.qml')
                app.close()
                return
            }
        }else{
            if(params.indexOf('-git=')>=0&&params.indexOf('-git=')!==params.length-1&&params.length>5){
                app.downloading=true
                m0=params.split('-git=')
                m1=m0[1].split(',')
                m2=m1[0].split('/')
                mn=m2[m2.length-1].replace(/.git/g, '')

                unik.cd(pws)
                unik.mkdir(pws+'/'+mn)
                xPb.opacity=1.0
                var d = unik.downloadGit(m1[0], pws)
                if(app.downloading){
                    unik.ejecutarLineaDeComandoAparte(unik.getPath(0)+' -folder='+pws+'/'+mn)
                    Qt.quit()
                    return
                }
            }
            if(params.indexOf('-zip=')>=0&&params.indexOf('-zip=')!==params.length-1&&params.length>5){
                m0=params.split('-zip=')
                m1=m0[1].split(',')
                m2=m1[0].split('/')
                mn=m2[m2.length-1].replace(/.zip/g, '')


                unik.cd(pws)
                unik.mkdir(pws+'/'+mn)
                var d = unik.runAppFromZip(m1[0], pws)
                unik.cd(pws+'/'+mn)
                unik.ejecutarLineaDeComandoAparte(unik.getPath(0)+' -folder='+pws+'/'+mn)
                Qt.quit()
                return
                /*engine.load(pws+'/'+mn+'/main.qml')
                app.close()*/
            }

            if(params.indexOf('-folder=')>=0&&params.indexOf('-folder=')!==params.length-1&&params.length>5){
                m0=params.split('-folder=')
                m1=m0[1].split(',')
                m2=m1[0].split('/')
                mn=m2[m2.length-1]

                unik.ejecutarLineaDeComandoAparte(unik.getPath(0)+' -folder='+pws+'/'+mn)
                Qt.quit()
                return

                /*unik.cd(pws)
                unik.mkdir(pws+'/'+mn)
                engine.load(pws+'/'+mn+'/main.qml')
                app.close()*/
            }
        }
        //app.close()
    }
    function speak(t){
        unik.speak(t)
        app.uSpeaked=t
    }
}








