sudo apt-get install curl

#Use distrobox to build rpm on fedora
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh
distrobox create --image fedora --name fedora -Y
distrobox enter fedora -- bash -c subprojects/build_rpm_darkdetect.sh
distrobox enter fedora -- bash -c subprojects/build_rpm_LLL.sh