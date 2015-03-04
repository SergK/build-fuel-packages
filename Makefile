.PHONY: all clean test help deep_clean

help:
	@echo 'Build directives (can be overrided by environment variables'
	@echo 'or by command line parameters):'
	@echo '  SOURCE_DIR:       $(SOURCE_DIR)'
	@echo '  BUILD_DIR:        $(BUILD_DIR)'
	@echo '  YUM_REPOS:        $(YUM_REPOS)'
	@echo '  MIRROR_CENTOS:    $(MIRROR_CENTOS)'
	@echo '  EXTRA_RPM_REPOS:  $(EXTRA_RPM_REPOS)'
	@echo '  EXTRA_DEB_REPOS:  $(EXTRA_DEB_REPOS)'
	@echo
	@echo 'Available targets:'
	@echo '  all  				 - build all packages'
	@echo '  packages-rpm  - build all rpm packages'
	@echo '  packages-deb  - build all deb packages'
	@echo '  clean - remove build directory and resetting .done flags'
	@echo


# Path to the sources.
# Default value: directory with Makefile
SOURCE_DIR?=$(dir $(lastword $(MAKEFILE_LIST)))
SOURCE_DIR:=$(abspath $(SOURCE_DIR))

all: packages

clean:
	sudo rm -rf $(BUILD_DIR)

# Common configuration file.
include $(SOURCE_DIR)/config.mk

# Macroses for make
include $(SOURCE_DIR)/rules.mk

# Sandbox macroses.
include $(SOURCE_DIR)/sandbox.mk

# Modules
include $(SOURCE_DIR)/packages/module.mk
include $(SOURCE_DIR)/repos.mk
