android{
    FILE_VERSION_NAME=android/assets/android_version
    message(Programando en Android)

    QT += multimedia
    QT += webview
    QT += androidextras

    message(QT_MESSAGELOGCONTEXT defined for Android)
    DEFINES += QT_MESSAGELOGCONTEXT

    FILE_VERSION_NAME=$$PWD/android/assets/android_version
    FILE_VERSION_NAME2=\"$$FILE_VERSION_NAME\"
    write_file(/tmp/android_version, APPVERSION)
    message(File version location: $$FILE_VERSION_NAME2)

    QMAKE_POST_LINK += $$quote(cp /tmp/android_version $${PWD}/android/assets/android_version$$escape_expand(\n\t))


    contains(ANDROID_TARGET_ARCH,x86) {
        message(Android x86)
        COMPILEINANDROIDX86 = 1
        DEFINES += UNIK_COMPILE_ANDROID_X86=\\\"$$COMPILEINANDROIDX86\\\"
    }
    contains(ANDROID_TARGET_ARCH,x86_64) {
        message(Compilando para Android x86_64)
        COMPILEINANDROIDX86_64 = 1
        DEFINES += UNIK_COMPILE_ANDROID_X86_64=\\\"$$COMPILEINANDROIDX86_64\\\"
    }
}
