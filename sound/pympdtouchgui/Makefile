
include $(TOPDIR)/rules.mk

PKG_NAME:=pympdtouchgui
PKG_VERSION:=0.328
PKG_RELEASE:=0

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VSERION).tgz
PKG_SOURCE_URL:=http://www.spida.net/projects/software/pympdtouchgui/
PKG_MD5SUM:=e1e895d245d0f2c94a1038d47c24cc01
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/pympdtouchgui
  SECTION:=sound
  CATEGORY:=sound
  DEPENDS:=+pygame +twisted
  TITLE:=PyMPDTouchGUI - MPD Client for Touchscreens
  URL:=http://www.spida.net/projects/software/pympdtouchgui/
endef

define Package/description
	PyMPDTouchGui is an mpd-client to be used via a touchscreen on a embedded-system
endef

define Package/pympdtouchgui/install
	$(INSTALL_DIR) $(1)/etc
endef

$(eval $(call BuildPackage,pympdtouchgui))
