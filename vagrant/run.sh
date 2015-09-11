# call this with a version number you want to build. 
# it will wait until that version number appears in the repo.
#
#### use this for testing:
# time sh -x oc8ce/build-ubuntu-vm.sh isv:ownCloud:community:8.1:testing $1

#### use this for production:
DEBUG=false time sh oc8ce/build-ubuntu-vm.sh isv:ownCloud:community:8.1:testing $1

# use this variable to run the install-additional-apps.sh script.
# INSTALL_ADDITIONAL_APPS=1 sh ...  


#### upload stuff. First github, which is fast, then our own serrver.
echo now run oc8ce/release-github.sh
echo now run oc8ce/release-dl-oo.sh

echo "If this is an official release, update the version number in"
echo "https://github.com/owncloud/owncloud.org/blob/officialvm/strings.php"
