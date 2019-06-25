#!/bin/bash
# these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

./clone-repo.sh && ./generate-counts.sh