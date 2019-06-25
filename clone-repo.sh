#!/bin/bash
# these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

if [ ! -d "tmp-mozilla-central.noindex" ]; then
  hg clone https://hg.mozilla.org/mozilla-central/ tmp-mozilla-central.noindex
fi

cd tmp-mozilla-central.noindex && hg revert --all && hg update tip && hg pull -u && cd ..
