#! /bin/bash
# Credit to http://pauldambra.github.io/using-travis-to-build-jekyll.html

set -eu

bundle exec htmlproofer \
  _site \
  --file-ignore /.git/ \
  --check-favicon \
  --check-html \
  --check-opengraph \
  --disable-external