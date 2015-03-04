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
UBUNTU_KERNEL_FLAVOR?=lts-trusty
UBUNTU_NETBOOT_FLAVOR?=trusty-netboot
UBUNTU_ARCH:=amd64
UBUNTU_IMAGE_RELEASE:=$(UBUNTU_MAJOR)$(UBUNTU_MINOR)
SEPARATE_IMAGES?=/boot,ext2 /,ext4

# Use mock for building RPM packages, default - NO
USE_MOCK?=0

# Rebuld packages locally (do not use upstream versions)
BUILD_PACKAGES?=1
BUILD_DEB_PACKAGES?=1
ifeq (0,$(strip BUILD_PACKAGES))
BUILD_DEB_PACKAGES?=0
endif

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
YUM_REPOS?=proprietary
MIRROR_BASE?=http://mirror.fuel-infra.org/fwm/$(PRODUCT_VERSION)
MIRROR_CENTOS?=$(MIRROR_BASE)/centos
MIRROR_UBUNTU?=$(MIRROR_BASE)/ubuntu
MIRROR_DOCKER?=$(MIRROR_BASE)/docker
MIRROR_CENTOS_KERNEL?=$(MIRROR_CENTOS)
endif
ifeq ($(USE_MIRROR),srt)
YUM_REPOS?=proprietary
MIRROR_BASE?=http://osci-mirror-srt.srt.mirantis.net/fwm/$(PRODUCT_VERSION)
MIRROR_CENTOS?=$(MIRROR_BASE)/centos
MIRROR_UBUNTU?=$(MIRROR_BASE)/ubuntu
MIRROR_DOCKER?=$(MIRROR_BASE)/docker
MIRROR_CENTOS_KERNEL?=$(MIRROR_CENTOS)
endif
ifeq ($(USE_MIRROR),msk)
YUM_REPOS?=proprietary
MIRROR_BASE?=http://osci-mirror-msk.msk.mirantis.net/fwm/$(PRODUCT_VERSION)
MIRROR_CENTOS?=$(MIRROR_BASE)/centos
MIRROR_UBUNTU?=$(MIRROR_BASE)/ubuntu
MIRROR_DOCKER?=$(MIRROR_BASE)/docker
MIRROR_CENTOS_KERNEL?=$(MIRROR_CENTOS)
endif
ifeq ($(USE_MIRROR),hrk)
YUM_REPOS?=proprietary
MIRROR_BASE?=http://osci-mirror-kha.kha.mirantis.net/fwm/$(PRODUCT_VERSION)
MIRROR_CENTOS?=$(MIRROR_BASE)/centos
MIRROR_UBUNTU?=$(MIRROR_BASE)/ubuntu
MIRROR_DOCKER?=$(MIRROR_BASE)/docker
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
MIRROR_DOCKER?=http://mirror.fuel-infra.org/fwm/$(PRODUCT_VERSION)/docker
MIRROR_DOCKER_BASEURL:=$(MIRROR_DOCKER)
# MIRROR_FUEL option is valid only for 'fuel' YUM_REPOS section
# and ignored in other cases
MIRROR_FUEL?=http://osci-obs.vm.mirantis.net:82/centos-fuel-$(PRODUCT_VERSION)-stable/centos/
MIRROR_FUEL_UBUNTU?=http://osci-obs.vm.mirantis.net:82/ubuntu-fuel-$(PRODUCT_VERSION)-stable/reprepro

# Which repositories to use for making local centos mirror.
# Possible values you can find out from mirror/centos/yum_repos.mk file.
# The actual name will be constracted wich prepending "yum_repo_" prefix.
# Example: YUM_REPOS?=official epel => yum_repo_official and yum_repo_epel
# will be used.
YUM_REPOS?=official fuel subscr_manager

# Additional CentOS repos.
# Each repo must be comma separated tuple with repo-name and repo-path.
# Repos must be separated by space.
# Example: EXTRA_RPM_REPOS="lolo,http://my.cool.repo/rpm bar,ftp://repo.foo"
EXTRA_RPM_REPOS?=

# Additional Ubunutu repos.
# Each repo must consist of an url, dist and section parts.
# Repos must be separated by bar.
# Example:
# EXTRA_DEB_REPOS="http://mrr.lcl raring main|http://mirror.yandex.ru/ubuntu precise main"'
EXTRA_DEB_REPOS?=
