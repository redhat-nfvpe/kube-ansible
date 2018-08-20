#!/bin/bash
./contrib/multi-cluster/extravars-creator.sh $1
./contrib/multi-cluster/multi-spinup.sh $1
./contrib/multi-cluster/multi-init.sh $1
