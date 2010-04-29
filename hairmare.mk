repo/init: repo/desktop/init repo/hairmare/init repo/openwrt/init

repo/desktop/init: ../desktop
../desktop:
	cd .. && git svn clone svn://svn.openwrt.org/openwrt/feeds/desktop

repo/hairmare/init: ../hairmare
../hairmare:
	cd .. && git clone ...

repo/openwrt/init: ../openwrt
../openwrt:
	cd .. && git clone git://nbd.name/openwrt.git
feeds/install: ../openwrt/feeds.conf
../openwrt/feeds.conf: openwrt.feeds
	cp openwrt.feeds ../openwrt/feeds.conf
	cd ../openwrt && ./scripts/feeds update

repo/update: repo/desktop/update repo/openwrt/update

repo/desktop/update: repo/desktop/init
	cd ../desktop && git svn rebase
repo/openwrt/update:
	cd ../openwrt && git pull
	cd ../openwrt && ./scripts/feeds update
	
repo/world: feeds/install repo/openwrt/install
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
	
distro/docs: _site/docs _site/docs/index.html

_site/docs:
	mkdir -p _site/docs

_site/docs/index.html: html/*.js html/header.html html/footer.html HOWTO
	cp html/*.js _site/docs/
	cat html/header.html > _site/docs/index.html
	redcloth HOWTO >> _site/docs/index.html
	cat html/footer.html >> _site/docs/index.html
