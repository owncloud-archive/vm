# call this with a version number you want to build. 
# it will wait until that version number appears in the repo.
#

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Environment variable GITHUB_TOKEN not set. See https://github.com/settings/tokens"
  echo "You will have to call oc9ce/release-github.sh later manually. Press ENTER to continue"
  read a
fi

#### use this for testing:
# time sh -x oc8ce/build-ubuntu-vm.sh ce:8.2:testing $1

#### use this for production:
# DEBUG=false time sh oc8ce/build-ubuntu-vm.sh ce:8.2 $1

#### use this for production:
DEBUG=false time sh oc9ce/build-ubuntu-vm.sh ce:9.0 $1

# use this variable to run the install-additional-apps.sh script.
# INSTALL_ADDITIONAL_APPS=1 sh ...  


#### upload stuff. 
## first our own server, even if slower, this is what people are waiting for.
## use this for testing
#oc8ce/release-dl-oo.sh testing/vm
## use this for production
#oc8ce/release-dl-oo.sh production/vm
oc9ce/release-dl-oo.sh production/vm

## second github. This is likely to error out with 502 bad gateway.
# oc8ce/release-github.sh

echo "If this is an official release, update the version number in"
echo "https://github.com/owncloud/owncloud.org/blob/master/strings.php"
