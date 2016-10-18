#! /bin/bash

rm -rf apps
test -z "$1" && exit 0

app_urls=$(echo $1 | tr ',' ' ')
mkdir apps
cd apps
for app_url in $app_urls; do
  wget $app_url -O /tmp/$$-app_tmp.zip || exit 1
  echo $app_url
  unzip /tmp/$$-app_tmp.zip
  rm -f /tmp/$$-app_tmp.zip
done

exit 0

