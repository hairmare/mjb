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
	cd ../openwrt && if [[ ! -f .mjb.patched ]]; then git apply ../mjb/patches/openwrt.patch; fi
	touch ../openwrt/.mjb.patched

repo/packages/patch: patches/openwrt_packages.patch 
	cd ../openwrt/feeds/packages/  && if [[ ! -f .mjb.patched ]]; then git apply ../../../mjb/patches/openwrt_packages.patch; fi
	touch ../openwrt/feeds/packages/.mjb.patched
	
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
