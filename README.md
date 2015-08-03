# vm
Scripts to build an ownCloud community production VM

On a development system
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
