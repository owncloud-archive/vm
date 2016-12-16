#!/bin/bash

cred_file_dir=/var/scripts/www
cred_file=$cred_file_dir/init-credentials.sh

cat << EOF
There are two different [admin] account settings. One in the Ubuntu system, one in ownCloud.
For better security, you now have the option to change both passwords.
First, change the Ubuntu password for [admin]
EOF
echo -n "Enter your new password for admin here:"; stty -echo; read passwd1; stty echo; echo
echo -n "Enter password again:                  "; stty -echo; read passwd2; stty echo; echo
echo
if [[ "$passwd1" == "$passwd2" ]]; then
    echo -e "admin:$passwd1" | chpasswd
    echo -e "user=admin\npassword=$passwd1" > $cred_file
    echo -e "\e[32mPassword changed successfully!\e[0m"
sleep 3
clear
else
    echo -e "\e[41mPassword not changed...\e[0m"
sleep 3
fi

##### Someone please expain to me what the code below is supposed to do. jw 2016-12-16
##### https://github.com/owncloud/enterprise/issues/1719
exit 0

if grep --quiet password=$passwd1 $cred_file; then
sleep 1
exit 0
else

echo -n "Enter your new password for admin here:"; stty -echo; read passwd2; stty echo; echo
echo
echo -e "Your new password is:\e[32m$passwd2\e[0m"
echo
fi
function ask_yes_or_no() {
        read -p "$1 ([y]es or [N]o): "
        case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "yes" == $(ask_yes_or_no "Is this correct?") ]]
then
    echo -e "admin:$passwd2" | chpasswd
    echo -e "user=admin\npassword=$passwd2" > $cred_file
    echo -e "\e[32mPassword changed successfully!\e[0m"
sleep 3
clear
else
    echo -e "\e[41mPassword not changed...\e[0m\nYou can try to run this script later."
sleep 3
clear
exit 1
fi
