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

PRODUCT_VERSION:=8.0

PACKAGE_VERSION=$(PRODUCT_VERSION).0

# Repos and versions
ASTUTE_COMMIT?=master
CREATEMIRROR_COMMIT?=master
FUEL_AGENT_COMMIT?=master
FUEL_MAIN?=master
FUEL_NAILGUN_AGENT_COMMIT?=master
FUELLIB_COMMIT?=master
NAILGUN_COMMIT?=master
OSTF_COMMIT?=master
PYTHON_FUELCLIENT_COMMIT?=master

ASTUTE_REPO?=https://github.com/openstack/fuel-astute.git
CREATEMIRROR_REPO?=https://github.com/openstack/fuel-mirror.git
FUEL_AGENT_REPO?=https://github.com/openstack/fuel-agent.git
FUEL_MAIN_REPO?=https://github.com/openstack/fuel-main.git
FUEL_NAILGUN_AGENT_REPO?=https://github.com/openstack/fuel-nailgun-agent.git
FUELLIB_REPO?=https://github.com/openstack/fuel-library.git
NAILGUN_REPO?=https://github.com/openstack/fuel-web.git
OSTF_REPO?=https://github.com/openstack/fuel-ostf.git
PYTHON_FUELCLIENT_REPO?=https://github.com/openstack/python-fuelclient.git

# Gerrit URLs and commits
ASTUTE_GERRIT_URL?=https://review.openstack.org/openstack/fuel-astute
CREATEMIRROR_GERRIT_URL?=https://review.openstack.org/openstack/fuel-mirror
FUEL_AGENT_GERRIT_URL?=https://review.openstack.org/openstack/fuel-agent
FUEL_MAIN_GERRIT_URL?=https://review.openstack.org/openstack/fuel-main
FUEL_NAILGUN_AGENT_GERRIT_URL?=https://review.openstack.org/openstack/fuel-nailgun-agent
FUELLIB_GERRIT_URL?=https://review.openstack.org/openstack/fuel-library
NAILGUN_GERRIT_URL?=https://review.openstack.org/openstack/fuel-web
OSTF_GERRIT_URL?=https://review.openstack.org/openstack/fuel-ostf
PYTHON_FUELCLIENT_GERRIT_URL?=https://review.openstack.org/openstack/python-fuelclient

ASTUTE_GERRIT_COMMIT?=none
CREATEMIRROR_GERRIT_COMMIT?=none
FUEL_AGENT_GERRIT_COMMIT?=none
FUEL_NAILGUN_AGENT_GERRIT_COMMIT?=none
FUELLIB_GERRIT_COMMIT?=none
FUELMAIN_GERRIT_COMMIT?=none
NAILGUN_GERRIT_COMMIT?=none
OSTF_GERRIT_COMMIT?=none
PYTHON_FUELCLIENT_GERRIT_COMMIT?=none
