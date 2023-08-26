![build workflow](https://github.com/MrDuartePT/LLL-pkg-repo/actions/workflows/build.yml/badge.svg)

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

Fedora/rpm base distros:

```bash
sudo curl -s https://MrDuartePT.github.io/LLL-pkg-repo/fedora/LLL.repo | sudo tee /etc/yum.repos.d/LLL.repo > /dev/null
sudo dnf config-manager --add-repo /etc/yum.repos.d/LLL.repo
sudo dnf config-manager --set-enabled LLL-pkg-repo
sudo dnf install python3-darkdetect python3-legion-linux lenovolegionlinux
```