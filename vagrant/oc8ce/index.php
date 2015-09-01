
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head><title>Welcome to ownCloud</title>
<style>
body {
	background-color: #1d2d44;
	font-weight: 300;
	font-size: 1em;
	line-height: 1.6em;
	font-family: 'Open Sans', Frutiger, Calibri, 'Myriad Pro', Myriad, sans-serif;
	color: white;
	height: auto;
	margin-left: auto;
	margin-right: auto;
	align: center;
	text-align: center;
	background: #1d2d44; /* Old browsers */
	background: -moz-linear-gradient(top, #35537a 0%, #1d2d44 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#35537a), color-stop(100%,#1d2d44)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #35537a 0%,#1d2d44 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top, #35537a 0%,#1d2d44 100%); /* Opera11.10+ */
	background: -ms-linear-gradient(top, #35537a 0%,#1d2d44 100%); /* IE10+ */
	background: linear-gradient(top, #35537a 0%,#1d2d44 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#35537a', endColorstr='#1d2d44',GradientType=0 ); /* IE6-9 */
}

div.logotext   {
	width: 50%;
    	margin: 0 auto;
}
div.logo   {
        background-image: url('/owncloud/core/img/logo-icon.svg');
        background-repeat: no-repeat; top center;
        width: 50%;
	height: 25%;
        margin: 0 auto;
	background-size: 40%;
	margin-left: 40%;
        margin-right: 20%;
}

pre  {
	padding:10pt;
	width: 50%
        text-align: center;
        margin-left: 20%;
	margin-right: 20%;
}

div.information {
        align: center;
	width: 50%;
        margin: 10px auto;
	display: block;
        padding: 10px;
        background-color: rgba(0,0,0,.3);
        color: #fff;
        text-align: left;
        border-radius: 3px;
        cursor: default;
}

/* unvisited link */
a:link {
    color: #FFFFFF;
}

/* visited link */
a:visited {
    color: #FFFFFF;
}

/* mouse over link */
a:hover {
    color: #E0E0E0;
}

/* selected link */
a:active {
    color: #E0E0E0;
}

</style>

<br>
<div class="logo">
</div>
<div class="logotext">
<h2>Welcome to ownCloud</h2>
</div>
<br>

This is the community production appliance. 
Is publically developed on <a href="http://www.github.com/owncloud/vm">github.com</a>.

<div class="information">
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
    print("<br><a href='?zap=1' rel='nofollow'>Hide login credentials</a></font><p>");
  }
else
  {
    print("Login credentials protected.\n");
  }
?>
</pre></font></div>

<p>The ownCloud web interface is available via HTTP or HTTPS (preferred). Depending on the network configuration of your virtual machine manager.

<div class="information">
One of the following URLs (or similar) should work to access ownCloud:
<ul>
 <li><a href="https://<?=$_SERVER['SERVER_NAME'];?>:4443/"        >https://<?=$_SERVER['SERVER_NAME'];?>:4443</a> (VirtualBox NAT port forwarding)
 <li><a href="https://<?=$_SERVER['SERVER_NAME'];?>/"             >https://<?=$_SERVER['SERVER_NAME'];?></a> (bridged)
 <p>
 <li><a href="http://<?=$_SERVER['SERVER_NAME'];?>:8888/owncloud/">http://<?=$_SERVER['SERVER_NAME'];?>:8888/owncloud</a> (VirtualBox NAT port forwarding)
 <li><a href="http://<?=$_SERVER['SERVER_NAME'];?>/owncloud/"     >http://<?=$_SERVER['SERVER_NAME'];?>/owncloud</a> (bridged)
</ul>
</div>

<p>
To change passwords and other settings, log in at the system console as user 'admin' and follow the instructions.
The new credentials will not be shown. (Or simply click above to permanently hide them from web and console.)
