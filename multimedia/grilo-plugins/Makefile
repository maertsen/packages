#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=grilo-plugins
PKG_VERSION:=0.3.17
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@GNOME/grilo-plugins/$(basename $(PKG_VERSION))
PKG_HASH:=483c03f2ce06f96d42b85768fdc494c076d58474bf8e3c326f5a050fd4a2f03c

PKG_MAINTAINER:=W. Michael Petullo <mike@flyn.org>
PKG_LICENSE:=LGPL-2.1-or-later
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk
include $(INCLUDE_DIR)/meson.mk

define Package/grilo-plugins/Default
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=grilo-plugins
  URL:=https://wiki.gnome.org/Projects/Grilo
endef

define Package/grilo-plugins
  $(call Package/grilo-plugins/Default)
  MENU:=1
  DEPENDS:=+grilo $(ICONV_DEPENDS) $(INTL_DEPENDS)
  TITLE:=Plugins for the Grilo framework
endef

define Package/grilo/decription
  Grilo is a framework that provides access to different sources of
  multimedia content, using a pluggable system. This package contains
  plugins to get information from a number of sources.
endef

MESON_ARGS += \
	-Denable-bookmarks=no \
	-Denable-chromaprint=$(if $(CONFIG_PACKAGE_grilo-plugins-chromaprint),yes,no) \
	-Denable-dleyna=$(if $(CONFIG_PACKAGE_grilo-plugins-dleyna),yes,no) \
	-Denable-dmap=$(if $(CONFIG_PACKAGE_grilo-plugins-dmap),yes,no) \
	-Denable-filesystem=no \
	-Denable-flickr=no \
	-Denable-freebox=no \
	-Denable-gravatar=$(if $(CONFIG_PACKAGE_grilo-plugins-gravatar),yes,no) \
	-Dhelp=no \
	-Denable-local-metadata=no \
	-Denable-lua-factory=no \
	-Denable-magnatune=$(if $(CONFIG_PACKAGE_grilo-plugins-magnatune),yes,no) \
	-Denable-metadata-store=$(if $(CONFIG_PACKAGE_grilo-plugins-metadata-store),yes,no) \
	-Denable-optical-media=no \
	-Denable-podcasts=no \
	-Denable-shoutcast=$(if $(CONFIG_PACKAGE_grilo-plugins-shoutcast),yes,no) \
	-Denable-thetvdb=no \
	-Denable-tmdb=$(if $(CONFIG_PACKAGE_grilo-plugins-tmdb),yes,no) \
	-Denable-tracker=no \
	-Denable-tracker3=no \
	-Denable-youtube=no \
	--wrap-mode=nodownload

define Package/grilo-plugins/install
	$(INSTALL_DIR) $(1)/usr/lib/grilo-0.3
endef

define BuildPlugin
  define Package/grilo-plugins-$(1)
    $(call Package/grilo-plugins/Default)
    DEPENDS:=grilo-plugins
    ifneq ($(4),)
      DEPENDS+= $(4)
    endif
    TITLE:=$(2) plugin
  endef

  define Package/grilo-plugins-$(1)/install
	$(INSTALL_DIR) $$(1)/usr/lib/grilo-0.3
	for p in $(3); do \
		$(CP) $(PKG_INSTALL_DIR)/usr/lib/grilo-0.3/libgrl$$$$$$$${p}.so $$(1)/usr/lib/grilo-0.3; \
	done
  endef

  $$(eval $$(call BuildPackage,grilo-plugins-$(1)))
endef

$(eval $(call BuildPackage,grilo-plugins))

$(eval $(call BuildPlugin,chromaprint,Chromaprint,chromaprint,+libgstreamer1,30))
$(eval $(call BuildPlugin,dleyna,DLNA sharing,dleyna,,30))
$(eval $(call BuildPlugin,dmap,DAAP and DPAP sharing,daap dpap,libdmapsharing,30))
$(eval $(call BuildPlugin,gravatar,Gravatar provider,gravatar,,30))
$(eval $(call BuildPlugin,magnatune,Magnatune sharing,magnatune,,30))
$(eval $(call BuildPlugin,metadata-store,Metadata Store,metadatastore,,30))
$(eval $(call BuildPlugin,shoutcast,SHOUTcast sharing,shoutcast,,30))
$(eval $(call BuildPlugin,tmdb,TMDb,tmdb,+json-glib,30))
