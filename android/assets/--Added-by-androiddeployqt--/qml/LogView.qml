import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
Rectangle{
    id:raiz
    width: parent.width
    height:  parent.height
    clip: true
    color: raiz.scrollBarBgColor
    border.width: 1
    border.color: raiz.scrollBarHandlerColor
    property string bodyText: ''
    property var handlerSB

    property bool showUnikControls: false
    property bool showUnikInitMessages: unik.debugLog
    property int fontSize:14
    property string fontFamily: 'Arial'

    property int maxLength: 1000*50*5
    property int topHandlerHeight:0
    property color handlerColor: '#ccc'
    property color fontColor: "#1fbc05"
    property color bgColor: "#000000"

    property int scrollBarWidth:12
    property color scrollBarHandlerColor: raiz.fontColor
    property color scrollBarBgColor: raiz.bgColor
    property color selectionColor: raiz.fontColor
    property color selectedTextColor: raiz.bgColor

    property bool scrollBarStyle: false
    property bool showPlainText: false
    property bool enableAutoToBottom: true

    property bool showCommandsLineInput: false
    property int commandsLineInputHeight: raiz.fontSize*2

    property string help: ''

    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Connections {target: unik;onUkStdChanged: log(unik.ukStd);}
    Connections {target: unik;onStdErrChanged: log(unik.getStdErr());}
    LineResizeTop{
        id:lineRTop;
        width: raiz.width
        height: raiz.topHandlerHeight
        color: raiz.handlerColor
        minY: 0-raiz.y
        maxY: height
        onEnabledChanged: raiz.height+=10
        onYChanged: {
            raiz.height-=y;lineRTop.y=0;
            if(raiz.height<=raiz.topHandlerHeight){
                raiz.height=raiz.topHandlerHeight
                lineRTop.y=0;
            }
        }
        onProcesar: {
            raiz.height-=y;lineRTop.y=0;
        }
        onLineReleased: {
            raiz.height-=y;lineRTop.y=0;
            if(raiz.height<=raiz.topHandlerHeight){
                raiz.height=raiz.topHandlerHeight
                lineRTop.y=0;
            }
        }
    }
    Timer{
        running: raiz.height<=0&&raiz.topHandlerHeight<=0
        repeat: false
        interval: 500
        onTriggered: {
            raiz.topHandlerHeight=4
            raiz.height=4
        }
    }
    Rectangle{
        id: xBtns
        width: raiz.width
        height: raiz.showUnikControls?raiz.fontSize*2:0
        color: raiz.fontColor
        anchors.top: lineRTop.bottom
        Row{
            visible: parent.height!==0
            anchors.right: parent.right
            anchors.rightMargin: raiz.fontSize*0.2
            anchors.verticalCenter: parent.verticalCenter
            height: raiz.fontSize*1.6
            spacing: raiz.fontSize
            Boton{
                id:btnTextType
                w:parent.height
                h: w
                t: ''
                b: raiz.bgColor
                c: raiz.fontColor
                onClicking: {
                    raiz.showPlainText=!raiz.showPlainText
                }
                Text {
                    id: txtTT1
                    text: raiz.showPlainText?'<b>TXT<b>':'<b>HTML<b>'
                    anchors.centerIn: parent
                    font.pixelSize: parent.width*0.3
                    color: raiz.fontColor
                }
            }
            Boton{
                id:btnClear
                w:parent.height
                h: w
                t: '\uf12d'
                b: raiz.bgColor
                c: raiz.fontColor
                onClicking: {
                    taLog2.cursorPosition=0
                    taLog2.text=''
                }
            }
            Boton{
                id:btnHelp
                w:parent.height
                h: w
                t: '<b>?</b>'
                b: raiz.bgColor
                c: raiz.fontColor
                onClicking: {
                    raiz.enableAutoToBottom=false
                    if(raiz.scrollBarStyle){
                        taLog2.append(raiz.help)
                        //sv.flickableItem.contentY = sv.flickableItem.contentY+raiz.fontSize*6
                    }else{
                        taLog3.append(raiz.help)
                        //sv3.flickableItem.contentY = sv3.flickableItem.contentY+raiz.fontSize*6
                    }

                }
            }

            Item{
                width: parent.height
                height: width
            }

            Boton{//a unik-tools
                w:parent.height
                h: w
                t: '\uf015'
                b: raiz.bgColor
                c: raiz.fontColor
                visible: !raiz.enUnikTools
                onClicking: {
                    //unik.mainWindow(1).close();
                    var main=appsDir+'/unik-tools/main.qml'
                    unik.log('Loading Unik-Tools Home: '+main)
                    engine.load(main)
                }
            }

            Boton{//Restart
                w:parent.height
                h: w
                t: '\uf021'
                b: raiz.bgColor
                c: raiz.fontColor
                visible: !raiz.enUnikTools
                onClicking: {
                    unik.restartApp()
                }
                Text {
                    text: "\uf011"
                    font.family: "FontAwesome"
                    font.pixelSize: parent.height*0.3
                    anchors.centerIn: parent
                    color: raiz.fontColor
                }
            }
            Boton{//Quit
                w:parent.height
                h: w
                t: "\uf011"
                b: raiz.bgColor
                c: raiz.fontColor
                visible: !raiz.enUnikTools
                onClicking: {
                    Qt.quit()
                }
            }
        }
    }
    TextArea{
        id:taLog2
        visible: raiz.scrollBarStyle
        width: raiz.width
        height: raiz.height-lineRTop.height-xBtns.height-xCommands.height
        anchors.top: xBtns.bottom
        wrapMode: Text.WordWrap
        textFormat: raiz.showPlainText?Text.PlainText:Text.RichText
        font.family: raiz.fontFamily
        font.pixelSize: raiz.fontSize
        onActiveFocusChanged: {
            if(activeFocus){
                raiz.enableAutoToBottom=false
            }else{
                taLog2.deselect()
                taLog2.focus=false
            }
        }
        style: TextAreaStyle {
            textColor: raiz.fontColor
            selectionColor: raiz.selectionColor
            selectedTextColor: raiz.selectedTextColor
            backgroundColor: raiz.scrollBarBgColor
            handle: Rectangle {
                implicitWidth: raiz.scrollBarWidth
                implicitHeight: 30
                color: raiz.scrollBarHandlerColor
                radius: raiz.scrollBarWidth*0.25
            }
            scrollBarBackground: Rectangle {
                implicitWidth: raiz.scrollBarWidth
                implicitHeight: 30
                color: raiz.scrollBarBgColor
                border.width: 1
                border.color: raiz.scrollBarHandlerColor
            }
            decrementControl: Rectangle {
                implicitWidth: raiz.scrollBarWidth
                implicitHeight: raiz.scrollBarWidth
                color: raiz.scrollBarBgColor
                border.width: 1
                border.color: raiz.scrollBarHandlerColor
                Rectangle{
                    width: parent.width*0.5
                    height: width
                    rotation: 45
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: height*0.33
                    color: raiz.fontColor
                    antialiasing: true
                }
                Rectangle{
                    width: parent.width-2
                    height: parent.height/2
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0-(height*0.33)
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: parent.color
                }
                Rectangle{
                    anchors.fill: parent
                    color: 'transparent'
                    border.width: 1
                    border.color: raiz.scrollBarHandlerColor
                }
            }
            incrementControl: Rectangle {
                implicitWidth: raiz.scrollBarWidth
                implicitHeight: raiz.scrollBarWidth
                color: raiz.scrollBarBgColor
                border.width: 1
                border.color: raiz.scrollBarHandlerColor
                Rectangle{
                    width: parent.width*0.5
                    height: width
                    rotation: 45
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 0-height*0.33
                    color: raiz.fontColor
                    antialiasing: true
                }
                Rectangle{
                    width: parent.width-2
                    height: parent.height/2
                    anchors.top: parent.top
                    anchors.topMargin: 0-(height*0.33)
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: parent.color
                }
                Rectangle{
                    anchors.fill: parent
                    color: 'transparent'
                    border.width: 1
                    border.color: raiz.scrollBarHandlerColor
                }
            }
        }
    }
    TextArea{
        id:taLog3
        visible: !raiz.scrollBarStyle
        width: raiz.width
        height: raiz.height-lineRTop.height-xBtns.height-xCommands.height
        anchors.top: xBtns.bottom
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        font.family: raiz.fontFamily
        font.pixelSize: raiz.fontSize
        onActiveFocusChanged: {
            if(activeFocus){
                raiz.enableAutoToBottom=false
            }else{
                taLog3.deselect()
                taLog3.focus=false
            }
        }
        style: TextAreaStyle {
            textColor: raiz.fontColor
            selectionColor: raiz.selectionColor
            selectedTextColor: raiz.selectedTextColor
            backgroundColor: raiz.scrollBarBgColor

        }
    }
    Rectangle{
       width: raiz.scrollBarStyle?taLog2.width:taLog3.width
       height: raiz.scrollBarStyle?taLog2.height:taLog3.height
       anchors.centerIn: raiz.scrollBarStyle?taLog2:taLog3
       color: 'transparent'
       border.width: 1
       border.color: raiz.fontColor
    }
    Rectangle {
        id:redArrowDown1
        width: raiz.scrollBarWidth
        height: raiz.scrollBarWidth
        color: 'transparent'
        border.width: 1
        border.color: 'red'
        visible: !raiz.enableAutoToBottom
        anchors.bottom: raiz.scrollBarStyle?taLog2.bottom:taLog3.bottom
        anchors.right: parent.right
        anchors.rightMargin: 1
        Timer{
            running: !raiz.enableAutoToBottom
            repeat: true
            interval: 500
            onTriggered: canvas.visible=!canvas.visible
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                raiz.enableAutoToBottom=true
                taLog2.cursorPosition=0
                taLog2.deselect()
                taLog2.focus=false
                taLog3.cursorPosition=0
                taLog3.deselect()
                taLog3.focus=false
            }
        }
        Canvas{
            id:canvas
            width: parent.width*0.9
            height: parent.height*0.9
            antialiasing: true
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 0-canvas.parent.height*0.15
            rotation: -45
            //onVisibleChanged: requestPaint()
            onPaint: {
                var context = canvas.getContext("2d");
                context.beginPath();
                context.moveTo(canvas.width*0.25, canvas.width*0.25);
                context.lineTo(canvas.width*0.25, canvas.width*0.75);
                context.lineTo(canvas.width*0.75, canvas.width*0.75);
                context.closePath();
                context.lineWidth = 0;
                context.strokeStyle = '#000';
                context.stroke();
                var c
                var c0=''+raiz.fontColor
                if(c0!=="red"&&c0!=='red'&&c0!=="#ff0000"){
                    c='red'
                }else{
                    c='#ccc'
                }
                context.fillStyle = c;
                context.fill();
            }
        }
    }
    Rectangle{
        id:xCommands
        anchors.top: raiz.scrollBarStyle?taLog2.bottom:taLog3.bottom
        width: raiz.width
        height: raiz.showCommandsLineInput?raiz.commandsLineInputHeight*1.2:0
        color: raiz.bgColor
        visible: height>0
        //border.width: 4
        //border.color: "red"

        Text {
            id: unikPrompt
            text: '<b>unik\\></b>'
            font.pixelSize: raiz.fontSize
            color: raiz.fontColor
            anchors.verticalCenter: parent.verticalCenter

        }

        TextArea{
            id: tiCl
            width: parent.width-unikPrompt.width-raiz.fontSize*0.5
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: unikPrompt.right
            anchors.leftMargin: raiz.fontSize*0.5
            font.pixelSize: raiz.fontSize
            //color: raiz.fontColor
            verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            style: TextAreaStyle {
                textColor: raiz.fontColor
                selectionColor: raiz.selectionColor
                selectedTextColor: raiz.selectedTextColor
                backgroundColor: raiz.scrollBarBgColor

            }
            Keys.onReturnPressed: {
                unik.run(tiCl.text)
            }
        }

    }
    Component.onCompleted: {
        if(raiz.showUnikInitMessages){
            var s=(''+unik.initStdString).replace(/\n/g, '<br>')
            var stdinit='<b>Start Unik Init Message:</b>\u21b4<br>'+s+'<br><b>End Unik Init Message.</b><br>\n'
            var txt =''
            if(raiz.objectName==='unik-main-errors'){
                txt += "<b>OS: </b>"+Qt.platform.os
                txt += "<br><b>Errors: </b><br>"
                var s2=(''+unikError).replace(/\n/g, '<br>')
                txt+=s2
                txt += '<b>unik version: </b>'+version+'<br>\n'
                txt += '<b>AppName: </b>'+appName+'<br>\n'
                var e;
                if(unikError!==''){
                    txt += '\n<b>Unik Errors:</b>\n'+unikError+'<br>\n'
                }else{
                    txt += '\n<b>Unik Errors:</b>none<br>\n'
                }
                //txt += '\nErrors:\n'+unikError+'\n'
                txt += 'Doc location: '+appsDir+'/<br>\n'
                txt += 'host: '+host+'<br>\n'
                txt += 'user: '+ukuser+'<br>\n'
                if(ukuser==='unik-free'){
                    txt += 'key: '+ukkey+'<br>\n'
                }else{
                    txt += 'key: '
                    var k= (''+ukkey).split('')
                    for(var i=0;i<k.length;i++){
                        txt += '*'
                    }
                    txt += '<br>\n'
                }
                txt += 'sourcePath: '+sourcePath+'<br />\n'
                txt += '\n<b>config.json:</b>\n'+unik.getFile(appsDir+'/config.json')+'<br />\n'

                txt += '\nuserhost: ['+userhost+']<br>\n'
                bodyText+=txt+'<br>'+stdinit
            }else{
                bodyText+=stdinit
            }
            if(raiz.scrollBarStyle){
                taLog2.append(bodyText)
            }else{
                taLog3.append(bodyText)
            }
        }
        unik.setProperty("setInitString", true)
        if(raiz.fontSize<=0){
            raiz.fontSize = 14
        }
        raiz.help=''
                +'<b>Plugins LogView Example</b><br>'
                +'<b>import</b> LogView 1.0<br>'
                +'<b>LogView {</b><br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;width: 500<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;height: 300<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;anchors.centerIn:parent<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;scrollBarStyle:false<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;showUnikControls:true<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;topHandlerHeight:4<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;handleColor:"green"<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;maxLength:5000000<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;showUnikInitMessages:false<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;fontFamily: "Arial Black"<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;fontSize: 25<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;fontColor: "#00ff88"<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;scrollBarWidth: 30<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;scrollBarHandlerColor: "red"<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;scrollBarBgColor: "#ffff00"<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;selectionColor: "#000000"<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;selectedTextColor: "#55ffff"<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;commandsLineInputHeight:50<br>'
                +'&nbsp;&nbsp;&nbsp;&nbsp;showCommandsLineInput:true<br>'
                +'<b>}</b><br>'

    }
    function log(l){
        if(taLog2.text.length>raiz.maxLength){
            taLog2.text=''
        }
        if(taLog3.text.length>raiz.maxLength){
            taLog3.text=''
        }
        var l2=''
        var m0=(''+l).split('\n')
        if(m0.length>1){
            for(var i=0;i<m0.length;i++){
                l2+=''+m0[i]
            }
        }else{
            l2+=''+m0[0]
        }
        if(raiz.showPlainText){
            l2+='\n'
        }
        if(raiz.scrollBarStyle){
            if(raiz.enableAutoToBottom){
                taLog2.append(l2)
            }else{
                var cp = taLog2.cursorPosition
                if(taLog2.selectedText===''){
                    var py=taLog2.flickableItem.contentY
                    taLog2.text+=l2
                    taLog2.flickableItem.contentY=py
                    taLog2.cursorPosition = cp
                }else{
                    taLog2.insert(taLog2.length-1, l2)
                }
            }
        }else{
            if(raiz.enableAutoToBottom){
                taLog3.append(l2)
            }else{
                var cp = taLog3.cursorPosition
                if(taLog3.selectedText===''){
                    var py=taLog3.flickableItem.contentY
                    taLog3.text+=l2
                    taLog3.flickableItem.contentY=py
                    taLog3.cursorPosition = cp
                }else{
                    taLog3.insert(taLog3.length-1, l2)
                }
            }
        }
    }
}
