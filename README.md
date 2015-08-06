# vm
Scripts to build an ownCloud community production VM

On a Linux system:
Make sure you have Virtualbox and vagrant installed.
Download or clone vm github repository then:
 
<pre>
cd vagrant
sh startup.sh
ls -l *.zip
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

A plain Ubuntu console appears. Your login credentials are
<pre>
  login: root
  password: admin
</pre>


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

