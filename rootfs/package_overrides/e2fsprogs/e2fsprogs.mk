################################################################################
#
# e2fsprogs
#
################################################################################

E2FSPROGS_VERSION = 1.47.0
E2FSPROGS_SOURCE = e2fsprogs-$(E2FSPROGS_VERSION).tar.gz
E2FSPROGS_SITE = https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v$(E2FSPROGS_VERSION)
E2FSPROGS_LICENSE = GPL-2.0, LGPL-2.0, BSD-3-Clause, MIT
E2FSPROGS_LICENSE_FILES = NOTICE
E2FSPROGS_CPE_ID_VENDOR = e2fsprogs_project
E2FSPROGS_INSTALL_STAGING = YES

E2FSPROGS_DEPENDENCIES = util-linux

# use libblkid and libuuid from util-linux for host and target packages
E2FSPROGS_CONF_OPTS = \
	--enable-elf-shlibs \
	--enable-symlink-install \
	--enable-relative-symlinks \
	--disable-defrag \
	--disable-fsck \
	--disable-e2initrd-helper \
	--disable-libblkid \
	--disable-libuuid \
	--disable-testio-debug \
	--disable-rpath \
	--disable-fuse2fs \
	--with-crond-dir=no \
	--with-systemd-unit-dir=no

HOST_E2FSPROGS_DEPENDENCIES = host-util-linux
HOST_E2FSPROGS_CONF_OPTS = \
	--enable-elf-shlibs \
	--disable-defrag \
	--disable-e2initrd-helper \
	--disable-fsck \
	--disable-libblkid \
	--disable-libuuid \
	--disable-testio-debug \
	--disable-rpath

# util-linux installs libuuid and libblkid, but e2fsprogs also
# installs them, which leads to a build failure. We workaround this
# by removing e2fsprogs libuuid/libblkid .pc files after installation
define E2FSPROGS_REMOVE_LIBUUID_LIBBLKID_PC
	rm -f $(STAGING_DIR)/usr/lib/pkgconfig/uuid.pc
	rm -f $(STAGING_DIR)/usr/lib/pkgconfig/blkid.pc
endef

E2FSPROGS_POST_INSTALL_STAGING_HOOKS += E2FSPROGS_REMOVE_LIBUUID_LIBBLKID_PC

ifeq ($(BR2_PACKAGE_E2FSPROGS_DEBUGFS),y)
E2FSPROGS_CONF_OPTS += --enable-debugfs
else
E2FSPROGS_CONF_OPTS += --disable-debugfs
endif

ifeq ($(BR2_PACKAGE_E2FSPROGS_E2IMAGE),y)
E2FSPROGS_CONF_OPTS += --enable-imager
else
E2FSPROGS_CONF_OPTS += --disable-imager
endif

ifeq ($(BR2_PACKAGE_E2FSPROGS_E4DEFRAG),y)
E2FSPROGS_CONF_OPTS += --enable-defrag
endif

ifeq ($(BR2_PACKAGE_E2FSPROGS_FSCK),y)
E2FSPROGS_CONF_OPTS += --enable-fsck
endif

ifeq ($(BR2_PACKAGE_E2FSPROGS_FUSE2FS),y)
E2FSPROGS_CONF_OPTS += --enable-fuse2fs
E2FSPROGS_DEPENDENCIES += libfuse
endif

ifeq ($(BR2_PACKAGE_E2FSPROGS_RESIZE2FS),y)
E2FSPROGS_CONF_OPTS += --enable-resizer
else
E2FSPROGS_CONF_OPTS += --disable-resizer
endif

# Some programs are built but not installed by default
define E2FSPROGS_INSTALL_TARGET_PROGS
	$(if $(BR2_PACKAGE_E2FSPROGS_BADBLOCKS),
		$(INSTALL) -m 0755 $(@D)/misc/badblocks $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_CHATTR),
		$(INSTALL) -m 0755 $(@D)/misc/chattr $(TARGET_DIR)/usr/bin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_DUMPE2FS),
		$(INSTALL) -m 0755 $(@D)/misc/dumpe2fs $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_E2FREEFRAG),
		$(INSTALL) -m 0755 $(@D)/misc/e2freefrag $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_E2FSCK),
		$(INSTALL) -m 0755 $(@D)/e2fsck/e2fsck $(TARGET_DIR)/sbin
		ln -sf ../sbin/e2fsck $(TARGET_DIR)/usr/sbin/fsck.ext2
		ln -sf ../sbin/e2fsck $(TARGET_DIR)/usr/sbin/fsck.ext3
		ln -sf ../sbin/e2fsck $(TARGET_DIR)/usr/sbin/fsck.ext4
		ln -sf ../sbin/e2fsck $(TARGET_DIR)/usr/sbin/fsck.ext4dev
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_E2LABEL),
		$(INSTALL) -m 0755 $(@D)/misc/e2label $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_E2UNDO),
		$(INSTALL) -m 0755 $(@D)/misc/e2undo $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_FILEFRAG),
		$(INSTALL) -m 0755 $(@D)/misc/filefrag $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_FINDFS),
		$(INSTALL) -m 0755 $(@D)/misc/findfs $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_LOGSAVE),
		$(INSTALL) -m 0755 $(@D)/misc/logsave $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_LSATTR),
		$(INSTALL) -m 0755 $(@D)/misc/lsattr $(TARGET_DIR)/usr/bin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_MKE2FS),
		$(INSTALL) -m 0755 $(@D)/misc/mke2fs $(TARGET_DIR)/usr/sbin
		ln -sf mke2fs $(TARGET_DIR)/usr/sbin/mkfs.ext2
		ln -sf mke2fs $(TARGET_DIR)/usr/sbin/mkfs.ext3
		ln -sf mke2fs $(TARGET_DIR)/usr/sbin/mkfs.ext4
		ln -sf mke2fs $(TARGET_DIR)/usr/sbin/mkfs.ext4dev
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_MKLOSTFOUND),
		$(INSTALL) -m 0755 $(@D)/misc/mklost+found $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_TUNE2FS),
		$(INSTALL) -m 0755 $(@D)/misc/tune2fs $(TARGET_DIR)/usr/sbin
	)
	$(if $(BR2_PACKAGE_E2FSPROGS_UUIDGEN),
		$(INSTALL) -m 0755 $(@D)/misc/uuidgen $(TARGET_DIR)/usr/bin
	)
endef

E2FSPROGS_POST_INSTALL_TARGET_HOOKS += E2FSPROGS_INSTALL_TARGET_PROGS

$(eval $(autotools-package))
$(eval $(host-autotools-package)) 