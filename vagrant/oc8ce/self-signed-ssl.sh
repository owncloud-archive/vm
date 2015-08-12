#!/bin/bash

# Put the conf here:
ssl_conf="/etc/apache2/sites-available/self-signed-ssl.conf"

set -x
touch $ssl_conf
cat << SSL_CREATE > "$ssl_conf"

cat << SSLCONF

    <VirtualHost *:443>
    Header add Strict-Transport-Security: "max-age=15768000;includeSubdomains" 
    SSLEngine on

    ## MORE INFO CAN BE FOUND @		
    ## https://www.en0ch.se/virtualhost-443/ # Or some links to the docs...


    # The ServerName directive sets the request scheme, hostname and port that
    # the server uses to identify itself. This is used when creating 
    # redirection URLs. In the context of virtual hosts, the ServerName
    # specifies what hostname must appear in the request's Host: header to
    # match this virtual host. For the default virtual host (this file) this
    # value is not decisive as it is used as a last resort host regardless.
    # However, you must set it for any further virtual host explicitly.

    ### YOUR SERVER ADDRESS ###

    ### Please remove the '#' in front of each row ###
    
    #    ServerAdmin admin@example.com
    #    ServerName example.com
    #    ServerAlias example.com
    
    ### SETTINGS ###    

    DocumentRoot /var/www/owncloud
    <Directory /var/www/owncloud>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
    </Directory>

    ### LOCATION OF CERT FILES ### 

    SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

    # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
    # error, crit, alert, emerg.
    # It is also possible to configure the loglevel for particular
    # modules, e.g.
    #LogLevel info ssl:warn

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    # For most configuration files from conf-available/, which are
    # enabled or disabled at a global level, it is possible to
    # include a line for only one particular virtual host. For example the
    # following line enables the CGI configuration for this host only
    # after it has been globally disabled with "a2disconf".
    # Include conf-available/serve-cgi-bin.conf
  
    </VirtualHost>

SSLCONF

SSL_CREATE

a2ensite self-signed-ssl.conf
service apache2 reload
