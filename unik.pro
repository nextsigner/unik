QT += qml quick sql
!contains(QMAKE_HOST.arch, arm.*):{
    message(NO Desarrollando para RPI)
    QT += multimedia
}else{
    message(Desarrollando para RPI)
}
CONFIG += c++11
CONFIG -= qmlcache

LOCATION = $$PWD
DEFINES += UNIK_PROJECT_LOCATION=\\\"$$LOCATION\\\"

linux{
    FILE_VERSION_NAME=linux_version
    CURRENTDIR_COMPILATION=$(HOME)/unikCurrentDirComp
    DEFINES += UNIK_CURRENTDIR_COMPILATION=\\\"$$CURRENTDIR_COMPILATION\\\"
    message(UNIK_CURRENTDIR_COMPILATION=$$CURRENTDIR_COMPILATION)
    QMAKE_POST_LINK += $$quote(mkdir $$CURRENTDIR_COMPILATION$$escape_expand(\n\t))
    !android{
        message(Linux NO ANDROID)
    !contains(QMAKE_HOST.arch, arm.*):{
        QT += webengine webview
        DESTDIR= ../build_unik_linux_64
        message(Ubicaciòn del Ejecutable: $$DESTDIR)

        #Configurar proyecto para Asterisk
        #INCLUDEPATH+=/media/nextsigner/ZONA-A1/nsp/asterisk-cpp/asterisk-cpp
        #INCLUDEPATH += /usr/include
        #LIBS += -L"/usr/include/boost" -lboost_system

        #Para Plugins unikSqliteCrypto
        #message(Plugins unikSqliteCrypto INCLUDEPATH= $$PWD/unikSqliteCrypto)
        #LIBS += -L$$PWD/../unik-recursos/build_usc_linux/ -lunikSqliteCrypto
        #INCLUDEPATH += $$PWD/../unik-recursos/unikSqliteCrypto
        #DEPENDPATH += $$PWD/../unik-recursos/unikSqliteCrypto

        #COPIAR ARCHIVOS DENTRO DE APPIMAGE
        EXTRA_BINFILES += \
        $$PWD/linux_version
        for(FILE,EXTRA_BINFILES){
            QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}$$escape_expand(\n\t))
            message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
        }

        #Deploy Command Line Example
        #linuxdeployqt /media/nextsigner/ZONA-A1/nsp/build_unik_linux_64/unik -qmldir=/media/nextsigner/ZONA-A1/nsp/unik -appimage -always-overwrite -bundle-non-qt-libs -no-plugins
        #mv /media/nextsigner/ZONA-A1/nsp/unik-recursos/build_unik_linux_64.AppImage /home/nextsigner/Escritorio/unik_v2.24.AppImage
    }else{
        #Set Working Directory for RPI3 compilation in /home/pi/nsp
        DESTDIR= /home/pi/unik
        message(Current Executable Path: $$DESTDIR)
        message(Current Working Directory: $$PWD)

        #COPIAR ARCHIVOS NECESARIOS EN RPI3
        QMAKE_POST_LINK += $$quote(mkdir $${DESTDIR}/qml$$escape_expand(\n\t))
        QMAKE_POST_LINK += $$quote(mkdir $${DESTDIR}/qml/LogView$$escape_expand(\n\t))
        #LOGVIEWPATH=$$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/LogView
        #QMAKE_POST_LINK += $$quote(cp $$LOGVIEWPATH/liblogview.so $${DESTDIR}/qml/LogView$$escape_expand(\n\t))
        #QMAKE_POST_LINK += $$quote(cp $$LOGVIEWPATH/LogView.qml $${DESTDIR}/qml/LogView$$escape_expand(\n\t))
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
    }
}
mac{
    FILE_VERSION_NAME=macos_version
    QT += webengine
    DESTDIR=../unik-recursos/build_osx_clang64
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11
    message(MkLevel Desarrollo en Mac)
    ICON = logo.icns
    QMAKE_INFO_PLIST = Info.plist
    #APP_QML_FILES.files = ffmpegsumo.so
    #APP_QML_FILES.path = Contents/Resources
    #QMAKE_BUNDLE_DATA += APP_QML_FILES

    #Deploy command line example
    #/Users/qt/Qt5.9.1/5.9.1/clang_64/bin/macdeployqt /Users/qt/nsp/unik-recursos/build_osx_clang64/unik.app -qmldir=/Users/qt/nsp/unik -no-strip -dmg
}
windows{
    FILE_VERSION_NAME=windows_version
    QT += webengine
    DESTDIR = ../build_win_unik_32
    RC_FILE = unik.rc
    LIBS += -L$$PWD/../libvlc-qt/lib/ -lVLCQtCore -lVLCQtWidgets -lVLCQtQml
    INCLUDEPATH += $$PWD/../libvlc-qt/include
    DEPENDPATH += $$PWD/../libvlc-qt/include

    CURRENTDIR_COMPILATION=E:/unikCurrentDirComp
    CURRENTDIR_COMPILATION ~= s,/,\\,g
    DEFINES += UNIK_CURRENTDIR_COMPILATION=\\\"$$CURRENTDIR_COMPILATION\\\"
    message(UNIK_CURRENTDIR_COMPILATION=$$CURRENTDIR_COMPILATION)
    QMAKE_POST_LINK += $$quote(cmd /c md $$CURRENTDIR_COMPILATION$$escape_expand(\n\t))

    #EXTRA_BINFILES += \
        #$$PWD/version
    #EXTRA_BINFILES_WIN = $${EXTRA_BINFILES}
    #EXTRA_BINFILES_WIN ~= s,/,\\,g
        #DESTDIR_WIN = $${DESTDIR}
    #DESTDIR_WIN ~= s,/,\\,g
    #for(FILE,EXTRA_BINFILES_WIN){
                #QMAKE_POST_LINK +=$$quote(cmd /c copy /y $${FILE} $${DESTDIR_WIN}$$escape_expand(\n\t))
    #}
}

