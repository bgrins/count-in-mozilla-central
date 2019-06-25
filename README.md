
## Summary

This is a set of scripts and dashboard showing the number of instances of a string in mozilla-central.

It's currently searching for `nsIDocShellTreeItem` but this may be modified to get a better count.

The dashboard can be seen at https://bgrins.github.io/count-in-mozilla-central/.

## Running

`./run.sh` locally will pull down a clone of mozilla-central, update it to a rev from each day, and then count the results (saved in file-counts.json).
