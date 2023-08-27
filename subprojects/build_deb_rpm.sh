#!/bin/bash
BUILD_DIR=/tmp/darkdetect_pkg

set -ex
#Intsall debian packages
sudo apt-get install debhelper dkms python3-all python3-stdeb dh-python alien

# recreate BUILD_DIR
rm -rf "${BUILD_DIR}" || true
mkdir -p "${BUILD_DIR}"

## BUILD DKMS DEB
#Setup BUILD_DIR
cp --recursive subprojects/darkdetect ${BUILD_DIR}/darkdetect
cp --recursive subprojects/{setup.cfg,setup.py,darkdetect.spec} ${BUILD_DIR}/darkdetect

cd ${BUILD_DIR}/darkdetect

# Create package sceleton
sudo python3 setup.py --command-packages=stdeb.command sdist_dsc
cd deb_dist/darkdetect-0.8.0

# Build package
sudo dpkg-buildpackage -uc -us
cp ../python3-darkdetect_0.8.0-1_all.deb ${BUILD_DIR}

#Create rpm
cd ${BUILD_DIR}
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
mv darkdetect/darkdetect.spec rpmbuild/SPECS
cp --recursive darkdetect python-darkdetect-0.8.0 && tar --create --file python-darkdetect-0.8.0.tar.gz python-darkdetect-0.8.0 && rm --recursive python-darkdetect-0.8.0
mv python-darkdetect-0.8.0.tar.gz rpmbuild/SOURCES
cd rpmbuild
rpmbuild --define "_topdir `pwd`" -bs SPECS/darkdetect.spec
rpmbuild --nodeps --define "_topdir `pwd`" --rebuild SRPMS/python-darkdetect-0.8.0-1.src.rpm
mv RPMS/noarch/python-darkdetect-0.8.0-1.noarch.rpm ${BUILD_DIR}/

