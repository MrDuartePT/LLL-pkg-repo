# LLL-ppa
A PPA repository for my packages:

- [LenovoLegionLinux](https://github.com/johnfanv2/LenovoLegionLinux)
- [darkdetect (depedency)](https://github.com/albertosottile/darkdetect)

# Usage

```bash
sudo apt-get install curl gpg
sudo curl -s https://MrDuartePT.github.io/LLL-ppa/ubuntu/KEY.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lll-ppa.gpg > /dev/null
sudo curl -SsL -o /etc/apt/sources.list.d/lll-ppa.list https://MrDuartePT.github.io/LLL-ppa/ubuntu/lll-ppa.list
sudo apt update
sudo apt install lenovolegionlinux-dkms python3-darkdetect python3-legion-linux
```
