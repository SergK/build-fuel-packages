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
	@echo '  all  - build product'
	@echo '  clean - remove build directory and resetting .done flags'
	@echo '  deep_clean - clean + removing $(LOCAL_MIRROR) directory'
	@echo '  distclean - cleans deep_clean + clean-integration-test'
	@echo


# Path to the sources.
# Default value: directory with Makefile
SOURCE_DIR?=$(dir $(lastword $(MAKEFILE_LIST)))
SOURCE_DIR:=$(abspath $(SOURCE_DIR))

all: iso

test: test-unit test-integration

clean:
	sudo rm -rf $(BUILD_DIR)
deep_clean: clean
	sudo rm -rf $(LOCAL_MIRROR)

distclean: deep_clean

# Common configuration file.
include $(SOURCE_DIR)/config.mk

# Macroses for make
include $(SOURCE_DIR)/rules.mk

# Sandbox macroses.
include $(SOURCE_DIR)/sandbox.mk

# Modules
include $(SOURCE_DIR)/packages/module.mk
include $(SOURCE_DIR)/repos.mk
