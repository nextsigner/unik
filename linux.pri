# Compile this project with Qt 5.12.3 on GNU/Linux, Windows or Macos

#Linux Deploy
#Deploy Command Line Example

#1) Edit default.desktop

#2)  ./linuxdeployqt-6-x86_64.AppImage /home/ns/nsp/unik/build_linux/unik -qmldir=/home/ns/nsp/unik -qmake=/home/ns/Qt/5.12.3/gcc_64/bin/qmake -verbose=3


#3 optional) Copy full plugins and qml folder for full qtquick support.
#Copy <QT-INSTALL>/gcc_64/qml and <QT-INSTALL>/gcc_64/plugins folders manualy to the executable folder location.

#Make Unik AppImage
#4) ./linuxdeployqt-6-x86_64.AppImage /home/ns/nsp/unik/build_linux/unik -qmldir=/home/ns/nsp/unik -qmake=/home/ns/Qt/5.12.3/gcc_64/bin/qmake -verbose=3 -bundle-non-qt-libs -no-plugins -appimage

#5 optional) Copy nss3 files into
#cp -r /usr/lib/x86_64-linux-gnu/nss <executable path>/

message(linux.pri is loaded)

!android{
    message(Linux NO ANDROID)
    !contains(QMAKE_HOST.arch, arm.*):{
        QT += webengine webview
        DD1=$$replace(PWD, /unik,/unik/build_linux)
        DESTDIR= $$DD1
        message(Ubicaciòn del Ejecutable: $$DESTDIR)

        FILE_VERSION_NAME=$$replace(PWD, /unik,/unik/build_linux/linux_version)
        FILE_VERSION_NAME2=\"$$FILE_VERSION_NAME\"
        write_file(/tmp/linux_version, APPVERSION)
        message(File version location: $$FILE_VERSION_NAME2)

        #Building Quazip from Ubuntu 16.10
        #Compile quazip.pro and install with sudo make install from the $$OUT_PWD
        INCLUDEPATH += $$PWD/quazip
        LIBS += -lz
        LIBS+=-L/usr/local/zlib/lib
        INCLUDEPATH+=/usr/local/zlib/include
        HEADERS += $$PWD/quazip/*.h
        SOURCES += $$PWD/quazip/*.cpp
        SOURCES += $$PWD/quazip/*.c

        #Make Desktop Unik File
        #message($$PWD/makeDesktopFile.sh unik_v4.4.4 $$DESTDIR/default.desktop)

            #Previus Linux Build Count
            PLBC=$$system(cat linux_build_count$$escape_expand(\n\t))
            #Previus Linux Build Count
            LBC=$$system(echo $(($$PLBC + 1))$$escape_expand(\n\t))
            message(Linux Build Count: $$LBC)

           # QMAKE_POST_LINK += $$quote(echo $(($$PLBC + 1)) > linux_build_count$$escape_expand(\n\t))

            QMAKE_POST_LINK += $$quote(cp $$PWD/resources/default.desktop $$DESTDIR/default.desktop$$escape_expand(\n\t))


        #Copy unik icon image to destdir
        #QMAKE_POST_LINK += $$quote(cp $$PWD/logo_unik.png $$DESTDIR/default.png$$escape_expand(\n\t))

        #COPIAR ARCHIVOS DENTRO DE APPIMAGE
        EXTRA_BINFILES += \
        /tmp/linux_version
        for(FILE,EXTRA_BINFILES){
            QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}$$escape_expand(\n\t))
            message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
        }        
    }else{
        #Set Working Directory for RPI3 compilation in /home/pi/nsp
        DESTDIR= /home/pi/unik
        message(Current Executable Path: $$DESTDIR)
        message(Current Working Directory: $$PWD)
        SOURCES += mmapGpio.cpp
        HEADERS += mmapGpio.h

    COMPILEINRPI = 1
    DEFINES += UNIK_COMPILE_RPI=\\\"$$COMPILEINRPI\\\"

        #Building Quazip from Ubuntu 16.10
        #Compile quazip.pro and install with sudo make install from the $$OUT_PWD
        INCLUDEPATH += $$PWD/quazip
        LIBS += -lz
        LIBS+=-L/usr/local/zlib/lib
        INCLUDEPATH+=/usr/local/zlib/include
        HEADERS += $$PWD/quazip/*.h
        SOURCES += $$PWD/quazip/*.cpp
        SOURCES += $$PWD/quazip/*.c

        #COPIAR ARCHIVOS NECESARIOS EN RPI3
        QMAKE_POST_LINK += $$quote(mkdir $${DESTDIR}/qml$$escape_expand(\n\t))
        QMAKE_POST_LINK += $$quote(mkdir $${DESTDIR}/qml/LogView$$escape_expand(\n\t))

        EXTRA_BINFILES += \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/qmldir \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/liblogview.so \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/Boton.qml \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/LineResizeTop.qml \
        $$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/LogView.qml
        for(FILE,EXTRA_BINFILES){
            QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}/qml/LogView$$escape_expand(\n\t))
            message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
        }

        #COPIAR ARCHIVOS NECESARIOS EN RPI3 RAIZ
        EXTRA_BINFILES2 += \
        $$PWD/logo_unik.png
        for(FILE2,EXTRA_BINFILES2){
            QMAKE_POST_LINK += $$quote(cp $${FILE2} $${DESTDIR}$$escape_expand(\n\t))
            #message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
        }
    }
}else{
    message(QT_MESSAGELOGCONTEXT defined for Android)
    DEFINES += QT_MESSAGELOGCONTEXT

    FILE_VERSION_NAME=$$PWD/android/assets/android_version
    FILE_VERSION_NAME2=\"$$FILE_VERSION_NAME\"
    write_file(/tmp/android_version, APPVERSION)
    message(File version location: $$FILE_VERSION_NAME2)

    QMAKE_POST_LINK += $$quote(cp /tmp/android_version $${PWD}/android/assets/android_version$$escape_expand(\n\t))
}
