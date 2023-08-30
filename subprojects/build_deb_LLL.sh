#!/bin/bash
DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPODIR="${DIR}/.."
REPODIR_LLL="${REPODIR}/subprojects/LenovoLegionLinux"
BUILD_DIR=/tmp/deb
set -ex

#GET TAG (USE THIS WHEN STABLE RELEASE GET OUT)
cd ${REPODIR_LLL}
TAG=$(git describe --tags --abbrev=0 | sed 's/[^0-9.]*//g')
git checkout $(git describe --tags --abbrev=0) #checkout tag
cd ${REPODIR}
DKMSDIR=/usr/src/lenovolegionlinux-${TAG}

# recreate BUILD_DIR for both deb
rm -rf "${BUILD_DIR}" || true
mkdir -p "${BUILD_DIR}"

## BUILD DKMS DEB
#Setup BUILD_DIR
ls ${REPODIR_LLL}/kernel_module/
cp --recursive ${REPODIR_LLL}/kernel_module/* ${BUILD_DIR}/

cd ${BUILD_DIR}

# recreate DKMSDIR and copy files
sudo rm -rf "${DKMSDIR}" || true
sudo mkdir --verbose ${DKMSDIR}
sudo cp --recursive * ${DKMSDIR}
sudo sed -i "s/DKMS_VERSION/$TAG/g" ${DKMSDIR}/dkms.conf

#Build dkms
sudo dkms add -m lenovolegionlinux -v ${TAG}
sudo dkms build -m lenovolegionlinux -v ${TAG}

#Build deb file
sudo dkms mkdsc -m lenovolegionlinux -v ${TAG}
sudo dkms mkdeb -m lenovolegionlinux -v ${TAG}

#Copy deb to deploy folder
sudo mv /var/lib/dkms/lenovolegionlinux/${TAG}/deb/lenovolegionlinux-dkms_${TAG}_amd64.deb ${BUILD_DIR}
echo "Dkms deb located at ${BUILD_DIR}/lenovolegionlinux-dkms_${TAG}_amd64.deb"
##

##BUILD PYTHON DEB
cd ${REPODIR_LLL}/python/legion_linux
#Change version according to tag
sed -i "s/version = _VERSION/version = ${TAG}/g" setup.cfg
#

# Create package sceleton
sudo python3 setup.py --command-packages=stdeb.command sdist_dsc
cd deb_dist/legion-linux-${TAG}

##Add to debial install
sudo cp -R ../../../../extra/service/legion-linux.service .
sudo cp -R ../../../../extra/service/legion-linux.path .
echo "legion-linux.service /etc/systemd/system/" | sudo tee -a debian/install
echo "legion-linux.path /lib/systemd/system/" | sudo tee -a debian/install
sudo EDITOR=/bin/true dpkg-source -q --commit . p1

# Build package
sudo dpkg-buildpackage -uc -us
sudo mv ../python3-legion-linux_${TAG}-1_all.deb ${BUILD_DIR}

#Copy to ubuntu folder
sudo cp ${BUILD_DIR}/lenovolegionlinux-dkms_${TAG}_amd64.deb ${REPODIR}/ubuntu
sudo cp ${BUILD_DIR}/python3-legion-linux_${TAG}-1_all.deb ${REPODIR}/ubuntu
