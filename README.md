# LLL-ppa
A PPA repository for my packages:

- [LenovoLegionLinux](https://github.com/assafmo/joincap)
- [darkdetect (depedency)](https://github.com/albertosottile/darkdetect)

# Usage

```bash
sudo curl -SsL -o /etc/apt/trusted.gpg.d/lll-ppa.gpg https://MrDuartePT.github.io/LLL-ppa/ubuntu/KEY.gpg
sudo curl -SsL -o /etc/apt/sources.list.d/lll-ppa.list https://assafmo.github.io/LLL-ppa/ubuntu/lll-ppa.list
sudo apt update
sudo apt install lenovolegionlinux-dkms python3-darkdetect python3-legion-linux
```