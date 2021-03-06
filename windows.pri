message(windows.pri is loaded)

#FILE_VERSION_NAME=version
QT += webengine
DD1=$$replace(PWD, /unik,/unik/build_win_32)
DESTDIR= $$DD1
FILE_VERSION_LOCATION=$$DD1/version
system(echo "$$APPVERSION" > $$FILE_VERSION_LOCATION)
message(File version location: $$FILE_VERSION_LOCATION)

RC_FILE = unik.rc
LIBS += -L$$PWD/libvlc-qt/lib/ -lVLCQtCore -lVLCQtWidgets -lVLCQtQml
INCLUDEPATH += $$PWD/libvlc-qt/include
DEPENDPATH += $$PWD/libvlc-qt/include

#Building Quazip from Windows 8.1
INCLUDEPATH += $$PWD/quazip
DEFINES+=QUAZIP_STATIC
HEADERS += $$PWD/quazip/*.h
SOURCES += $$PWD/quazip/*.cpp
SOURCES += $$PWD/quazip/*.c

EXTRA_BINFILES += $$PWD/version
EXTRA_BINFILES_WIN = $${EXTRA_BINFILES}
EXTRA_BINFILES_WIN ~= s,/,\\,g
DESTDIR_WIN = $$replace(PWD, /unik,/unik/build_win_32/version)
DESTDIR_WIN ~= s,/,\\,g
for(FILE,EXTRA_BINFILES_WIN){
        #QMAKE_POST_LINK +=$$quote(cmd /c copy /y $${FILE} $${DESTDIR_WIN}$$escape_expand(\n\t))
}
