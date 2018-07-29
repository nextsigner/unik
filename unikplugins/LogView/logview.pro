TEMPLATE = lib
CONFIG += plugin
QT += qml

LIBNAME=LogView

linux{
    !android{
        qmakeforce.target = dummy
        qmakeforce.commands = rm -f Makefile ##to force rerun of qmake
        qmakeforce.depends = FORCE
        PRE_TARGETDEPS += $$qmakeforce.target
        QMAKE_EXTRA_TARGETS += qmakeforce
        !contains(QMAKE_HOST.arch, arm.*):{
            DESTDIR= ../../../unik-recursos/build_unik_linux_64/qml/LogView
            message(Destino GNU/Linux NO Android $$DESTDIR)
        }else{
            #DESTDIR= /home/pi/unik/qml/LogView
            DESTDIR= $$PWD/build_LogView_linux_rpi/qml
            message(Destino GNU/Linux RPI3 $$DESTDIR)
        }
    }else{
            DESTDIR=$$[QT_INSTALL_QML]/$${LIBNAME}
            message(Destino Android $$DESTDIR)

            OBJECTS_DIR = $$PWD/../../../.obj
            MOC_DIR = $$PWD/../../../.moc
            RCC_DIR = $$PWD/../../../.r
            message(----> $${DESTDIR})

            target.path=$${DESTDIR}/
            target.files=$${PWD}/*.qml
            INSTALLS += target
    }
}
macos{
    DESTDIR= $$PWD/build_LogView_macos_clang64/qml
    message(Destino Macos $$DESTDIR)
    EXTRA_BINFILES += \
        $$PWD/qmldir \
        $$PWD/Boton.qml \
        $$PWD/LineResizeTop.qml \
        $$PWD/LogView.qml
    for(FILE,EXTRA_BINFILES){
        QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}$$escape_expand(\n\t))
    }
}
win32{
    qmakeforce.target = dummy
    qmakeforce.commands = cmd /c del Makefile ##to force rerun of qmake
    qmakeforce.depends = FORCE
    PRE_TARGETDEPS += $$qmakeforce.target
    QMAKE_EXTRA_TARGETS += qmakeforce
    #DESTDIR= ../unik-recursos/build_win_unik_32/qml/LogView
    DESTDIR= ../../../unik-recursos/build_win_unik_32/qml/LogView
    message(Destino Windows $$DESTDIR)
}
#DESTDIR = /home/nextsigner/Escritorio/prueba/LogView
TARGET  = logview

SOURCES += logview.cpp
#QMAKE_PRE_LINK += $$quote(rm -R $${OUT_PWD}/*.o$$escape_expand(\n\t))
#message(-->$${OUT_PWD})
linux{    
    EXTRA_BINFILES += \
        $$PWD/qmldir \
        $$PWD/Boton.qml \
        $$PWD/LineResizeTop.qml \
        $$PWD/LogView.qml
    for(FILE,EXTRA_BINFILES){
        QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}$$escape_expand(\n\t))
    }
}

win32 {
    #...
    EXTRA_BINFILES += \
        $$PWD/qmldir \
        $$PWD/Boton.qml \
        $$PWD/LineResizeTop.qml \
        $$PWD/LogView.qml
    EXTRA_BINFILES_WIN = $${EXTRA_BINFILES}
    EXTRA_BINFILES_WIN ~= s,/,\\,g
        DESTDIR_WIN = $${DESTDIR}
    DESTDIR_WIN ~= s,/,\\,g
    for(FILE,EXTRA_BINFILES_WIN){
                QMAKE_POST_LINK +=$$quote(cmd /c copy /y $${FILE} $${DESTDIR_WIN}$$escape_expand(\n\t))
    }
}

DISTFILES += \
    LogView.qml \
    Boton.qml \
    LineResizeTop.qml
