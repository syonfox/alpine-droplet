# Digital Ocean Alpine Linux Image Generator

Hello welcome to the ENDpoint fork of alpine vm image.

In this repository we have the scripts to build a few of our base images for both digital ocean and xen

In general `build-image*.sh` scripts will actually build an alpine image and zip it.

These scripts run a `setup*.sh` inside the alpine environment allowing dependency installation


## About
This is a tool to generate an Alpine Linux custom image for Digital Ocean. This ensures that the droplet will correctly configure networking and SSH on first boot using Digital Ocean's metadata service. To use this tool make sure you have `qemu-nbd`, `qemu-img`, `bzip2` and `e2fsprogs` installed. This will not work under the Windows Subsystem for Linux (WSL) as it mounts the image during generation.

## Usage

To get your **ALPINE LINUX**  image build environment setup run
```sh
ash install_alpine_build_dependancies.sh
```

This works on alpine:
```bash
git clone https://github.com/syonfox/alpine-droplet.git ;
cd alpine-droplet/ ;
git submodule update --init --recursive ;
#git submodule foreach git pull origin master ## update

apk add qemu qemu-img qemu-system-x86_64 e2fsprogs bzip2;

# actualy build an image
./build-image.sh ;
# not this runs setup??? in the alpine image
```

Note: Need root permission.

This will produce `alpine-virt-image-{timestamp}.qcow2.bz2` which can then be uploaded to Digital Ocean and used to create your droplet. Check out their instructions at https://blog.digitalocean.com/custom-images/ for uploading the image and creating your droplet.

In this commit, the script will produce alpine `version 3.15` image. If you wanna build latest version, you can pull latest [alpine-make-vm-image repo](https://github.com/alpinelinux/alpine-make-vm-image): `git submodule foreach git pull origin master`


## forked for my internal systems configuration big thanks to the original authors

@jirutka [alpine-make-vm-image](https://github.com/alpinelinux/alpine-make-vm-image)
@benpye [alpine-droplet](https://github.com/benpye/alpine-droplet)

