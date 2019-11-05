#!/bin/bash

br_ver="2019.02.1"
mkdir -p ../download
ln -snf ../download download
( cd download && wget http://buildroot.uclibc.org/downloads/buildroot-${br_ver}.tar.gz )
tar -xvf download/buildroot-${br_ver}.tar.gz
ln -snf buildroot-${br_ver} buildroot
( cd buildroot && QUILT_PATCHES=$PWD/../patches-buildroot quilt push -a )
ARCH=x86_64
make ARCH=$ARCH br-source
make ARCH=$ARCH OUT_D=$PWD/output/$ARCH
./bin/system-setup
kver="5.3.0-18.19"
./bin/grab-kernels "$kver" $ARCH
gver="2.02~beta2-36ubuntu3.22"
./bin/grab-grub-efi "$gver" $ARCH
sudo ./bin/bundle --size=128M -v --arch=$ARCH output/$ARCH/rootfs.tar download/kernel-$ARCH.tar.gz download/grub-efi-$ARCH.tar.gz output/$ARCH/images

