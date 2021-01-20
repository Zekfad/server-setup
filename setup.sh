#/bin/bash
sudo apt update
if [[ -z $(which nano) ]]
then
	sudo apt install -y nano
fi
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
cp -i ./.gitconfig ~/
cp -i ./.profile ~/
cp -i ./.bashrc ~/
cp -i ./.bash_aliases ~/
cp -i ./.bash_login ~/
cp -i ./.bash_logout ~/
cat id_ecdsa.pub >> ~/.ssh/authorized_keys
