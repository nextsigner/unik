message(rpi.pri is loaded)
DEFINES += UNIK_COMPILE_RPI
#Set Working Directory for RPI3 compilation in /home/pi/nsp
DESTDIR= /home/pi/unik
message(Current Executable Path: $$DESTDIR)
message(Current Working Directory: $$PWD)
SOURCES += mmapGpio.cpp
HEADERS += mmapGpio.h

COMPILEINRPI = 1
DEFINES += UNIK_COMPILE_RPI=\\\"$$COMPILEINRPI\\\"

#Building Quazip from Ubuntu 16.10
#Compile quazip.pro and install with sudo make install from the $$OUT_PWD
INCLUDEPATH += $$PWD/quazip
LIBS += -lz
LIBS+=-L/usr/local/zlib/lib
INCLUDEPATH+=/usr/local/zlib/include
HEADERS += $$PWD/quazip/*.h
SOURCES += $$PWD/quazip/*.cpp
SOURCES += $$PWD/quazip/*.c

#COPIAR ARCHIVOS NECESARIOS EN RPI3
QMAKE_POST_LINK += $$quote(mkdir $${DESTDIR}/qml$$escape_expand(\n\t))
QMAKE_POST_LINK += $$quote(mkdir $${DESTDIR}/qml/LogView$$escape_expand(\n\t))

EXTRA_BINFILES += \
$$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/qmldir \
$$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/liblogview.so \
$$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/Boton.qml \
$$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/LineResizeTop.qml \
$$PWD/unikplugins/LogView/build_LogView_linux_rpi/qml/LogView.qml
for(FILE,EXTRA_BINFILES){
    QMAKE_POST_LINK += $$quote(cp $${FILE} $${DESTDIR}/qml/LogView$$escape_expand(\n\t))
    message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
}

#COPIAR ARCHIVOS NECESARIOS EN RPI3 RAIZ
EXTRA_BINFILES2 += \
$$PWD/logo_unik.png
for(FILE2,EXTRA_BINFILES2){
    QMAKE_POST_LINK += $$quote(cp $${FILE2} $${DESTDIR}$$escape_expand(\n\t))
    #message(Copyng $${FILE} $${DESTDIR}$$escape_expand(\n\t))
}


