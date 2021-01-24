#/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
sudo apt update
if [[ -z $(which nano) ]]
then
	sudo apt install -y nano
fi
sudo apt install -y ifupdown iputils-ping cron
hostname_orig=$(cat /etc/hostname)
echo Current hostname: $hostname_orig
echo Do you want to chnage it?
select yn in "Yes" "No"; do
	case $yn in
		Yes )
			echo Type new hostname
			read -p "New hostname: " hostname_new
			echo New hostname: $hostname_new
			if [[ $hostname_orig != "" && $hostname_new != "" ]]; then
				sudo hostnamectl set-hostname $hostname_new
				echo Hostname chnaged to: $(cat /etc/hostname)
			fi
			break
		;;
		No )
			echo Skipping.
			break
		;;
	esac
done

chmod 600 ~/.git-credentials
cp -i $DIR/.gitconfig ~/
cp -i $DIR/.profile ~/
cp -i $DIR/.bashrc ~/
cp -i $DIR/.bash_aliases ~/
cp -i $DIR/.bash_login ~/
cp -i $DIR/.bash_logout ~/
chmod 644 ~/.gitconfig ~/.profile ~/.bashrc ~/.bash_aliases ~/.bash_login ~/.bash_logout
if [[ ! -e ~/.ssh/authorized_keys ]]; then
	mkdir -p ~/.ssh
	touch ~/.ssh/authorized_keys
fi
cat $DIR/id_ecdsa.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

sudo cp -i $DIR/.bashrc /root/
chmod 644 /root/.bashrc
