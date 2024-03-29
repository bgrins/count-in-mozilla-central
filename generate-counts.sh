#!/bin/bash
# these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset


# Loop through each day, updating the hg repo, and save a
# count of lines with nsIDocShellTreeItem each day

d=2019-06-01
end=$(date +"%Y-%m-%d")

echo "Loading data from from $d until $end"

rm file-counts.json
echo "{" > file-counts.json

cd tmp-mozilla-central.noindex && hg revert --all && hg update tip

# XXX: Does checking for merge (-m) commits with a specific date (-d) get us
# the correct data, similar to:
# https://hg.mozilla.org/mozilla-central/pushloghtml?startdate=2018-12-25&enddate=2018-12-26
# Normal commit dates can be wrong, but the hope is that merge commits are actually
# authored on the same date as the push, so it'd be a simpler way than querying the pushlog.
while [ "$d" != "$end" ]; do
  current=$d
  d=$(date -j -f %Y-%m-%d -v+1d $current +%Y-%m-%d)
  rev=$(hg log -l 1 -m -d $current --template "{node}")

  if [ -z "$rev" ]
  then
    echo "No rev for $current"
  else
    echo "Got rev for $current: $rev"
    hg update -r $rev

    # rg will return output like:
    # 562 matches
    # 562 matched lines
    # 109 files contained matches
    # ....
    # We want to get only the first 562 for saving
    num=$(rg 'nsIDocShellTreeItem' --iglob '{*.cpp,*.h}' --iglob '!{obj*}' --stats -q | grep '\d matches' | cut -d' ' -f1)


    echo "\"$current\": $num," >> ../file-counts.json

  fi
done

hg update tip
cd ..

# remove the last comma:
sed -i '' '$ s/.$//' file-counts.json

echo "}" >> file-counts.json

