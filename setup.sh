#/bin/bash
project_root="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo apt update

# Install nano if missing
if [[ -z $(which nano) ]]; then
	sudo apt install -y nano
fi

# Intall basic utils
sudo apt install -y iputils-ping cron gnupg pass pass-git-helper

current_hostname=$(cat /etc/hostname)
echo Current hostname: $current_hostname
echo Do you want to chnage it?
select yn in "Yes" "No"; do
	case $yn in
		Yes )
			echo Type new hostname
			read -p "New hostname: " new_hostname
			echo New hostname: $new_hostname
			if [[ $current_hostname != "" && $new_hostname != "" ]]; then
				sudo hostnamectl set-hostname $new_hostname
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

# Configs for normal user
if [[ $(id -u) != 0 ]]; then
	# Shell profile configs
	cp -i $project_root/.profile ~/
	cp -i $project_root/.bashrc ~/
	cp -i $project_root/.bash_aliases ~/
	cp -i $project_root/.bash_login ~/
	cp -i $project_root/.bash_logout ~/
	chmod 644 ~/.profile ~/.bashrc ~/.bash_aliases ~/.bash_login ~/.bash_logout

	# git
	if [[ -e ~/.git-credentials ]]; then
		chmod 600 ~/.git-credentials
	fi
	cp -i $project_root/.gitconfig ~/
	chmod 644 ~/.gitconfig

	# pass-git-helper
	if [[ "$USER" == "zekfad" ]]; then
		gpg --recv-keys 0xC164804976DB9411

		echo GPG Agent forwarding note: https://wiki.gnupg.org/AgentForwarding

		if [[ ! -e ~/.config/pass-git-helper/git-pass-mapping.ini ]]; then
			mkdir -p ~/.config/pass-git-helper
		fi
		cp -i $project_root/.config/pass-git-helper/git-pass-mapping.ini ~/.config/pass-git-helper/
		chmod -R 700 ~/.config

		if [[ ! -e ~/.password-store/dev/github ]]; then
			pass init 0xC164804976DB9411
			pass insert dev/github
		fi
	fi
fi

# Add SSH key
if [[ ! -e ~/.ssh/authorized_keys ]]; then
	mkdir -p ~/.ssh
	touch ~/.ssh/authorized_keys
fi

chmod 700 ~/.ssh

pub_key=$(head -n 1 $project_root/id_ecdsa.pub)
if ! $(grep -q "$pub_key" ~/.ssh/authorized_keys); then
	echo $pub_key >> ~/.ssh/authorized_keys
fi

chmod 600 ~/.ssh/authorized_keys 

# Root profile setup
sudo cp -i $project_root/.bashrc /root/
sudo cp -i $project_root/.bash_aliases /root/
sudo chmod 644 /root/.bashrc ~/.bash_aliases
