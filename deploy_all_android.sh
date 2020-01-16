#!/bin/bash
echo Iniciando deploy_all_android.sh...
cd /media/nextsigner/ZONA-A11/nsp/unik-dev-apps/unik
git rm "*.apk"
sh /media/nextsigner/ZONA-A11/nsp/unik-dev-apps/unik/deploy_android_x86.sh
sh /media/nextsigner/ZONA-A11/nsp/unik-dev-apps/unik/deploy_android_x86_64.sh
sh /media/nextsigner/ZONA-A11/nsp/unik-dev-apps/unik/deploy_android_armeabi-v7a.sh
sh /media/nextsigner/ZONA-A11/nsp/unik-dev-apps/unik/deploy_android_arm64-v8a.sh
s "deploying unik for android v4.03.20"
echo deploy_all_android.sh ha finalizado.
cd -
