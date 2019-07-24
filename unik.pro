# It is a QtQuick Project created by @nextsigner
# More info
# E-mail: nextsigner@gmail.com
# Whatsapps: +54 11 3802 4370
# GitHub: https://github.com/nextsigner/unik
message(BUILT TO ARCH: $$QMAKE_HOST.arch)
QT +=   qml quick sql

#Widget for Qt.labs.platform 1.0
QT += widgets

CONFIG += c++11
QT += webchannel websockets
CONFIG -= qmlcache
include(version.pri)
include(archconf.pri)
linux:android{
    include(openssl.pri)
    QT += multimedia webview androidextras
    message(QT_MESSAGELOGCONTEXT defined for Android)

    DEFINES += QT_MESSAGELOGCONTEXT

    #Building Quazip Android
    INCLUDEPATH += $$PWD/quazip
    DEFINES+=QUAZIP_STATIC
    HEADERS += $$PWD/quazip/*.h
    SOURCES += $$PWD/quazip/*.cpp
    SOURCES += $$PWD/quazip/*.c
    #include(android.pri)
}

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        audiorecorder.cpp \
        chatserver.cpp \
        main.cpp \
        row.cpp \
        uk.cpp \
        unikargsproc.cpp \
        unikimageprovider.cpp \
        uniklogobject.cpp \
        unikmessagehandler.cpp \
        websocketclientwrapper.cpp \
        websockettransport.cpp

HEADERS += $$PWD/quazip/*.h \
    audiorecorder.h \
    chatserver.h \
    qmlclipboardadapter.h \
    row.h \
    uk.h \
    unikargsproc.h \
    unikimageprovider.h \
    uniklogobject.h \
    unikmessagehandler.h \
    websocketclientwrapper.h \
    websockettransport.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    archconf.pri
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
