# Get started

## Add user

```
sudo adduser zekfad
sudo usermod -aG sudo zekfad
```

## Process

```
sudo apt update
sudo apt install git -y
git config --global user.name 'Yaroslav Vorobev'
git config --global user.email 'zekfad@znnme.eu.org'
git config --global credential.helper store
git clone https://github.com/Zekfad/server-setup.git ~/setup
bash  ~/setup/setup.sh
sudo rm -rf ~/setup/
```
