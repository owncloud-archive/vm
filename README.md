# vm
Scripts to build an ownCloud community production VM

On a Linux and a Mac OSX System:
Make sure you have Virtualbox and vagrant installed.
Please note that currently 8/18/2015 on Mac OSX 10.10.4 or 10.10.5 System the only virtualbox build that seems to work
is Virtualbox 4.3.26 you can find it here: https://www.virtualbox.org/wiki/Download_Old_Builds_4_3

You can find VMware Player here: https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_workstation_player/12_0

Download or clone vm github repository then:
 
<pre>
cd vagrant
sh run.sh                    # default DEBUG versions, optimized build time (ca 10 Min, no zip)
DEBUG=false sh run.sh        # production version, optimized compression (ca 20 Min build time)
ls -l oc9ce/*owncloud-9*
</pre>
After the build of the appliance you will find it in /path/to/the/cloned/github/vm/vagrant/oc9ce/img

**VirtualBox**
<pre>
->unzip xubuntu.....vdmk.zip
 -> Double click on the .ovf file
  -> Import
Then open VirtualBox
 -> Network
  -> Bridged Network
</pre>
**VMware**
<pre>
-> Double click on the .vmx file
VMware
 -> Network Adapter
  -> Bridged Network
</pre>

A plain Ubuntu console appears, showing you the IP-Address and initial credentials.
* Follow the instructions on screen, or 
* direct your web browser to the IP-Address. There is also basic web-page there with instructions.

On a Windows system make sure you have VirtualBox and vagrant installed.:
Open Virtualbox

Download or clone vm github repository then:
<pre>
#in the vm folder
cd vagrant
vagrant up
</pre>

**It does not work to build the appliance with Windows 10 and VirtualBox, but there is no problem with running it on Windows 10 and VMware**

The VM runs now in VirtualBox or VMware
Go to Network settings and change from NAT to Bridged.
Reboot.
Have Fun

