#!/bin/sh

BASEDIR=`pwd`

cd $BASEDIR
if [[ ! -d ../desktop ]]; then
	cd ..
	git svn clone svn://svn.openwrt.org/openwrt/feeds/desktop
fi

cd $BASEDIR
if [[ ! -d ../hairmare ]]; then
	cd ..
	echo 'nope'
	exit
fi

if [[ ! -d ../openwrt ]]; then
	cd ..
	git clone git://nbd.name/openwrt.git
	cd openwrt
	echo 'src-git packages git://nbd.name/packages.git
src-git desktop /home/openwrt/git.repos/desktop
src-git qi git://projects.qi-hardware.com/openwrt-packages.git
src-git hairmare /home/openwrt/git.repos/hairmare
'>feeds.conf
	./scripts/feeds update
	cd -
fi;

cd $BASEDIR
cd desktop
git svn rebase

cd $BASEDIR
cd openwrt
git pull
./scripts/feeds update
./scripts/feeds install mpd
./scripts/feeds install mpdas
./scripts/feeds install pympdtouchgui

cp $BASEDIR/openwrt.config .config

make world
