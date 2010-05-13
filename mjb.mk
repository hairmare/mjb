repo/init: repo/desktop/init repo/mjb/init repo/openwrt/init

repo/desktop/init: ../desktop
../desktop:
	cd .. && git svn clone svn://svn.openwrt.org/openwrt/feeds/desktop

repo/mjb/init: ../mjb
../mjb:
	cd .. && git clone git://github.com/hairmare/mjb.git

repo/openwrt/init: ../openwrt
../openwrt:
	cd .. && git clone git://nbd.name/openwrt.git

feeds/install: ../openwrt/feeds.conf repo/init 
../openwrt/feeds.conf: openwrt.feeds
	cp openwrt.feeds ../openwrt/feeds.conf
	cd ../openwrt && ./scripts/feeds update

repo/update: repo/desktop/update repo/openwrt/update

repo/desktop/update: repo/desktop/init
	cd ../desktop && git svn rebase
repo/openwrt/update:
	cd ../openwrt && git pull
	cd ../openwrt && ./scripts/feeds update

repo/patch: feeds/install repo/openwrt/patch repo/packages/patch

repo/openwrt/patch: patches/openwrt.patch 
	cd ../openwrt && if [[ ! -f .mjb.patched ]]; then \
		git apply ../mjb/patches/openwrt.patch; \
		git apply ../mjb/patches/openwrt_fbdev.patch; \
	fi
	touch ../openwrt/.mjb.patched

repo/packages/patch: patches/openwrt_packages.patch 
	cd ../openwrt/feeds/packages/  && if [[ ! -f .mjb.patched ]]; then git apply ../../../mjb/patches/openwrt_packages.patch; fi
	touch ../openwrt/feeds/packages/.mjb.patched
	
repo/world: feeds/install repo/patch repo/openwrt/install
	cd ../openwrt && make world

repo/openwrt/install: package/dropbear/install package/tslib/install
	cd ../openwrt && ./scripts/feeds install mpd
	cd ../openwrt && ./scripts/feeds install mpdas
	cd ../openwrt && ./scripts/feeds install pympdtouchgui
	cd ../openwrt && ./scripts/feeds install tslib
	cd ../openwrt && ./scripts/feeds install libavahi
	cd ../openwrt && ./scripts/feeds install libdaemon
	cd ../openwrt && ./scripts/feeds install libexpat 
	cd ../openwrt && ./scripts/feeds install libgdbm
	cd ../openwrt && ./scripts/feeds install libid3tag
	cd ../openwrt && ./scripts/feeds install libsdl-ttf
	cd ../openwrt && ./scripts/feeds install libsdl-image
	cd ../openwrt && ./scripts/feeds install uclibcxx
	cd ../openwrt && ./scripts/feeds install avahi-daemon
	cd ../openwrt && ./scripts/feeds install alsa-utils
	cd ../openwrt && ./scripts/feeds install event_test
	cd ../openwrt && ./scripts/feeds install mountd
	cd ../openwrt && ./scripts/feeds install lame
	cd ../openwrt && ./scripts/feeds install mpc
	cp openwrt.config ../openwrt/.config

package/dropbear/install:
	cp keys/default.rsa.pub ../openwrt/package/dropbear/files/dropbear.authorized_keys

package/tslib/install: ../openwrt/dl/tslib-1.0.84.tar.bz2
../openwrt/dl/tslib-1.0.84.tar.bz2: ../tslib-1.0.84.tar.gz
	cp ../tslib/tslib-1.0.84.tar.bz2 ../openwrt/dl/
../tslib-1.0.84.tar.gz: ../tslib/tslib-1.0.84
	cd ../tslib && tar jcvf tslib-1.0.84.tar.gz tslib-1.0.84/
../tslib/tslib-1.0.84: ../tslib
	cp -r ../tslib/tslib ../tslib/tslib-1.0.84
../tslib:
	cd ../ && git svn clone svn://svn.berlios.de/tslib/trunk tslib
	

distro/upload: distro/site
	rsync -az --delete --force _site/ hairmare.ch:/var/www/mjb.hairmare.ch/htdocs/

distro/site:distro/docs distro/page
	
distro/page: html/index.textile
	cp html/*.js _site/
	cat html/header.html > _site/index.html
	redcloth html/index.textile >> _site/index.html
	cat html/footer.html >> _site/index.html

distro/docs: _site/docs _site/docs/index.html 

_site/docs:
	mkdir -p _site/docs

_site/docs/index.html: html/*.js html/header.html html/footer.html HOWTO
	cat html/header.html > _site/docs/index.html
	redcloth HOWTO >> _site/docs/index.html
	cat html/footer.html >> _site/docs/index.html
