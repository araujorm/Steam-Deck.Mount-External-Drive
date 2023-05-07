# READ THIS FIRST
This script is based on the one written by scawp - https://github.com/scawp/Steam-Deck.Mount-External-Drive - and a fork by flavioislima - https://github.com/flavioislima/Steam-Deck.Mount-External-Drive.git

## Steam-Deck.Mount-External-Drive
Configuration to Auto-Mount External USB SSD on the Steam Deck

## How does this work?

A `udev` rule is added to `/etc/udev/rules.d/99-external-drive-mount.rules`
which calls systemd `/etc/systemd/system/external-drive-mount@[sda1|sda2|sdd1|etc].service`
that then runs Valve's `/usr/lib/hwsupport/sdcard-mount.sh` to Auto Mount any plugged in USB Storage Device.

`/etc/fstab` is not required for mounting in this way, (however if a Device has an `fstab` entry these scripts will still work)

## Operation

The External Drive(s) will be Auto-Mounted to `/run/media/deck/[LABEL]` eg `/run/media/deck/External-ssd/` if the Device has no `label` then the Devices `UUID` will be used eg `/run/media/deck/a12332-12bf-a33ab-eef/`

### NOTE!

Drive requires prior formatting (currently tested with NTFS, Ext4, btrfs, NOTE: btrfs mounts with incorrect ownership, TODO). All Partitions will be Mounted on Boot and /or On Insert.

## Installation

## Via Curl (One Line Install)

In Konsole type `curl -sSL https://raw.githubusercontent.com/araujorm/Steam-Deck.Mount-External-Drive/master/curl_install.sh | bash`

a `sudo` password is required (run `passwd` if required first)

## Uninstall

`sudo rm /etc/udev/rules.d/99-external-drive-mount.rules`

`sudo rm /etc/systemd/system/external-drive-mount@.service`

`sudo udevadm control --reload`

`sudo systemctl daemon-reload`

## WORK IN PROGRESS!

This will probably have bugs, so beware! log bugs under [issues](https://github.com/araujorm/Steam-Deck.Mount-External-Drive/issues)!
