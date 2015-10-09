.PHONY: all clean help

help:
	@echo 'Build directives (can be overrided by environment variables'

# Path to the sources.
# Default value: directory with Makefile
SOURCE_DIR?=$(dir $(lastword $(MAKEFILE_LIST)))
SOURCE_DIR:=$(abspath $(SOURCE_DIR))

all: all

clean:
	sudo rm -rf $(BUILD_DIR)

# Common configuration file.
include $(SOURCE_DIR)/config.mk

# Modules
include $(SOURCE_DIR)/repos.mk
include $(SOURCE_DIR)/sources.mk
