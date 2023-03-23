#!/bin/bash
echo Iniciando deploy.sh...
cd ../
cd ./unik-dev-apps/unik
~/linuxdeployqt-continuous-x86_64.AppImage /home/ns/nsp/unik/build_linux/unik -qmldir=/home/ns/nsp/unik -qmake=/home/nextsigner/Qt/5.12.3/gcc_64/bin/qmake -verbose=3 -bundle-non-qt-libs -no-plugins -appimage && cp unik_v7.13.0-x86_64.AppImage ~/unik_v7.13.0-x86_64.AppImage && rm -f /usr/local/bin/unik && cd ~/ && ln ~/unik_v7.13.0-x86_64.AppImage /usr/local/bin/unik && unik -install
