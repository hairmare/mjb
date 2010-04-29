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
	cd ../openwrt && git apply ../mjb/patches/openwrt.patch

repo/packages/patch: patches/openwrt_packages.patch
	cd ../openwrt/feeds/packages/  && git apply ../../../mjb/patches/openwrt_packages.patch
	
repo/world: feeds/install repo/patch repo/openwrt/install
	cd ../openwrt && make world

repo/openwrt/install: package/dropbear/install
	cd ../openwrt && ./scripts/feeds install mpd
	cd ../openwrt && ./scripts/feeds install mpdas
	cd ../openwrt && ./scripts/feeds install pympdtouchgui
	cd ../openwrt && ./scripts/feeds install tslib
	cp openwrt.config ../openwrt/.config

package/dropbear/install:
	cp keys/default.rsa.pub ../openwrt/package/dropbear/files/dropbear.authorized_keys


distro/upload: distro/docs
	rsync -az --delete --force _site/ hairmare@hairmare.ch:/var/www/mjb.hairmare.ch/htdocs/
	
distro/docs: _site/docs _site/docs/index.html

_site/docs:
	mkdir -p _site/docs

_site/docs/index.html: html/*.js html/header.html html/footer.html HOWTO
	cp html/*.js _site/docs/
	cat html/header.html > _site/docs/index.html
	redcloth HOWTO >> _site/docs/index.html
	cat html/footer.html >> _site/docs/index.html
