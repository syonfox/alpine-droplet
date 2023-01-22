#!/usr/bin/env sh

echo 'cloning submodules...'
git submodule update --init --recursive ;
#git submodule foreach git pull origin master ## update

echo "installing pakages..."
apk add qemu qemu-img qemu-system-x86_64 e2fsprogs bzip2 ;


echo "done please run: ash build-image-hapi.sh"
