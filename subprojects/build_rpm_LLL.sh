#!/bin/bash
DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REPODIR="${DIR}/.."
REPODIR_LLL="${REPODIR}/subprojects/LenovoLegionLinux"
BUILD_DIR=/tmp/rpm
BUILD_DIR_RPM_DKMS=/tmp/rpm_dkms

set -ex

#GET TAG (USE THIS WHEN STABLE RELEASE GET OUT)
cd ${REPODIR_LLL}
TAG=$(git describe --tags --abbrev=0 | sed 's/[^0-9.]*//g')
cd ${REPODIR}

#Build folders
rm -rf "${BUILD_DIR}" || true
mkdir -p "${BUILD_DIR}"
rm -rf "${BUILD_DIR_RPM_DKMS}" || true
mkdir -p "${BUILD_DIR_RPM_DKMS}"

#BUILD DKMS RPM

cd ${BUILD_DIR_RPM_DKMS}
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
cp -r ${REPODIR_LLL}/kernel_module ./lenovolegionlinux-kmod-${TAG}-x86_64

#Dkms change version
sudo sed -i "s/_VERSION/${TAG}/g" ./lenovolegionlinux-kmod-${TAG}-x86_64/dkms.conf
mv lenovolegionlinux-kmod-${TAG}-x86_64/lenovolegionlinux.spec rpmbuild/SPECS
#Change version according to tag
sed -i "s/_VERSION/${TAG}/g" rpmbuild/SPECS/lenovolegionlinux.spec

tar --create --file lenovolegionlinux-kmod-${TAG}-x86_64.tar.gz lenovolegionlinux-kmod-${TAG}-x86_64 && rm --recursive lenovolegionlinux-kmod-${TAG}-x86_64
mv lenovolegionlinux-kmod-${TAG}-x86_64.tar.gz rpmbuild/SOURCES
cd rpmbuild && rpmbuild --define "_topdir $(pwd)" -bs SPECS/lenovolegionlinux.spec
rpmbuild --define "_topdir $(pwd)" --rebuild SRPMS/dkms-lenovolegionlinux-${TAG}-0.src.rpm
mv RPMS/x86_64/dkms-lenovolegionlinux-${TAG}-0.x86_64.rpm ${BUILD_DIR}/

#Build PYTHON RPM
cd ${BUILD_DIR}
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
cp -r ${REPODIR_LLL}/python/legion_linux python3-lenovolegionlinux-${TAG}
mv python3-lenovolegionlinux-${TAG}/lenovolegionlinux.spec rpmbuild/SPECS
#Change version according to tag
sed -i "s/version = _VERSION/version = ${TAG}/g" python3-lenovolegionlinux-${TAG}/setup.cfg
sed -i "s/%define version _VERSION/%define version ${TAG}/g" rpmbuild/SPECS/lenovolegionlinux.spec
sed -i "s/%define unmangled_version _VERSION/%define unmangled_version ${TAG}/g" rpmbuild/SPECS/lenovolegionlinux.spec
#
rm -r python3-lenovolegionlinux-${TAG}/legion_linux/extra && cp -r ${REPODIR_LLL}/extra python3-lenovolegionlinux-${TAG}/legion_linux/extra
tar --create --file python3-lenovolegionlinux-${TAG}.tar.gz python3-lenovolegionlinux-${TAG} && rm --recursive python3-lenovolegionlinux-${TAG}
mv python3-lenovolegionlinux-${TAG}.tar.gz rpmbuild/SOURCES
cd rpmbuild

#Use distrobox to build rpm on fedora
sudo rpmbuild --define "_topdir $(pwd)" -bs SPECS/lenovolegionlinux.spec
sudo rpmbuild --define "_topdir $(pwd)" --rebuild SRPMS/python3-lenovolegionlinux-${TAG}-1.src.rpm
mv RPMS/noarch/python3-lenovolegionlinux-${TAG}-1.noarch.rpm ${BUILD_DIR}/

#Test Install
rpm -i ${BUILD_DIR}/python3-lenovolegionlinux-${TAG}-1.noarch.rpm

#Move to repo
cp ${BUILD_DIR}/dkms-lenovolegionlinux-${TAG}-0.x86_64.rpm ${REPODIR}/fedora/packages
cp ${BUILD_DIR}/python3-lenovolegionlinux-${TAG}-1.noarch.rpm ${REPODIR}/fedora/packages

#create repo file
echo "[LLL-pkg-repo]
name=LLL-pkg-repo
baseurl=https://mrduartept.github.io/LLL-pkg-repo/fedora/packages
enabled=1
gpgcheck=1
gpgkey=https://mrduartept.github.io/LLL-pkg-repo/fedora/pgp-key.public" >${REPODIR}/fedora/LLL.repo
