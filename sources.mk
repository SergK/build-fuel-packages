.PHONY: sources clean-sources

clean-sources:
	rm -rf $(BUILD_DIR)/packages


# Prepare sources + version file in format:
#
# VERSION=$(PRODUCT_VERSION)
# RELEASE=1.mos${commit_num}.git.${git_sha}
# DEB_REALEASE=1~u14.04+mos${commit_num}+git.${git_sha}
# AUTHOR=Commit Author
# EMAIL=Commit Author email address
# MSG=Commit message
define prepare_git_source

RELEASE:=$(shell echo "1.mos`git -C $3 rev-list --no-merges $4 --count`.git.`git -C $3 rev-parse --short $4`")
DEB_RELEASE:=$(shell echo "1~u14.04+mos`git -C $3 rev-list --no-merges $4 --count`+git.`git -C $3 rev-parse --short $4`")
AUTHOR:=$(shell echo `git -C $3 log -1 --pretty=format:%an`)
EMAIL:=$(shell echo `git -C $3 log -1 --pretty=format:%ae`)
MSG:=$(shell echo `git -C $3 log -1 --pretty=%s`)

$(BUILD_DIR)/packages/sources/$1/$1.spec:	$(BUILD_DIR)/packages/sources/$1/version
	mkdir -p $(BUILD_DIR)/packages/sources/$1
	cp -v $(BUILD_DIR)/repos/$1/specs/$1.spec $$(@).tmp
#	echo RELEASE=`awk -F= '/^RELEASE=/ {print $$$$NF}' $$<`
	sed -i 's/Release:.*$$//Release: $$(RELEASE) /' $$(@).tmp
	mv $$(@).tmp $$(@)

$(BUILD_DIR)/packages/sources/$1/version: $(BUILD_DIR)/repos/repos.done
	mkdir -p $(BUILD_DIR)/packages/sources/$1
	echo VERSION=$(PACKAGE_VERSION) > $$(@)
	echo RELEASE=$(RELEASE) >> $$(@)
	echo DEB_RELEASE=$(DEB_RELEASE) >> $$(@)
	echo AUTHOR=$(AUTHOR) >> $$(@)
	echo EMAIL=$(EMAIL) >> $$(@)
	echo MSG=$(MSG) >> $$(@)

$(BUILD_DIR)/packages/sources/$1/$2: $(BUILD_DIR)/repos/repos.done
$(BUILD_DIR)/packages/source_$1.done: $(BUILD_DIR)/packages/sources/$1/$2
$(BUILD_DIR)/packages/sources/$1/$2: $(BUILD_DIR)/packages/sources/$1/version
$(BUILD_DIR)/packages/sources/$1/$2: $(BUILD_DIR)/packages/sources/$1/$1.spec
	cd $3 && git archive --format tar --worktree-attributes $4 > $(BUILD_DIR)/packages/sources/$1/$1.tar
	cd $(BUILD_DIR)/packages/sources/$1 && tar -rf $1.tar version
	cd $(BUILD_DIR)/packages/sources/$1 && gzip -9 $1.tar && mv $1.tar.gz $2
endef

$(BUILD_DIR)/packages/source_%.done:
	$(ACTION.TOUCH)

#NAILGUN_PKGS
$(eval $(call prepare_git_source,fuel-nailgun,fuel-nailgun-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-nailgun,HEAD))
#FUEL_OSTF_PKGS
$(eval $(call prepare_git_source,fuel-ostf,fuel-ostf-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-ostf,HEAD))
#ASTUTE_PKGS
$(eval $(call prepare_git_source,astute,astute-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/astute,HEAD))
#FUELLIB_PKGS
$(eval $(call prepare_git_source,fuel-library$(PRODUCT_VERSION),fuel-library$(PRODUCT_VERSION)-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-library$(PRODUCT_VERSION),HEAD))
#FUEL_PYTHON_PKGS
$(eval $(call prepare_git_source,python-fuelclient,python-fuelclient-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/python-fuelclient,HEAD))
#FUEL_AGENT_PKGS
$(eval $(call prepare_git_source,fuel-agent,fuel-agent-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-agent,HEAD))
#FUEL_NAILGUN_AGENT_PKGS
$(eval $(call prepare_git_source,fuel-nailgun-agent,fuel-nailgun-agent-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-nailgun-agent,HEAD))
#FUEL-IMAGE PKGS
$(eval $(call prepare_git_source,fuel-main,fuel-main-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-main,HEAD))
#FUEL-CREATEMIRROR PKGS
$(eval $(call prepare_git_source,fuel-createmirror,fuel-createmirror-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-createmirror,HEAD))


packages_list:=\
astute \
fuel-agent \
fuel-createmirror \
fuel-library$(PRODUCT_VERSION) \
fuel-main \
fuel-nailgun \
fuel-nailgun-agent \
fuel-ostf \
python-fuelclient

sources: $(packages_list:%=$(BUILD_DIR)/packages/source_%.done)
