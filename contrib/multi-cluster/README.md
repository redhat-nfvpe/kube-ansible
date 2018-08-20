# Multi-cluster creator!

A series of scripts designed to spin up multiple clusters at once. Originally designed for a tutorial / classroom setup where you're spinning up a cluster for each attendee to use.

These scripts are designed to be run from the root directory.

These scripts expect your virthost inventory to live @ `./inventory/virthost.inventory`.

It might be convenient to set the number of clusters like so:

```
export CLUSTERS=3
```

## Run it all at once...

```
./contrib/multi-cluster/all.sh $CLUSTERS
```

## Or break it into parts...

Run it with the number of clusters you're going to create.

```
./contrib/multi-cluster/extravars-creator.sh $CLUSTERS
```

Then you can run the multi spinup...

```
./contrib/multi-cluster/multi-spinup.sh $CLUSTERS
```

Bring up the kube clusters with a multi init...

```
./contrib/multi-cluster/multi-init.sh $CLUSTERS
```

And tear 'em down with the multi-teardown...

```
./contrib/multi-cluster/multi-teardown.sh $CLUSTERS
```
