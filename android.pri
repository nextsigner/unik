# Compile this project for Android with Qt 5.13.0 on GNU/Linux
# For Android we are recomend compile into GNU/Linux Ubuntu 16.04 with Android SDK 29
# and Android NDK r19c
# For Android armeabi-v7a with API 21-26
# For Android arm64-v8a with API 21-28

include(openssl.pri)
FILE_VERSION_NAME=android/assets/android_version
message(Programando en Android)

QT += webview
QT += androidextras

INCLUDEPATH += $$PWD/quazip
LIBS += -lz
contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    DEFINES += UNIK_COMPILE_ANDROID_ARMV7
    message(Android armeabi-v7a)
}
contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    DEFINES += UNIK_COMPILE_ANDROID_ARM64
    message(Android arm64-v8a)
}
contains(ANDROID_TARGET_ARCH,x86) {
    DEFINES += UNIK_COMPILE_ANDROID_X86
    message(Android x86)
}
contains(ANDROID_TARGET_ARCH,x86_64) {
    DEFINES += UNIK_COMPILE_ANDROID_X86_64
    message(Android x86_64)
}

INCLUDEPATH+=/usr/local/zlib/include
HEADERS += $$PWD/quazip/*.h
SOURCES += $$PWD/quazip/*.cpp
SOURCES += $$PWD/quazip/*.c
