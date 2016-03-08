#! /bin/sh
#
# release-github.sh -- push released files into github.
# (c) copyright 2015 jw@owncloud.com
#
# see also: git clone git@github.com:aktau/github-release.git
# see also: https://developer.github.com/v3/repos/releases/#create-a-release
# see also: http://help.appveyor.com/discussions/kb/2-guide-how-to-release-automatically-your-artifact-to-github
#
# Requires: go get https://github.com/aktau/github-release
# Recommends: https://github.com/jnweiger/showspeed/ or https://github.com/aktau/github-release/issues/33
# Requires: https://github.com/settings/tokens
# -> name: githubrelease-script
# -> scope: [x] repo, [x] public_repo

user=owncloud
repo=vm
imgdir=$(dirname $0)/img
for file in $imgdir/*.zip; do
  newtag=$(echo $file | sed -e 's@.*owncloud-@@' -e 's@\(2015[0-9]*\).*@\1@')
done

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Environment variable GITHUB_TOKEN not set."
  echo "Please study https://github.com/settings/tokens"
  exit 0;
fi

taglist=$(github-release info -u $user -r $repo | grep ", name: '" | sed -e 's@, name.*@@' -e 's@^- @@')
for oldtag in $taglist; do
  echo -n "- known release tags: $oldtag"
  if [ "$oldtag" == "v$newtag" -o "$oldtag" == "$newtag" ]; then
    echo " <= <= <= <= <= "
    tag=$newtag
  else
    echo ""
  fi
done;

if [ -z "$tag" ]; then
  echo creating new tag v$newtag
  github-release release -u $user -r $repo -t v$newtag --draft --pre-release
  tag=$newtag
fi


echo adding to v$tag
showspeed=env
## showspeed produces extremly long output lines. Make it more compact?
test -f /usr/bin/showspeed && showspeed='/usr/bin/showspeed --read --interval 10 --cmd'

# tag=8.1.2-rc1-14.1-201509010612

known_assets=$(github-release info -u $user -r $repo -t v$tag | grep ' - artifact: ' | sed -e 's@, downloads:.*@@' -e 's@^ *- artifact: *@@')

for file in $imgdir/*$tag*.zip; do 
  name=$(basename $file)
  if echo $known_assets | grep -q $name ; then
    ## FIXME: does not reliably trigger??
    echo - $file already uploaded
  else
    echo uploading $file ...
    $showspeed github-release upload -u $user -r $repo -t v$tag -f $file -n $name
  fi
done

