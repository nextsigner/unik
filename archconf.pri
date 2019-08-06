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

contains(QMAKE_HOST.os,Linux) {
    message(Note: Unikode.org recomend compile Unik from Ubuntu 16.04)
    !contains(QMAKE_HOST.arch, arm.*):{
        DEFINES += UNIK_COMPILE_LINUX
        !contains(DEFINES,UNIK_COMPILE_ANDROID_ARMV7):!contains(DEFINES,UNIK_COMPILE_ANDROID_ARMV8):!contains(DEFINES,UNIK_COMPILE_ANDROID_x86):!contains(DEFINES,UNIK_COMPILE_ANDROID_x86_64){
            message(Compiling Unik from Linux for Linux)
            include(linux.pri)
        }else{
            message(Compiling Unik from Linux for Android)
        }
    }else{
        DEFINES += UNIK_COMPILE_LINUX_RPI
        message(Compiling Unik from Linux for RPI)
        include(rpi.pri)
    }
}

contains(QMAKE_HOST.os,Windows) {

    DEFINES += UNIK_COMPILE_WINDOWS
    message(Compiling Unik from Windows)
    include(windows.pri)
}
