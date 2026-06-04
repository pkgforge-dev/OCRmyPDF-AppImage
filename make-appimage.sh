#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q ocrmypdf | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/ocrmypdf/OCRmyPDF/refs/heads/main/docs/images/logo-square.png
export DESKTOP=DUMMY
export DEPLOY_PYTHON=1
export MAIN_BIN=ocrmypdf

# Deploy dependencies
quick-sharun \
	/usr/bin/ocrmypdf  \
	/usr/bin/tesseract \
	/usr/bin/gs        \
	/usr/lib/libharfbuzz*.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
