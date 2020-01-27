# Modifications to consider for multi-user setup

## Missions (tf files + startup scripts)

### Mission 1

Version control in buckets.
No big recommendation. Small enough, and compartimented enough

### Mission 2

Bastion + server, find key for server by metadata query.
Reusable but not very interesting. Perhaps plug another piece on it (i.e. fuse missions 1 & 2).

### Mission 3

Snapshot of instance to mount.
Based almost only on the mount of another volume on the instance, i.e. once it is mounted, challenge is ruined for other users. Recommend complete redesign in order to create a more suitable mission for multi-users.


### Mission 4

Suitable. Still need to be finished.

### Mission 5

Far far far too large for multi-users.

Reusable parts:
-SSRF (layer 1)
-Key creation (layer 1)
-Log dumper/DDB-handler (layer 3)

Parts that should not be reused:
-Mail server. Too complicated, too much of a hassle. (layer 2)
-Honey pot, one-off. (layer 2)

## Bash

### Salvage

startup/destroy script parts
start.sh is not really relevant, but the structure can be scavenged and used in another script supposed to run it several times
config.sh is easily reused though maybe not relevant (will users need to whitelist? accounts hardcoded, etc)

### Add

Add an AWS account database
Add a way to "scroll" through accounts for each deployment execution (1 backend per account/cell)
Reset button for each cell

## Fun parts that can be added:

attack through login profile update on console (and not cli)
