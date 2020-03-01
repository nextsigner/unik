contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/android_openssl-5.12.4_5.13.0/arm/libcrypto.so \
        $$PWD/android_openssl-5.12.4_5.13.0/arm/libssl.so
}

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/android_openssl-5.12.4_5.13.0/arm64/libcrypto.so \
        $$PWD/android_openssl-5.12.4_5.13.0/arm64/libssl.so
}

contains(ANDROID_TARGET_ARCH,x86) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/android_openssl-5.12.4_5.13.0/x86/libcrypto.so \
        $$PWD/android_openssl-5.12.4_5.13.0/x86/libssl.so
}

contains(ANDROID_TARGET_ARCH,x86_64) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/android_openssl-5.12.4_5.13.0/x86_64/libcrypto.so \
        $$PWD/android_openssl-5.12.4_5.13.0/x86_64/libssl.so
}
