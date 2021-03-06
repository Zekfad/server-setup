#/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
sudo apt update

if [[ -z $(which nano) ]]; then
	sudo apt install -y nano
fi

sudo apt install -y ifupdown iputils-ping cron gnupg pass pass-git-helper

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

if [[ -e ~/.git-credentials ]]; then
	chmod 600 ~/.git-credentials
fi

if [[ ! -e ~/.config/pass-git-helper/git-pass-mapping.ini ]]; then
	mkdir -p ~/.config/pass-git-helper
fi

cp -i $DIR/.config/pass-git-helper/git-pass-mapping.ini ~/.config/pass-git-helper/
chmod -R 700 ~/.config

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
chmod 700 ~/.ssh
cat $DIR/id_ecdsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys ~/.config/pass-git-helper/git-pass-mapping.ini

sudo cp -i $DIR/.bashrc /root/
sudo cp -i $DIR/.bash_aliases /root/
sudo chmod 644 /root/.bashrc ~/.bash_aliases

echo Remember to setup GPG Agent forwarding: https://wiki.gnupg.org/AgentForwarding

if [[ ! -e ~/.password-store/dev/github ]]; then
	pass init 0xC164804976DB9411
	pass insert dev/github
fi
