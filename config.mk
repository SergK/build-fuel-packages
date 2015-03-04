#
# Build directives. Can be overrided by environment variables.
#

# Base path for build and mirror directories.
# Default value: current directory
TOP_DIR?=$(PWD)
TOP_DIR:=$(abspath $(TOP_DIR))
# Working build directory
BUILD_DIR?=$(TOP_DIR)/build
BUILD_DIR:=$(abspath $(BUILD_DIR))

PRODUCT_VERSION:=6.1

CENTOS_MAJOR:=6
CENTOS_MINOR:=5
CENTOS_RELEASE:=$(CENTOS_MAJOR).$(CENTOS_MINOR)
CENTOS_ARCH:=x86_64
CENTOS_IMAGE_RELEASE:=$(CENTOS_MAJOR)$(CENTOS_MINOR)
UBUNTU_RELEASE:=precise
UBUNTU_MAJOR:=12
UBUNTU_MINOR:=04
UBUNTU_RELEASE_NUMBER:=$(UBUNTU_MAJOR).$(UBUNTU_MINOR)
UBUNTU_ARCH:=amd64
SEPARATE_IMAGES?=/boot,ext2 /,ext4

# Use mock for building RPM packages, default - NO
USE_MOCK?=0

# Build OpenStack packages from external sources (do not use prepackaged versions)
# Enter the comma-separated list of OpenStack packages to build, or '0' otherwise.
# Example: BUILD_OPENSTACK_PACKAGES=neutron,keystone
BUILD_OPENSTACK_PACKAGES?=0

# Define a set of defaults for each OpenStack package
# For each component defined in BUILD_OPENSTACK_PACKAGES variable, this routine will set
# the following variables (i.e. for 'BUILD_OPENSTACK_PACKAGES=neutron'):
# NEUTRON_REPO, NEUTRON_COMMIT, NEUTRON_SPEC_REPO, NEUTRON_SPEC_COMMIT,
# NEUTRON_GERRIT_URL, NEUTRON_GERRIT_COMMIT, NEUTRON_GERRIT_URL,
# NEUTRON_SPEC_GERRIT_URL, NEUTRON_SPEC_GERRIT_COMMIT
define set_vars
    $(call uc,$(1))_REPO?=https://github.com/openstack/$(1).git
    $(call uc,$(1))_COMMIT?=master
    $(call uc,$(1))_SPEC_REPO?=https://review.fuel-infra.org/openstack-build/$(1)-build.git
    $(call uc,$(1))_SPEC_COMMIT?=master
    $(call uc,$(1))_GERRIT_URL?=https://review.openstack.org/openstack/$(1).git
    $(call uc,$(1))_GERRIT_COMMIT?=none
    $(call uc,$(1))_SPEC_GERRIT_URL?=https://review.fuel-infra.org/openstack-build/$(1)-build.git
    $(call uc,$(1))_SPEC_GERRIT_COMMIT?=none
endef

# Repos and versions
FUELLIB_COMMIT?=master
NAILGUN_COMMIT?=master
PYTHON_FUELCLIENT_COMMIT?=master
ASTUTE_COMMIT?=master
OSTF_COMMIT?=master

FUELLIB_REPO?=https://github.com/stackforge/fuel-library.git
NAILGUN_REPO?=https://github.com/stackforge/fuel-web.git
PYTHON_FUELCLIENT_REPO?=https://github.com/stackforge/python-fuelclient.git
ASTUTE_REPO?=https://github.com/stackforge/fuel-astute.git
OSTF_REPO?=https://github.com/stackforge/fuel-ostf.git

# Gerrit URLs and commits
FUELLIB_GERRIT_URL?=https://review.openstack.org/stackforge/fuel-library
NAILGUN_GERRIT_URL?=https://review.openstack.org/stackforge/fuel-web
PYTHON_FUELCLIENT_GERRIT_URL?=https://review.openstack.org/stackforge/python-fuelclient
ASTUTE_GERRIT_URL?=https://review.openstack.org/stackforge/fuel-astute
OSTF_GERRIT_URL?=https://review.openstack.org/stackforge/fuel-ostf

FUELLIB_GERRIT_COMMIT?=none
NAILGUN_GERRIT_COMMIT?=none
PYTHON_FUELCLIENT_GERRIT_COMMIT?=none
ASTUTE_GERRIT_COMMIT?=none
OSTF_GERRIT_COMMIT?=none

# Use download.mirantis.com mirror by default. Other possible values are
# 'msk', 'srt', 'usa', 'hrk'.
# Setting any other value or removing of this variable will cause
# download of all the packages directly from internet
USE_MIRROR?=ext
ifeq ($(USE_MIRROR),ext)
MIRROR_BASE?=http://mirror.fuel-infra.org/fwm/$(PRODUCT_VERSION)
MIRROR_CENTOS?=$(MIRROR_BASE)/centos
MIRROR_UBUNTU?=$(MIRROR_BASE)/ubuntu
MIRROR_CENTOS_KERNEL?=$(MIRROR_CENTOS)
endif
ifeq ($(USE_MIRROR),srt)
MIRROR_BASE?=http://osci-mirror-srt.srt.mirantis.net/fwm/$(PRODUCT_VERSION)
MIRROR_CENTOS?=$(MIRROR_BASE)/centos
MIRROR_UBUNTU?=$(MIRROR_BASE)/ubuntu
MIRROR_CENTOS_KERNEL?=$(MIRROR_CENTOS)
endif
ifeq ($(USE_MIRROR),msk)
MIRROR_BASE?=http://osci-mirror-msk.msk.mirantis.net/fwm/$(PRODUCT_VERSION)
MIRROR_CENTOS?=$(MIRROR_BASE)/centos
MIRROR_UBUNTU?=$(MIRROR_BASE)/ubuntu
MIRROR_CENTOS_KERNEL?=$(MIRROR_CENTOS)
endif
ifeq ($(USE_MIRROR),hrk)
MIRROR_BASE?=http://osci-mirror-kha.kha.mirantis.net/fwm/$(PRODUCT_VERSION)
MIRROR_CENTOS?=$(MIRROR_BASE)/centos
MIRROR_UBUNTU?=$(MIRROR_BASE)/ubuntu
MIRROR_CENTOS_KERNEL?=$(MIRROR_CENTOS)
endif

MIRROR_CENTOS?=http://mirrors-local-msk.msk.mirantis.net/centos-$(PRODUCT_VERSION)/$(CENTOS_RELEASE)
MIRROR_CENTOS_KERNEL?=http://mirror.centos.org/centos-6/6.6/
MIRROR_CENTOS_OS_BASEURL:=$(MIRROR_CENTOS)/os/$(CENTOS_ARCH)
MIRROR_CENTOS_KERNEL_BASEURL?=$(MIRROR_CENTOS_KERNEL)/os/$(CENTOS_ARCH)
MIRROR_UBUNTU?=http://mirrors-local-msk.msk.mirantis.net/ubuntu-$(PRODUCT_VERSION)/
# Unfortunately security updates are handled in a manner incompatible with
# Debian/Ubuntu. That is, instead of having ${UBUNTU_RELEASE}-updates
# directory there's a different APT repo with security updates residing
# in ${UBUNTU_RELEASE}/main
MIRROR_UBUNTU_SECURITY?=http://mirrors-local-msk.msk.mirantis.net/ubuntu-security-$(PRODUCT_VERSION)/
MIRROR_UBUNTU_OS_BASEURL:=$(MIRROR_UBUNTU)
