#!/bin/bash
DATA="[Desktop Entry]\nType=Application\nName=$1\nExec=AppRun %F\nIcon=default\nComment=Unik Qml Engine by @nextsigner\nTerminal=true"
echo -e $DATA > $2
