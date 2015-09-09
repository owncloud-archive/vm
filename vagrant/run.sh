
#### use this for testing:
# time sh -x oc8ce/build-ubuntu-vm.sh isv:ownCloud:community:8.1:testing:merged

#### use this for production:
time DEBUG=false sh oc8ce/build-ubuntu-vm.sh isv:ownCloud:community:8.1

# use this variable to run the install-additional-apps.sh script.
# INSTALL_ADDITIONAL_APPS=1 sh ...  


#### upload stuff. First github, which is fast, then our own serrver.
oc8ce/release-github.sh
oc8ce/release-dl-oo.sh
