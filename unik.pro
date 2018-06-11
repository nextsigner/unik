QT += qml quick sql multimedia
CONFIG += c++11
CONFIG -= qmlcache
#CONFIG += console
#CONFIG+=qml_debug

LOCATION = $$PWD
DEFINES += UNIK_PROJECT_LOCATION=\\\"$$LOCATION\\\"

linux{
    !android{
        message(Linux NO ANDROID)
        QT += webengine webview
        DESTDIR= ../build_unik_linux_64
        message(Ubicaciòn del Ejecutable: $$DESTDIR)

        #Configurar proyecto para Asterisk
        #INCLUDEPATH+=/media/nextsigner/ZONA-A1/nsp/asterisk-cpp/asterisk-cpp
        #INCLUDEPATH += /usr/include
        #LIBS += -L"/usr/include/boost" -lboost_system

        #Para Plugins unikSqliteCrypto
        #message(Plugins unikSqliteCrypto INCLUDEPATH= $$PWD/unikSqliteCrypto)
        LIBS += -L$$PWD/../unik-recursos/build_usc_linux/ -lunikSqliteCrypto
        INCLUDEPATH += $$PWD/../unik-recursos/unikSqliteCrypto
        DEPENDPATH += $$PWD/../unik-recursos/unikSqliteCrypto

        #COPIAR ARCHIVOS DENTRO DE APPIMAGE
        #EXTRA_BINFILES += \
        #$$PWD/version
        #for(FILE,EXTRA_BINFILES){
            #QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}$$escape_expand(\n\t))
            #message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
        #}

        #Deploy Command Line Example
        #linuxdeployqt /media/nextsigner/ZONA-A1/nsp/unik-recursos/build_unik_linux_64/unik -qmldir=/media/nextsigner/ZONA-A1/nsp/unik -appimage -always-overwrite -bundle-non-qt-libs -no-plugins
        #mv /media/nextsigner/ZONA-A1/nsp/unik-recursos/build_unik_linux_64.AppImage /home/nextsigner/Escritorio/unik_v2.24.AppImage
    }
}
mac{
    QT += webengine
    DESTDIR=../unik/build
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11
    message(MkLevel Desarrollo en Mac)
    ICON = logo.icns
    QMAKE_INFO_PLIST = Info.plist
    #APP_QML_FILES.files = ffmpegsumo.so
    #APP_QML_FILES.path = Contents/Resources
    #QMAKE_BUNDLE_DATA += APP_QML_FILES
}
windows{
    QT += webengine
    DESTDIR = ../build_win_unik_32
    RC_FILE = unik.rc
    LIBS += -L$$PWD/../libvlc-qt/lib/ -lVLCQtCore -lVLCQtWidgets -lVLCQtQml
    INCLUDEPATH += $$PWD/../libvlc-qt/include
    DEPENDPATH += $$PWD/../libvlc-qt/include

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
    message(Programando en Android)
    QT += webview
#ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-build
    QT += androidextras
}

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
    frame.cpp \
    asterisk.cpp \
    ukprocess.cpp

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
    frame.h \
    asterisk.h \
    ukprocess.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    build_unik.AppImage \
    android/assets/unik-tools/Ayuda.qml \
    android/assets/unik-tools/Boton.qml \
    android/assets/unik-tools/DialogoConfirmar.qml \
    android/assets/unik-tools/FormUnikLogin.qml \
    android/assets/unik-tools/GitAppsList.qml \
    android/assets/unik-tools/LineResizeH.qml \
    android/assets/unik-tools/LogView.qml \
    android/assets/unik-tools/main.qml \
    android/assets/unik-tools/Page1.qml \
    android/assets/unik-tools/PageAppList.qml \
    android/assets/unik-tools/ToUpkDialog.qml \
    android/assets/unik-tools/Ayuda.qml \
    android/assets/unik-tools/Boton.qml \
    android/assets/unik-tools/DialogoConfirmar.qml \
    android/assets/unik-tools/FormUnikLogin.qml \
    android/assets/unik-tools/GitAppsList.qml \
    android/assets/unik-tools/LineResizeH.qml \
    android/assets/unik-tools/LogView.qml \
    android/assets/unik-tools/main.qml \
    android/assets/unik-tools/Page1.qml \
    android/assets/unik-tools/PageAppList.qml \
    android/assets/unik-tools/ToUpkDialog.qml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android




