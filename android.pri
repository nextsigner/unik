# Compile this project for Android with Qt 5.13.0 on GNU/Linux
# For Android we are recomend compile into
#OS: GNU/Linux Ubuntu 16.04
# Android SDK Version: 29
# and Android NDK r19c
# For Android All Arch use API 21-28
#JDK Location: /usr/lib/jvm/java-8-openjdk-amd64

include(openssl.pri)
FILE_VERSION_NAME=android/assets/android_version
message(Programando en Android)

        #Make deploy.sh for GNU/Linux (Run sudo ./deploy.sh)
        #With sudo this script run changing folder and so
        REPOSITORY=$$replace(PWD, /unik,/unik-dev-apps/unik)
        DEPLOYDATASH=""
        DEPLOYDATASH+=$${LITERAL_HASH}!/bin/bash
        DEPLOYDATASH+="echo Iniciando deploy_android.sh..."
        DEPLOYDATASH+="cp "$$OUT_PWD"/android-build/build/outputs/apk/android-build-release-signed.apk "$$REPOSITORY"/unik_v"$$APPVERSION"_"$$ANDROID_TARGET_ARCH".apk"
        DEPLOYFILESH=$$REPOSITORY"/deploy_"$$ANDROID_TARGET_ARCH".sh"
        write_file($$DEPLOYFILESH, DEPLOYDATASH)
        DEPLOYDATASH2=""
        DEPLOYDATASH2+=$${LITERAL_HASH}!/bin/bash
        DEPLOYDATASH2+="echo Iniciando deploy_all_android.sh..."
        DEPLOYDATASH2+="git rm \"*.apk\""
        DEPLOYDATASH2+="sh ./deploy_x86.sh"
        DEPLOYDATASH2+="sh ./deploy_x86_64.sh"
        DEPLOYDATASH2+="sh ./deploy_armeabi-v7a.sh"
        DEPLOYDATASH2+="sh ./deploy_arm64-v8a.sh"
        DEPLOYDATASH2+="git add *"
        DEPLOYDATASH2+="git commit -m \"deploying unik for android v$$APPVERSION\""
        DEPLOYDATASH2+="git push origin master"
        DEPLOYDATASH2+="echo \"deploy_all_android.sh ha finalizado.\""
        DEPLOYFILE=$$REPOSITORY"/deploy.sh"
        write_file($$DEPLOYFILE, DEPLOYDATASH2)
        message(DEPLOYDATASH2: $$DEPLOYDATASH2)

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
