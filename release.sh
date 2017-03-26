#!/usr/bin/env bash

if test -z "$(ls *.gemspec)" ; then
  echo "Run inside the gem directory"
  return 1
else

  GEM_NAME=$(basename $(ls *.gemspec) | cut -d '.' -f 1)
  GEM_NAME=$(egrep .name *.gemspec | head -1 | cut -d '=' -f 2)

  gemset() {
    gem search $GEM_NAME --source http://gems.dldinternet.com --all
    #echo yes | rvm gemset empty
    #bundle install
    n=0
    rc=1
    while test 0 -ne $((rc + 0)) -a 20 -gt $n ; do
      sleep 3
      rc=$(bundle check 2>&1 >/dev/null; echo $?)
      echo $rc
      let n=n+1
    done
  }

  gemset
  rake repackage
  o=$(rm -fr repo 2>/dev/null; mkdir -p repo/gems 2>/dev/null; echo $?)
  ls -al
  pushd repo
  echo gcp dldgems
  gsutil -q -m rsync -d -r gs://gems.dldinternet.com/ ./
  ls -al ../pkg/ ./gems/
  mv ../pkg/*.gem ./gems/
  gem generate_index .
  ls -al ../pkg/ ./gems/
  gsutil -m rsync -d -r ./ gs://gems.dldinternet.com/
  gsutil -q -m acl ch -r -u All:READ  gs://gems.dldinternet.com/*
  gsutil -q -m acl set -r public-read gs://gems.dldinternet.com/*
  echo "Wait a minute after copying objects ..." ; sleep 60
  gsutil -q -m setmeta -r -h "cache-control:public, max-age=10" gs://gems.dldinternet.com/*
  gem search $GEM_NAME --source http://gems.dldinternet.com --all --update-sources
  popd
fi
