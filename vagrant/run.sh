
#### use this for testing:
# time sh -x oc8ce/build-ubuntu-vm.sh isv:ownCloud:community:8.1:testing:merged

#### use this for production:
DEBUG=false sh oc8ce/build-ubuntu-vm.sh isv:ownCloud:community:8.1

# use this variable to run the install-additional-apps.sh script.
# INSTALL_ADDITIONAL_APPS=1 sh ...  

# TODO: * run the converters to produce all neede formats
# TODO: * find a place where to publish. on http://download.owncloud.org/community or on https://github.com/owncloud/vm/releases