android{
    FILE_VERSION_NAME=android/assets/android_version
    message(Programando en Android)
    QT += webview
    INCLUDEPATH += $$PWD/quazip
    #DEFINES += QUAZIP_BUILD
    LIBS += -lz
    #CONFIG(staticlib): DEFINES += QUAZIP_STATIC
    LIBS+=-L/usr/local/zlib/lib
    INCLUDEPATH+=/usr/local/zlib/include
    HEADERS += $$PWD/quazip/*.h
    SOURCES += $$PWD/quazip/*.cpp
    SOURCES += $$PWD/quazip/*.c

    #ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-build

    #LIBS+=-L/home/nextsigner/android-ndk-r10e/platforms/android-3/arch-arm/usr/lib
    #INCLUDEPATH+=/home/nextsigner/android-ndk-r10e/platforms/android-3/arch-arm/usr/include

    QT += androidextras

    COMMON_DATA.path = /assets/                                                                                qml
    COMMON_DATA.files = $$files($$PWD/android/qml/*)
    INSTALLS += COMMON_DATA
}

VERSION_YEAR=2016
VERSION_MAJ1=$$system(date +%Y)
win32 {
    VERSION_MAJ= $$system("set /a $$VERSION_MAJ1 - $$VERSION_YEAR")
    VERSION_MEN1= $$system("set /a $$system(date +%m) + $$system(date +%d) + $$system(date +%H) + $$system(date +%M)")
} else:unix {
    VERSION_MAJ= $$system("echo $(($$VERSION_MAJ1 - $$VERSION_YEAR))")
    VERSION_MEN1= $$system("echo $(($$system(date +%m) + $$system(date +%d) + $$system(date +%H) + $$system(date +%M)))")
}
greaterThan(VERSION_MEN1, 99){
    VERSION_MEN2=$$VERSION_MEN1
}else{
    VERSION_MEN2=0$$VERSION_MEN1
}
APPVERSION=$$VERSION_MAJ"."$$system(date +%W)$$VERSION_MEN2
message(App Version $$APPVERSION)
write_file($$PWD/$$FILE_VERSION_NAME, APPVERSION)

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += main.cpp \
    uk.cpp \
    row.cpp \
    asterisk.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    uk.h \
    qmlclipboardadapter.h \
    row.h \
    asterisk.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android




