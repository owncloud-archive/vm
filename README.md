# vm
Scripts to build an ownCloud community production VM

On a Linux and a Mac OSX System:
Make sure you have Virtualbox and vagrant installed.
Please note that currently 8/18/2015 on Mac OSX 10.10.4 or 10.10.5 System the only virtualbox build that seems to work
is Virtualbox 4.3.26 you can find it here: https://www.virtualbox.org/wiki/Download_Old_Builds_4_3
Download or clone vm github repository then:
 
<pre>
cd vagrant
sh run.sh                    # default DEBUG versions, optimized build time (ca 10 Min, no zip)
DEBUG=false sh run.sh        # production version, optimized compression (ca 20 Min build time)
ls -l oc8ce/*owncloud-8*
</pre>

After the build of the appliance you will find it in /path/to/the/cloned/owncloud/vm/vagrant/oc8e/

Then open Virtualbox
<pre>
VirtualBox
 -> New
   -> Enter name [ubuntu14.04+oc8.1.0]
     -> Next -> Next -> Next
     (X) use existing disk image
       box-disk1.vmdk
 -> Network
  -> Bridged Network
</pre>

A plain Ubuntu console appears, showing you the IP-Address and initial credentials.
* Follow the instructions on screen, or 
* direct your web browser to the IP-Address. There is also basic web-page there with instructions.


!!!This does not yet work yet with Windows10!!!

On a Windows system make sure you have virtualbox and vagrant installed.:
Open Virtualbox

Download or clone vm github repository then:
<pre>
#in the vm folder
cd vagrant
vagrant up
</pre>


The VM runs now in VirtualBox.
Go to Network settings and change from NAT to Bridged.
Reboot.
Have Fun

