#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package python-fpdf2
make-aur-package ocrmypdf

# If the application needs to be manually built that has to be done down here

# Use tessdata_fast script models since they are way lighter than what archlinux provides
echo "Downloading tesseract script models..."
echo "---------------------------------------------------------------"
tessdata_dir=/usr/share/tessdata
tessdata_source=https://github.com/tesseract-ocr/tessdata_fast/raw/main
rm -f "$tessdata_dir"/*.traineddata
for lang in ben deu eng fin fra hin ori por rus spa; do
	echo "Downloading $lang.traineddata"
	wget --retry-connrefused --tries=30 "$tessdata_source"/"$lang".traineddata -O "$tessdata_dir"/"$lang".traineddata
done
wget --retry-connrefused --tries=30 "$tessdata_source"/osd.traineddata -O "$tessdata_dir"/osd.traineddata

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
