#!/bin/bash
BUILD_DIR=/tmp/deb_darkdetect

set -ex
#Intsall debian packages
sudo apt-get install debhelper dkms python3-all python3-stdeb dh-python

# recreate BUILD_DIR
rm -rf "${BUILD_DIR}" || true
mkdir -p "${BUILD_DIR}"

## BUILD DKMS DEB
#Setup BUILD_DIR
cp --recursive subprojects/darkdetect_deb/* ${BUILD_DIR}/

cd ${BUILD_DIR}

# Create package sceleton
sudo python3 setup.py --command-packages=stdeb.command sdist_dsc
cd deb_dist/darkdetect-1.0.0

# Build package
sudo dpkg-buildpackage -uc -us
cp ../python3-darkdetect_1.0.0-1_all.deb ${BUILD_DIR}/python3-darkdetect_1.0.0-1_amd64.deb

#Convert to RPM
cd ${BUILD_DIR}
sudo alien -r  -c -v ./python3-darkdetect_1.0.0-1_amd64.deb