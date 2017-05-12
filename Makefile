include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-syncdial
PKG_VERSION:=20170513
PKG_RELEASE:=1
PKG_MAINTAINER:=fw867

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
#PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	PKGARCH:=all
	TITLE:=luci for syncdial
        DEPENDS:=+kmod-macvlan
endef

define Package/$(PKG_NAME)/description
    A luci app for syncdial, forked from koolshare Lede X64. Thanks to fw867.
endef

define Package/$(PKG_NAME)/preinst
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	if [ -f /etc/uci-defaults/luci-syncdial ]; then
		( . /etc/uci-defaults/luci-syncdial ) && rm -f /etc/uci-defaults/luci-syncdial
	fi
	rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
fi
exit 0
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/postrm
exit 0
endef

define Package/$(PKG_NAME)/install

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/etc/uci-defaults/luci-syncdial $(1)/etc/uci-defaults/luci-syncdial

	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_CONF) ./files/etc/hotplug.d/iface/01-dialcheck $(1)/etc/hotplug.d/iface/01-dialcheck
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/syncdial $(1)/etc/config/
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/* $(1)/etc/init.d/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/*.lua $(1)/usr/lib/lua/luci/controller/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/syncdial.lua $(1)/usr/lib/lua/luci/model/cbi/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/syncdial
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/view/syncdial/* $(1)/usr/lib/lua/luci/view/syncdial/


endef

$(eval $(call BuildPackage,$(PKG_NAME)))