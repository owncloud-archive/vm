<?php

# auto-promote from http to https:
# FIXME: do this only when https is configured...

$protocol = 'https';
header("location: $protocol://".$_SERVER['HTTP_HOST']."/owncloud/index.php");
