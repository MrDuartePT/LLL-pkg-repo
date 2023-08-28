#!/bin/bash
DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPODIR="${DIR}/.."
BUILD_DIR=/tmp/darkdetect_deb

set -ex
#Intsall debian packages
sudo apt-get install debhelper dkms python3-all python3-stdeb dh-python sed
sudo pip install --upgrade setuptools build installer #Force recent version of setuptools on github ci (ubuntu)

#GET TAG
cd subprojects/darkdetect
TAG=$(git tag --points-at HEAD | cut -c 2-)
cd ${REPODIR}

# recreate BUILD_DIR
rm -rf "${BUILD_DIR}" || true
mkdir -p "${BUILD_DIR}"

## BUILD DKMS DEB
#Setup BUILD_DIR
cp --recursive ${REPODIR}/subprojects/darkdetect ${BUILD_DIR}/darkdetect
cp --recursive ${REPODIR}/subprojects/{setup.cfg,setup.py,darkdetect.spec} ${BUILD_DIR}/darkdetect

cd ${BUILD_DIR}/darkdetect

# Create package sceleton
#Change version according to tag
sed -i "s/version = _VERSION/version = ${TAG}/g" setup.cfg
#
sudo python3 setup.py --command-packages=stdeb.command sdist_dsc
cd deb_dist/darkdetect-${TAG}

# Build package
sudo dpkg-buildpackage -uc -us
cp ../python3-darkdetect_${TAG}-1_all.deb ${BUILD_DIR}

#Move to repo
cd ${REPODIR}/ubuntu
cp ${BUILD_DIR}/python3-darkdetect_${TAG}-1_all.deb ./packages