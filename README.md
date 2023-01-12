# Digital Ocean Alpine Linux Image Generator


## About
This is a tool to generate an Alpine Linux custom image for Digital Ocean. This ensures that the droplet will correctly configure networking and SSH on first boot using Digital Ocean's metadata service. To use this tool make sure you have `qemu-nbd`, `qemu-img`, `bzip2` and `e2fsprogs` installed. This will not work under the Windows Subsystem for Linux (WSL) as it mounts the image during generation.

## Usage
This works on alpine:
```bash
git clone https://github.com/syonfox/alpine-droplet.git ;
cd alpine-droplet/ ;
git submodule update --init --recursive ;
#git submodule foreach git pull origin master ## update
apk add qemu qemu-img qemu-system-x86_64 ;
./build-image.sh ;
```

Note: Need root permission.

This will produce `alpine-virt-image-{timestamp}.qcow2.bz2` which can then be uploaded to Digital Ocean and used to create your droplet. Check out their instructions at https://blog.digitalocean.com/custom-images/ for uploading the image and creating your droplet.

In this commit, the script will produce alpine `version 3.15` image. If you wanna build latest version, you can pull latest [alpine-make-vm-image repo](https://github.com/alpinelinux/alpine-make-vm-image): `git submodule foreach git pull origin master`


## forked for my internal systems configuration big thanks to the original authors

@jirutka [alpine-make-vm-image](https://github.com/alpinelinux/alpine-make-vm-image)
@benpye [alpine-droplet](https://github.com/benpye/alpine-droplet)

