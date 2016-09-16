<?php
if (isset($_SERVER['HTTP_HOST']))
{
  $CONFIG = array ( 'trusted_domains' => array ( 'localhost', $_SERVER['HTTP_HOST'], ), );
}
else
{
  $CONFIG = array ( 'trusted_domains' => array ( 'localhost', ) );
}


