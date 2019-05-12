#!/bin/bash
rm  $2
echo "[Desktop Entry]" >> $2
echo "Type=Application" >> $2
echo "Name="$1  >> $2
echo "Exec=AppRun %F" >> $2
echo  "Icon=default" >> $2
echo "Comment=Unik Qml Engine by @nextsigner" >> $2
echo "Terminal=true" >> $2
