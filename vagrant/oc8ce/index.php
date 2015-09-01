<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head><title>Welcome to ownCloud</title>
<style><!--
body { background:rgb(220,220,255); margin:20pt; }
h2   { padding:10pt; background: rgb(180,180,200) url("/owncloud/core/img/logo-icon.svg") no-repeat scroll 2% 40%; }
pre  { background:rgb(222,222,222); padding:10pt; width: 50% }
//-->
</style>
<H2 align='center'>Welcome to ownCloud</H1>

This is the community production appliance. 
Is developed on <a href="http://www.github.com/owncloud/vm">github.com</a>.
<p>
<?php
if (isset($_GET['zap']))
  {
    # only works if /var/scripts/www is writable by www-run
    unlink( "/var/scripts/www/init-credentials.sh");
  }
if (is_file("/var/scripts/www/init-credentials.sh"))
  {
    $cred = file_get_contents("/var/scripts/www/init-credentials.sh");
    print("We have initial credentials for you:\n");
    print("<font size='+3'><pre>" . str_replace("=", ": ", $cred) . "</pre>");
    print("<br><a href='?zap=1'>Hide login credentials</a></font><p>");
  }
else
  {
    print("Login credentials protected.\n");
  }

?>

<p>The ownCloud web interface is available via HTTP or HTTPS (preferred). Depending on the network configuration of your virtual machine manager, one of the following URLs (or similar) should work to access ownCloud:
<font size='+1'>
<ul>
 <li><a href="https://<?=$_SERVER['SERVER_NAME'];?>:4443/"        >https://<?=$_SERVER['SERVER_NAME'];?>:4443</a> (VirtualBox NAT port forwarding)
 <li><a href="https://<?=$_SERVER['SERVER_NAME'];?>/"             >https://<?=$_SERVER['SERVER_NAME'];?></a> (bridged)
 <p>
 <li><a href="http://<?=$_SERVER['SERVER_NAME'];?>:8888/owncloud/">http://<?=$_SERVER['SERVER_NAME'];?>:8888/owncloud</a> (VirtualBox NAT port forwarding)
 <li><a href="http://<?=$_SERVER['SERVER_NAME'];?>/owncloud/"     >http://<?=$_SERVER['SERVER_NAME'];?>/owncloud</a> (bridged)
</ul>
</font>
<p>
To change passwords and other settings, log in at the system console as user 'admin' and follow the instructions.
The new credentials will not be shown. (Or simply click above to permanently hide them from web and console.)

