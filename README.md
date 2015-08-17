# vm
Scripts to build an ownCloud community production VM

On a Linux system:
Make sure you have Virtualbox and vagrant installed.
Download or clone vm github repository then:
 
<pre>
cd vagrant
sh run.sh                    # default DEBUG versions, optimized build time (ca 10 Min, no zip)
DEBUG=false sh run.sh        # production version, optimized compression (ca 20 Min build time)
ls -l oc8ce/*owncloud-8*
</pre>

Copy or download the *.zip file to a deplyoment system.

Unzip there, then start VirtualBox.
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
The Ubuntu Console appears.
Your login credentials are
<pre>
  login: root
  password: admin
</pre>

