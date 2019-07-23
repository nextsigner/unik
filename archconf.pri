contains(QMAKE_HOST.os,Linux) {
    message(Compiling Unik from Linux)
    message(Note: Unikode.org recomend compile Unik from Ubuntu 16.04)
    !contains(QMAKE_HOST.arch, arm.*):{
        DEFINES += UNIK_COMPILE_LINUX
        include(linux.pri)
    }else{
        DEFINES += UNIK_COMPILE_LINUX_RPI
        include(rpi.pri)
    }
}

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    DEFINES += UNIK_COMPILE_ANDROID_ARMV7
}

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    DEFINES += UNIK_COMPILE_ANDROID_ARMV8
}

contains(ANDROID_TARGET_ARCH,x86) {
    DEFINES += UNIK_COMPILE_ANDROID_X86
}

contains(ANDROID_TARGET_ARCH,x86_64) {
    DEFINES += UNIK_COMPILE_ANDROID_X86_64
}
