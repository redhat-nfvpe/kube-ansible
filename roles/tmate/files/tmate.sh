#!/bin/bash

# Flush out existing keys & create new
rm -f /home/centos/.ssh/id_rsa*
ssh-keygen -b 2048 -t rsa -f /home/centos/.ssh/id_rsa -q -N ""

# Kill tmate processes if they exist.
if foo=$(pgrep "tmate -S"); then
  pgrep "tmate -S" | xargs kill -9
fi
rm -Rf /tmp/tmate*

# Spin up two tmate sessions (one for a backup)
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready
tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}"

tmate -S /tmp/tmate2.sock new-session -d
tmate -S /tmp/tmate2.sock wait tmate-ready
tmate -S /tmp/tmate2.sock display -p "#{tmate_ssh}"
