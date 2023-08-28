#!/bin/bash
DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPODIR="${DIR}/.."
BUILD_DIR=/tmp/darkdetect_rpm

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

## BUILD PYTHON RPM
#Setup BUILD_DIR
cp --recursive ${REPODIR}/subprojects/darkdetect ${BUILD_DIR}/python3-darkdetect-${TAG}
cp --recursive ${REPODIR}/subprojects/{setup.cfg,setup.py,darkdetect.spec} ${BUILD_DIR}/python3-darkdetect-${TAG}

#Create rpm
cd ${BUILD_DIR}
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
mv python3-darkdetect-${TAG}/darkdetect.spec rpmbuild/SPECS
#Change version according to tag
sed -i "s/version = _VERSION/version = ${TAG}/g" python3-darkdetect-${TAG}/setup.cfg
sed -i "s/%define version _VERSION/%define version ${TAG}/g" rpmbuild/SPECS/darkdetect.spec
sed -i "s/%define unmangled_version _VERSION/%define unmangled_version ${TAG}/g" rpmbuild/SPECS/darkdetect.spec
#
tar --create --file python3-darkdetect-${TAG}.tar.gz python3-darkdetect-${TAG} && rm --recursive python3-darkdetect-${TAG}
mv python3-darkdetect-${TAG}.tar.gz rpmbuild/SOURCES
cd rpmbuild
rpmbuild --define "_topdir `pwd`" -bs SPECS/darkdetect.spec
rpmbuild --nodeps --define "_topdir `pwd`" --rebuild SRPMS/python3-darkdetect-${TAG}-1.src.rpm
mv RPMS/noarch/python3-darkdetect-${TAG}-1.noarch.rpm ${BUILD_DIR}/

#Move to repo
cp ${BUILD_DIR}/python3-darkdetect-${TAG}-1.noarch.rpm ${REPODIR}/fedora/packages