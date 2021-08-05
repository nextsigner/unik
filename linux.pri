# Compile this project with Qt 5.15.2 on GNU/Linux, Windows or Macos

#Linux Deploy
#Deploy Command Line Example

#1) Edit default.desktop

#2)  ~/linuxdeployqt-continuous-x86_64.AppImage /media/nextsigner/ZONA-A11/nsp/unik/build_linux/unik -qmldir=/media/nextsigner/ZONA-A11/nsp/unik -qmake=/home/nextsigner/Qt/5.12.3/gcc_64/bin/qmake -verbose=3


#3 optional) Copy full plugins and qml folder for full qtquick support.
#Copy <QT-INSTALL>/gcc_64/qml and <QT-INSTALL>/gcc_64/plugins folders manualy to the executable folder location.

#Make Unik AppImage
#4) ~/linuxdeployqt-continuous-x86_64.AppImage /media/nextsigner/ZONA-A11/nsp/unik/build_linux/unik -qmldir=/media/nextsigner/ZONA-A11/nsp/unik -qmake=/home/nextsigner/Qt/5.12.3/gcc_64/bin/qmake -verbose=3 -bundle-non-qt-libs -no-plugins -appimage

#5 optional) Copy nss3 files into
#cp -r /usr/lib/x86_64-linux-gnu/nss <executable path>/

message(linux.pri is loaded......)

!android{
    message(Linux NO ANDROID)
    OTHER_FILES+=build_linux/default.desktop
    !contains(QMAKE_HOST.arch, arm.*):{
        QT += webengine webview
        DD1=$$replace(PWD, /unik,/unik/build_linux)
        DESTDIR= $$DD1
        FILE_VERSION_LOCATION=$$DD1/version
        system(echo "$$APPVERSION" > $$FILE_VERSION_LOCATION)
        message(File version location: $$FILE_VERSION_LOCATION)

         DESKTOPDATA=""
         DESKTOPDATA+="[Desktop Entry]"
        DESKTOPDATA+="Categories=Qt;Settings;"
        DESKTOPDATA+="Type=Application"
        DESKTOPDATA+="Name=unik_v"$$APPVERSION
        DESKTOPDATA+="Exec=AppRun %F"
        DESKTOPDATA+="Icon=default"
        DESKTOPDATA+="Comment=Unik Qml Engine by Unikode.org"
        DESKTOPDATA+="Terminal=true"
        write_file($$PWD/build_linux/default.desktop, DESKTOPDATA)

        #Make deploy.sh for GNU/Linux (Run sudo ./deploy.sh)
        #With sudo this script run changing folder and so
        DEPLOYDATASH=""
        DEPLOYDATASH+=$${LITERAL_HASH}!/bin/bash
        DEPLOYDATASH+="echo Iniciando deploy.sh..."
        DEPLOYDATASH+="cd ../"
        DEPLOYDATASH+="cd ./unik-dev-apps/unik"
        DEPLOYDATASH+="~/linuxdeployqt-continuous-x86_64.AppImage $$PWD/build_linux/unik -qmldir=$$PWD -qmake=/home/nextsigner/Qt/5.12.3/gcc_64/bin/qmake -verbose=3 -bundle-non-qt-libs -no-plugins -appimage && cp unik_v"$$APPVERSION"-x86_64.AppImage ~/unik_v"$$APPVERSION"-x86_64.AppImage && rm -f /usr/local/bin/unik && cd ~/ && ln ~/unik_v"$$APPVERSION"-x86_64.AppImage /usr/local/bin/unik && unik -install"
        write_file($$PWD/deploy.sh, DEPLOYDATASH)


        #Building Quazip from Ubuntu 16.10
        #Compile quazip.pro and install with sudo make install from the $$OUT_PWD
        INCLUDEPATH += $$PWD/quazip
        LIBS += -lz
        LIBS+=-L/usr/local/zlib/lib
        INCLUDEPATH+=/usr/local/zlib/include
        HEADERS += $$PWD/quazip/*.h
        SOURCES += $$PWD/quazip/*.cpp
        SOURCES += $$PWD/quazip/*.c

           # QMAKE_POST_LINK += $$quote(echo $(($$PLBC + 1)) > linux_build_count$$escape_expand(\n\t))
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
