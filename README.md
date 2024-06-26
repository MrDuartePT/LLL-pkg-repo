# This ppa is archived
Please use the debian packages, in the future may be added to the ubuntu repos: https://tracker.debian.org/pkg/lenovolegionlinux

![build ubuntu workflow](https://github.com/MrDuartePT/LLL-pkg-repo/actions/workflows/build-ubuntu.yml/badge.svg)

# LenovoLegionLinux package for Ubuntu and Fedora
A PPA repository for my packages:

- [LenovoLegionLinux](https://github.com/johnfanv2/LenovoLegionLinux)
- [darkdetect (depedency)](https://github.com/albertosottile/darkdetect)

# Usage

Debian/Ubuntu:
```bash
sudo apt-get install curl gpg
sudo curl -s https://MrDuartePT.github.io/LLL-pkg-repo/ubuntu/KEY.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lll-ppa.gpg > /dev/null
sudo curl -SsL -o /etc/apt/sources.list.d/lll-ppa.list https://MrDuartePT.github.io/LLL-pkg-repo/ubuntu/lll-ppa.list
sudo apt update
sudo apt install lenovolegionlinux-dkms python3-darkdetect python3-legion-linux
```

Fedora was moved to copr 
Remove Fedora repo before using copr:
```bash
sudo dnf remove dkms-lenovolegionlinux python-darkdetect python-lenovolegionlinux
sudo dnf config-manager --set-disabled LLL-pkg-repo
rm /etc/yum.repos.d/LLL.repo
```

Fedora copr link: https://copr.fedorainfracloud.org/coprs/mrduarte/LenovoLegionLinux/
