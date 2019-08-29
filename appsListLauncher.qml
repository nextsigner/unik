import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.2
import Qt.labs.folderlistmodel 2.2
import Qt.labs.settings 1.0
import QtMultimedia 5.12
ApplicationWindow {
    id: app
    objectName: 'awll'
    //visibility:  "Maximized"
    //visible: false
    width: Screen.width
    height: Screen.height
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    //flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    //property int fs: width<height?(Qt.platform.os !=='android'?app.height*0.02*unikSettings.zoom:app.height*0.06*unikSettings.zoom):(Qt.platform.os !=='android'?app.height*0.06*unikSettings.zoom:app.width*0.03*unikSettings.zoom)
    property int fs: Qt.platform.os !=='android'?app.height*0.035*unikSettings.zoom:app.height*0.06*unikSettings.zoom
    property color c1: "#1fbc05"
    property color c2: "black"
    property color c3: "white"
    property color c4: "green"

    property bool prima: false
    property int sec: 0
    property int ci: 0
    property var al: []
    property string ca: ''

    property var objFocus

    onClosing: {
        if(Qt.platform.os==='android'){
            //close.accepted = false;
        }
    }
    onCiChanged: app.ca=app.al[app.ci]
    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Settings{
        id: appSettings
        category: 'conf-appsListLauncher'
        property string uApp
        property int runNumber
        Component.onCompleted: {
            //if(runNumber===0)sound=true
            runNumber++
        }
    }
    UnikSettings{
        id: unikSettings
        Component.onCompleted: {
            console.log('UnikColorTheme: '+unikSettings.currentNumColor)
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
    MediaPlayer{
        id:mp;
        autoLoad: true;
        autoPlay: true;
    }
    FolderListModel{
        folder: Qt.platform.os!=='windows'?'file://'+appsDir:'file:///'+appsDir
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
        color: app.c1
        visible: unikSettings.showBg
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
            anchors.verticalCenterOffset: app.fs*2+app.fs*0.125
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
                id:lv
                spacing: app.fs*unikSettings.padding
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
                width: txt.contentWidth+app.fs*2
                height: app.fs*2
                color: 'transparent'
                anchors.horizontalCenter: parent.horizontalCenter
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
                            var uModuleName=appSettings.uApp.replace('link_', '').replace('.ukl', '')
                            if(unikSettings.sound&&unik.fileExist(pws+'/'+uModuleName+'/launch-'+unikSettings.lang+'.m4a')){
                                app.runSound(pws+'/'+uModuleName+'/launch-'+unikSettings.lang+'.m4a')
                            }else{
                                app.run()
                            }
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
                        onColorChanged: {
                            if(xItem.border.width!==0){
                                app.ca=app.al[index]
                                lv.currentIndex=index
                                psec.width=0
                            }
                        }
                        Rectangle{
                            id: borde
                            anchors.fill: parent
                            radius: parent.radius
                            border.width: unikSettings.borderWidth
                            border.color: xItem.border.width!==0?app.c2:app.c4
                            color: 'transparent'
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                app.ci=index
                                app.ca=fileName
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
                                /*var p=unik.getFile(appsDir+'/'+fileName)
                        unik.ejecutarLineaDeComandoAparte('"'+appExec+'" -cfg '+p)
                        app.close()*/
                                app.ci=index
                                app.ca=fileName
                                flick.contentY=(app.fs*2+app.fs*0.25)*index-app.height/2
                                run()
                            }
                        }
                        Text {
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
                    }
                }
                Component.onCompleted: {

                    app.al.push(fileName)
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

        Text {
            text: fl.folder
            font.pixelSize: app.fs*2
            color:app.c2
            visible: false
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
            property int cantFocus: 12
            property int currentFocus: 1
            onOpacityChanged:{
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
                spacing: app.fs*unikSettings.padding
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
                    spacing: app.fs*unikSettings.padding
                    onWidthChanged: xConfig.width=xConfig.wmax
                    BotonUX{
                        id: btnUX1
                        UnikFocus{visible: xConfig.currentFocus===1}
                        text: unikSettings.lang==='es'?'Tamaño Letra '+parseFloat(unikSettings.zoom).toFixed(1):'Font Size '+parseFloat(unikSettings.zoom).toFixed(1)
                        onClicked: {
                            var uzoom=parseFloat(unikSettings.zoom).toFixed(1)
                            if(uzoom>0.5){
                                uzoom-=0.1
                            }else{
                                uzoom=1.2
                            }
                            unikSettings.zoom=uzoom
                        }
                    }
                    BotonUX{
                        id: btnUX2
                        UnikFocus{visible: xConfig.currentFocus===2}
                        text: unikSettings.lang==='es'?'Radio de Borde':'Border Radius'
                        onClicked: {
                            if(unikSettings.radius>app.fs*0.5){
                                unikSettings.radius-=app.fs*0.05
                            }else{
                                unikSettings.radius=app.fs*2
                            }
                        }
                    }
                    BotonUX{
                        id: btnUX3
                        UnikFocus{visible: xConfig.currentFocus===3}
                        text: unikSettings.lang==='es'?'Ancho de Borde':'Width Radius'
                        onClicked: {
                            if(unikSettings.borderWidth>app.fs*0.05){
                                unikSettings.borderWidth-=app.fs*0.05
                            }else{
                                unikSettings.borderWidth=app.fs*0.5
                            }
                        }
                    }
                    BotonUX{
                        id: btnUX4
                        UnikFocus{visible: xConfig.currentFocus===4}
                        text: unikSettings.lang==='es'?'Espacio':'Space'
                        onClicked: {
                            if(unikSettings.padding>0.1){
                                unikSettings.padding-=0.1
                            }else{
                                unikSettings.padding=1.0
                            }
                        }
                    }
                }
                Row{
                    id: rowBtnSettings2
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: app.fs*unikSettings.padding
                    onWidthChanged: xConfig.width=xConfig.wmax
                    BotonUX{
                        text: unikSettings.lang==='es'?'Languaje':'Lenguaje'
                        onClicked: unikSettings.lang=unikSettings.lang==='es'?'en':'es'
                        UnikFocus{visible: xConfig.currentFocus===5}
                    }
                    BotonUX{
                        text: unikSettings.lang==='es'?'Sonido '+yesno:'Sound '+yesno
                        property string yes: unikSettings.lang==='es'?'SI':'YES'
                        property string no: unikSettings.lang==='es'?'NO':'NOT'
                        property string yesno: unikSettings.sound?yes:no
                        onClicked:unikSettings.sound=!unikSettings.sound
                        UnikFocus{visible: xConfig.currentFocus===6}
                    }
                    BotonUX{
                        UnikFocus{visible: xConfig.currentFocus===7}
                        property string yes: unikSettings.lang==='es'?'SI':'YES'
                        property string no: unikSettings.lang==='es'?'NO':'NOT'
                        property string yesno: unikSettings.showBg?no:yes
                        text: unikSettings.lang==='es'?'Fondo Transparente '+yesno:'Transparent Background '+yesno
                        onClicked: {
                            unikSettings.showBg=!unikSettings.showBg
                        }
                    }
                    BotonUX{
                        id: btnUX8
                        UnikFocus{id:ufBntFF;visible: xConfig.currentFocus===8}
                        text: unikSettings.lang==='es'?'Tipo de Letra':'Font Family'
                        onClicked: {
                            xFF.visible=true
                        }
                    }
                }
                AppColorsThemes{
                    id: appColorsThemes
                    anchors.horizontalCenter: parent.horizontalCenter
                    showBtnClose: false
                    currentFocus: ufACT.currentFocus
                    objectName: 'bbbb'
                    UnikFocus{
                        id: ufACT;
                        visible: xConfig.currentFocus===9
                        objectName: 'aaa'
                        property int currentFocus: -1
                        property int cantFocus: appColorsThemes.cantColors-1
                        onVisibleChanged: visible?currentFocus=0:currentFocus=-1
                    }
                }
                Row{
                    id: rowBtnSettingsFoot
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: app.fs*0.5
                    BotonUX{
                        id: btnUX5
                        UnikFocus{visible: xConfig.currentFocus===10}
                        text: unikSettings.lang==='es'?'Ayuda':'Help'
                        onClicked: {
                            help.visible=true
                        }
                    }
                    BotonUX{
                        id: btnUX6
                        text: unikSettings.lang==='es'?'Cerrar ':'Close'
                        onClicked:xConfig.opacity=0.0
                        UnikFocus{visible: xConfig.currentFocus===11}
                    }
                    BotonUX{
                        id: btnUX7
                        text: unikSettings.lang==='es'?'Cerrar Unik':'Close Unik'
                        onClicked:Qt.quit()
                        UnikFocus{visible: xConfig.currentFocus===12}
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
                    anchors.centerIn: parent
                    spacing: app.fs*unikSettings.padding
                    width: parent.width
                    Row{
                        id: rowFF1
                        spacing: app.fs*unikSettings.padding
                        height: btnUXCloseListFF.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        UText{
                            text: unikSettings.lang==='es'?'Tipo de Fuente Actual: '+unikSettings.fontFamily:'Current Font Family: '+unikSettings.fontFamily
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        BotonUX{
                            id: btnUXCloseListFF
                            //z: lvFF.z+1
                            //anchors.right: parent.right
                            UBg{}
                            UnikFocus{id: ufCloseListFF; visible:false}
                            text: unikSettings.lang==='es'?'Cerrar':'Close'
                            onClicked: {
                                xFF.visible=false
                            }
                        }
                    }
                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: app.fs*2
                        Rectangle{
                            id: xTxtExample
                            width: xFF.width-lvFF.width-app.fs*6
                            height: lvFF.height
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
                            height: xFF.height-btnUXCloseListFF.height-spacing-app.fs*unikSettings.padding
                            model: Qt.fontFamilies()
                            delegate: delFF
                            spacing: app.fs*unikSettings.padding
                            onCurrentItemChanged: {
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
                                    width:example.contentWidth+app.fs*unikSettings.padding
                                    height: example.contentHeight+app.fs*unikSettings.padding
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
        }
        Text {
            text: '\uf061'
            font.family: "FontAwesome"
            font.pixelSize: app.fs*2
            color:app.c2
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: app.fs*0.5
            opacity: xConfig.opacity===0.0&&!help.visible?1.0:0.0
            rotation: -180
            z:flick.z-1
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
            Text {
                id: txtHelp
                text: unikSettings.lang==='es'?h1:h2
                font.pixelSize: app.fs
                font.family: unikSettings.fontFamily
                anchors.centerIn: parent
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
            Boton{//Close
                id: btnCloseACT
                w:app.fs*2
                h: w
                t: "\uf00d"
                d:'Close'
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

    }
    Shortcut{
        sequence: 'Return'
        onActivated: {
            if(xConfig.opacity===0.0){
                tlaunch.stop()
                var uModuleName=appSettings.uApp.replace('link_', '').replace('.ukl', '')
                if(unikSettings.sound&&unik.fileExist(pws+'/'+uModuleName+'/launch-'+unikSettings.lang+'.m4a')){
                    app.runSound(pws+'/'+uModuleName+'/launch-'+unikSettings.lang+'.m4a')
                }else{
                    app.run()
                }
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
                var uModuleName=appSettings.uApp.replace('link_', '').replace('.ukl', '')
                if(unikSettings.sound&&unik.fileExist(pws+'/'+uModuleName+'/launch-'+unikSettings.lang+'.m4a')){
                    app.runSound(pws+'/'+uModuleName+'/launch-'+unikSettings.lang+'.m4a')
                }else{
                    app.run()
                }
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
            if(xConfig.opacity===0.0){
                if(app.ci<app.al.length-1){
                    app.ci++
                }else{
                    app.ci=0
                }
                tlaunch.stop()

                mp.stop()
                if(unikSettings.sound){
                    var uModuleName=app.al[app.ci].replace('link_', '').replace('.ukl', '')
                    mp.source='file:///'+pws+'/'+uModuleName+'/select-'+unikSettings.lang+'.m4a'
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
            if(xConfig.opacity===0.0){
                if(app.ci>0){
                    app.ci--
                }else{
                    app.ci=app.al.length-1
                }
                tlaunch.stop()

                mp.stop()
                if(unikSettings.sound){
                    var uModuleName=app.al[app.ci].replace('link_', '').replace('.ukl', '')
                    mp.source='file:///'+pws+'/'+uModuleName+'/select-'+unikSettings.lang+'.m4a'
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
                /*if(unikSettings.sound){
                    var uModuleName=appSettings.uApp.replace('link_', '').replace('.ukl', '')
                    mp.source='file:///'+pws+'/'+uModuleName+'/launch.m4a'
                }*/
            }
            flick.opacity=1.0
        }

    }
    Timer{
        id: tlaunch
        running: true
        repeat: true
        interval: 1000
        property bool enabled: true
        onTriggered: {
            app.sec++
            if(app.sec===7){
                stop()
                var uModuleName=appSettings.uApp.replace('link_', '').replace('.ukl', '')
                if(unikSettings.sound&&unik.fileExist(pws+'/'+uModuleName+'/launch-'+unikSettings.lang+'.m4a')){
                    app.runSound(pws+'/'+uModuleName+'/launch-'+unikSettings.lang+'.m4a')
                }else{
                    app.run()
                }
            }
            if(app.sec>7){
                app.sec=0
            }
            psec.width=psec.parent.width/5*(app.sec-1)
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
    function runSound(ids){
        var q='import QtQuick 2.0
import QtMultimedia 5.0
Item {
MediaPlayer{
        id:mpc;
        autoLoad: true;
        autoPlay: true;
        source: "file://'+ids+'"
        onStopped:{
            console.log("Se detuvo audio mpc"+mpc.source)
            app.run()
        }
    }
}
'
        var obj = Qt.createQmlObject(q, app, 'mpc')
    }
    function run(){
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
        unik.setUnikStartSettings(params)
        console.log('New USS params: '+params)
        if(Qt.platform.os==='android'){
            //unik.restartApp()
            
        }else{
            unik.restartApp("")
        }
        //app.close()
    }
}








