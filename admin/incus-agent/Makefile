PKG_NAME:=incus-agent
PKG_VERSION:=6.0.4
PKG_RELEASE:=1

PKG_MAINTAINER:=Maarten Aertsen <maarten@rtsn.nl>

include $(INCLUDE_DIR)/package.mk

define Package/incus-agent
  SECTION:=admin
  CATEGORY:=Administration
  TITLE:=Init script to copy and execute incus-agent when running OpenWRT in an Incus VM
  URL:=https://linuxcontainers.org/incus/
endef

define Package/incus-agent/description
  Incus is a next-generation system container, application container, and
  virtual machine manager. A built-in agent is provided by Incus to allow for
  interactive command execution and file transfers. Incus provides the agent
  through a remote 9p file system. This package install an init script to mount,
  copy and run incus-agent on boot.
endef

define Package/incus-agent/install
	$(INSTALL_DIR) $(1)/lib/functions
	$(INSTALL_BIN) ./files/incus_functions.sh $(1)/lib/functions/incus_functions.sh
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/incus_agent $(1)/etc/init.d/incus_agent
endef