#!/usr/bin/env bash

echo "# Release $2" > /tmp/changelog.top
git log $1...$2 --pretty=format:'* [view commit](http://github.com/redhat-nfvpe/kube-ansible/commit/%H) -- %s ' --reverse | grep -v "Merge" >> /tmp/changelog.top
echo -e "\n\n" >> /tmp/changelog.top

cat CHANGELOG.md >> /tmp/changelog.top
mv /tmp/changelog.top CHANGELOG.md
rm -f /tmp/changelog.top
