#!/bin/bash

set -eux
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/Floorp-Projects/Floorp/releases > /tmp/version.json
cat /tmp/version.json| jq '.[0].assets[].browser_download_url' | grep floorp | grep linux-aarch64.tar.bz2
wget "$(cat /tmp/version.json| jq -r '.[0].assets[].browser_download_url' | grep floorp | grep linux-aarch64.tar.bz2)"
VERSION="$(cat /tmp/version.json| jq -r '.[0].tag_name')"

APPDIR=AppDir
#echo "$VERSION" >> $GITHUB_ENV
tar -xvf *.tar.* && rm -rf *.tar.*
mv floorp/* $APPDIR/
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-aarch64.AppImage
chmod +x *.AppImage
chmod +x ./AppDir/AppRun
echo "AppDir: $APPDIR"
ls -al
ls -al "$APPDIR"
sed -i s|AI\x02|\x00\x00\x00| appimagetool-aarch64.AppImage
ARCH=arm_aarch64 ./appimagetool-aarch64.AppImage --comp gzip "$APPDIR" floorp.AppImage
mkdir dist
mv floorp.AppImage* dist/.
