Prerequisites:

Some Computer running Linux, OSX or Windows.
In this case we will use a prepared virtual machine. A virtual machine is an emulation of a computer system. 
Install a a virtualisation-tool  for e.g. Virtualbox :[(https://www.virtualbox.org/wiki/Downloads)] 
(you can also use VM-ware, anyways this tutorial will be only about using owncloud in virtualbox enviroment, many of the settings will be the same.)

The virtual machine itsself is called  "guest", it is a guest system on your "real" machine.               
The "real" machine is called "host".

Download the latest owncloud VM from [(http://download.owncloud.org/community/production/vm/xUbuntu_14.04-owncloud-8.2.0-2.1-201510201921.ova.zip)] and unzip it.

Then start your Virtualbox application, and you should see something like this :









Click File and then "import appliance":
Point the file-browser to the unzipped file with the filename ending .ovf and click on open.

Then click on "next".

And then click on "import".


This will take a few minutes, depending on your host System.

Click on the Freshly imported appliance, and then on "machine" and change settings. 





Depending on the size of RAM on your host System you might want to change the amount of RAM used by the "guest-system", a minimum of 512MB is recommended.

Then switch to the Network Tab and set the Network Mode to bridged. Usually the right network adapter is selected automatically.  




Then press O.K. and you are ready to boot up your virtual machine for the first time.

To start the appliance make sure it is highlighted and click start.

A new window opens: And you will see an old fashioned computer screen. 

There is now crucial Information that you will need to login.


The IP address from where the owncloud is accessible in the local network.

Your initial admin login:
Your initial password: 





Congratulations: Your owncloud is now up and running.

Now switch to your webbrowser and open the IP address specified in your running virtual machine.
You will probably be presented something like this:

Klick on the expert mode (or similar)




and then on 



Explanation: Your owncloud is up and running and has its own certificate to identify itsself against users.
The idea is that no hacker can get in the middle of you and your server and manipulate data. 
Usually sites buy services to make this certificate known to the webbrowsers and no warning will pop up.
The Appliance has its own self signed certificate,it is not verified by some certification authority since this would cost money.

You can get your cert verified for free at startssl.com, since this is not a beginners topic it is not covered here.

Then enter your credentials from the virtual machine and you should be presented something like this.






####Connecting your Cloud to the world wide web.

Explanation: Although your owncloud is up and running it is not yet accessible from the Internet. In most cases your router at home will
deny access to your local computers with a firewall. You can bypass this by opening a tunnel where webtraffic just goes right through the firewall.
The tunnel in this case is a proxy service. There are other ways to open access to your owncloud, but once again this is a beginners tutorial.
Most internet service providers, will give your router a new IP adress once a day. Since the router changes its adress every night it can´t be found, nor can your computer be 
found with the deprecated IP-adress the next Day. Our Proxy is like a service in the middle, our owncloud talks to the proxy and says "Hey Pagekite-Proxy! I´m here" And since the proxy knows the most recent adress of our Owncloud it can redirect the traffic to the current location of our server. 
  

In your Webinterface go to the app Settings and activate the proxy tool.
Then go to the Adminstrator page in the upper right corner and scroll to ownCloud proxy.
Register a new account with pagekite, check your email for user activation.
You will redirected to a page looking like this:







Click on "Your Details"








Then click on edit Password 
enter and remember a Password, repeat it and click on save.

Now go back to your owncloud administrators page and enter your pagekite credentials. 









After that you will be redirected to a owncloud page looking like this.
Now your owncloud is accessible form the internet via your pagekite link.

Add a /owncloud to the pagekite link and you have the complete access to your owncloud from outside your local Network.

Your pagekite link should look something like this: 

a1b2c3d4f5.pagekite.me/owncloud.


Congratulations! You have your ownCloud up and running and it is even accessible from the Internet.

