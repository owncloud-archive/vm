#!/bin/bash

cred_file_dir=/var/scripts/www
cred_file=$cred_file_dir/init-credentials.sh

echo "For better security, change the Ubuntu password for [admin]"
echo -n "Enter your new password for admin here:"; stty -echo; read passwd1; stty echo; echo
echo
echo -e "Your new password is:\e[32m$passwd1\e[0m"
echo
function ask_yes_or_no() {
        read -p "$1 ([y]es or [N]o): "
        case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "yes" == $(ask_yes_or_no "Is this correct?") ]]
then
    echo -e "admin:$passwd1" | chpasswd
    echo -e "user=admin\npassword=$passwd1" > $cred_file
    echo -e "\e[32mPassword changed successfully!\e[0m"
sleep 3
clear
else
    echo -e "\e[41mPassword not changed...\e[0m"
sleep 3
fi

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
