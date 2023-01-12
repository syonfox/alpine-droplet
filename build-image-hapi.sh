#!/bin/sh

set -o errexit

F=alpine-virt-image-hapi-$(date +%Y-%m-%d-%H%M)

if [ "$CI" = "true" ]
then
    echo "Running under CI"
    echo $F > version
fi

./alpine-make-vm-image/alpine-make-vm-image --packages "openssh e2fsprogs-extra" -t --script-chroot --image-format qcow2 -- $F.qcow2 ./setup-hapi.sh
bzip2 -z $F.qcow2
