# 05/08/2019 Compile this project with Qt 5.12.3 on GNU/Linux, Windows or Macos
# For Android you needs compile into GNU/Linux with Android SDK 26.1.1 or later
# and Android NDK r19c or later

#Linux Deploy
#Deploy Command Line Example

#1) Copy default.png image for app icon.

#2) Edit default.desktop

#3)  ./linuxdeployqt-6-x86_64.AppImage /home/ns/nsp/unik/build_linux/unik -qmldir=/home/ns/nsp/unik -qmake=/home/ns/Qt/5.12.3/gcc_64/bin/qmake -verbose=3


#4 optional) Copy full plugins and qml folder for full qtquick support.
#Copy <QT-INSTALL>/gcc_64/qml and <QT-INSTALL>/gcc_64/plugins folders manualy to the executable folder location.

#Make Unik AppImage
#5) ./linuxdeployqt-6-x86_64.AppImage /home/ns/nsp/unik/build_linux/unik -qmldir=/home/ns/nsp/unik -qmake=/home/ns/Qt/5.12.3/gcc_64/bin/qmake -verbose=3 -bundle-non-qt-libs -no-plugins -appimage

#6 optional) Copy nss3 files into
#cp -r /usr/lib/x86_64-linux-gnu/nss <executable path>/

message(linux.pri is loaded)

QT += webview
QT += multimedia webview webengine
DD1=$$replace(PWD, /unik, /unik/build_linux)
DESTDIR= $$DD1
message(Ubicaciòn del Ejecutable: $$DESTDIR)

FILE_VERSION_NAME=$$replace(PWD, /unik,/unik/build_linux/linux_version)
FILE_VERSION_NAME2=\"$$FILE_VERSION_NAME\"
write_file(/tmp/linux_version, APPVERSION)
message(File version location: $$FILE_VERSION_NAME2)

#Building Quazip from Ubuntu 16.04
#Compile quazip.pro and install with sudo make install from the $$OUT_PWD
INCLUDEPATH += $$PWD/quazip
LIBS += -lz
LIBS+=-L/usr/local/zlib/lib
INCLUDEPATH+=/usr/local/zlib/include
HEADERS += $$PWD/quazip/*.h
SOURCES += $$PWD/quazip/*.cpp
SOURCES += $$PWD/quazip/*.c

#Make Desktop Unik File
#message($$PWD/makeDesktopFile.sh unik_v4.4.4 $$DESTDIR/default.desktop)

#Previus Linux Build Count
PLBC=$$system(cat linux_build_count$$escape_expand(\n\t))
#Previus Linux Build Count
LBC=$$system(echo $(($$PLBC + 1))$$escape_expand(\n\t))
message(Linux Build Count: $$LBC)
#QMAKE_POST_LINK += $$quote(echo $(($$PLBC + 1)) > linux_build_count$$escape_exp1and(\n\t))

QMAKE_POST_LINK += $$quote(cp $$PWD/resources/default.desktop $$DESTDIR/default.desktop$$escape_expand(\n\t))
#QMAKE_POST_LINK += $$quote(rm $$DESTDIR/default.desktop$$escape_expand(\n\t))
#QMAKE_POST_LINK += $$quote(sh $$PWD/makeDesktopFile.sh unik_v$$VERSION_MAJ"."$$system(date +%W).$$LBC $$DESTDIR/default.desktop$$escape_expand(\n\t))

#Copy unik files
QMAKE_POST_LINK += $$quote(cp $$PWD/default.desktop $$DESTDIR/$$escape_expand(\n\t))
QMAKE_POST_LINK += $$quote(cp $$PWD/logo_unik.png $$DESTDIR/default.png$$escape_expand(\n\t))

#COPIAR ARCHIVOS DENTRO DE APPIMAGE
EXTRA_BINFILES += \
    /tmp/linux_version
for(FILE,EXTRA_BINFILES){
    QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}$$escape_expand(\n\t))
    message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
}
