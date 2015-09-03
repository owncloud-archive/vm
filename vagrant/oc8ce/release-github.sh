#! /bin/sh
#
# release-github.sh -- push released files into github.
# (c) copyright 2015 jw@owncloud.com
#
# see also: git clone git@github.com:j0057/github-release.git
# see also: https://developer.github.com/v3/repos/releases/#create-a-release
#
# Requires: sudo pip install githubrelease
# Requires: https://github.com/settings/tokens/new
# -> name: githubrelease-script
# -> scope: [x] repo, [x] public_repo

repo=owncloud/vm
imgdir=$(dirname $0)/img
for file in $imgdir/*.zip; do
  newtag=$(echo $file | sed -e 's@.*owncloud-@@' -e 's@\(2015[0-9]*\).*@\1@')
done

taglist=$(github-release $repo list | grep 'Tag name' | sed -e 's@.*: *@@')
for oldtag in $taglist; do
  echo - known release tags: $oldtag
  test "$oldtag" == "v$newtag" && tag=$newtag
done;

if [ -n "$tag" ]; then 
  echo adding to v$tag
  known_assets=$(github-release $repo info v$tag | grep 'Asset #' | grep ' name ')
  for file in $imgdir/*$tag*.zip; do 
    if echo $known_assets | grep -q $(basename $file) ; then
      echo - $file already uploaded
    else
      echo uploading $file
      github-asset $repo upload v$tag $file
      ## https://github.com/j0057/github-release/issues/1
      echo - done
    fi
  done
else
  echo creating new tag v$newtag
  github-release $repo create v$newtag
  echo FIXME: unfinsihed.
fi
