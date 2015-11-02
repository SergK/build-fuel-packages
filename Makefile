.PHONY: all clean help

help:
	@echo 'all   - prepare all packages repos'
	@echo 'clean - clean targets'

# Path to the sources.
# Default value: directory with Makefile
SOURCE_DIR?=$(dir $(lastword $(MAKEFILE_LIST)))
SOURCE_DIR:=$(abspath $(SOURCE_DIR))

all: repos

clean:
	rm -rf $(BUILD_DIR)

# Common configuration file.
include $(SOURCE_DIR)/config.mk

# Modules
include $(SOURCE_DIR)/repos.mk
