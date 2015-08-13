#!/usr/bin/php
<?php

#
# Update or delete an entry in config.php.
# Called by kiwi's config.sh
#
if ($argc < 3)
  {
    print "Example Usage:\n\t". __FILE__." path/to/config.php overwritewebroot /owncloud\n";
    print "\t".__FILE__." path/to/config.php trusted_domains[] 17.0.2.15 localhost\n";
    # nothing to do
    return;
  }


if (!is_file($argv[1]))
  {
    # do not create the file, if missing. 
    # Wrong permissions are deadly for owncloud.
    return;
  }

include "$argv[1]";

if ($argc > 3)
  {
    # append [] to the key name, if you need to pass an array object.
    if (substr($argv[2], -2) === '[]')
      {
        $CONFIG[substr($argv[2],0,-2)] = array_slice($argv,3);
      }
    else
      {
        $CONFIG[$argv[2]] = $argv[3];
      }
  }
else
  {
    # exactly two parameter given -- means delete.
    unset($CONFIG[$argv[2]]);
  }

$text = var_export($CONFIG, true);
file_put_contents($argv[1], "<?php\n\$CONFIG = $text;\n");
?>
