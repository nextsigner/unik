QT += qml quick sql
!contains(QMAKE_HOST.arch, arm.*):{
    message(NO Desarrollando para RPI)
    QT += multimedia
}else{
    message(Desarrollando para RPI)
}
QT +=  websockets webchannel
CONFIG += c++11
CONFIG -= qmlcache

LOCATION = $$PWD
DEFINES += UNIK_PROJECT_LOCATION=\\\"$$LOCATION\\\"

include(version.pri)
linux{
    include(linux.pri)
}
windows{
    include(windows.pri)
}

mac{
    include(macos.pri)
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

message(DestDir: $$DESTDIR)

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
    unikargsproc.cpp \
    chatserver.cpp \
    websocketclientwrapper.cpp \
    websockettransport.cpp

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
    unikargsproc.h \
    chatserver.h \
    websocketclientwrapper.h \
    websockettransport.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    linux.pri \
    version.pri \
    windows.pri \
    macos.pri

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android




