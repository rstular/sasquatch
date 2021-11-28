#!/bin/bash
# Script to download squashfs-tools v4.4, apply the patches, perform a clean build, and install.

# If not root, perform 'make install' with sudo
if [ $UID -eq 0 ]
then
    SUDO=""
else
    SUDO="sudo"
fi

# Install prerequisites
if hash apt-get &>/dev/null
then
    $SUDO apt-get install build-essential liblzma-dev liblzo2-dev zlib1g-dev
fi

# Make sure we're working in the same directory as the build.sh script
cd $(dirname `readlink  -f $0`)

# Download squashfs4.4.tar.gz if it does not already exist
if [ ! -e squashfs4.4.tar.gz ]
then
    wget https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.4/squashfs4.4.tar.gz
fi

# Remove any previous squashfs4.4 directory to ensure a clean patch/build
rm -rf squashfs4.4

# Extract squashfs4.4.tar.gz
tar -zxvf squashfs4.4.tar.gz

# Patch, build, and install the source
cd squashfs4.4
for f in ../patches/*.patch; do
	patch -p0 < $f
done

cd squashfs-tools
make && $SUDO make install
