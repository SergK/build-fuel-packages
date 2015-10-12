.PHONY: sources clean-sources

clean-sources:
	rm -rf $(BUILD_DIR)/packages


# Prepare sources + version file in format:
#
# VERSION=$(PRODUCT_VERSION)
# if gerrit commit is given then
#   RELEASE=${commit_num}.0.gerrit${request_number}.${patchset_number}.git${git_sha}
# else
#   RELEASE=${commit_num}.1.git${git_sha}
# DEBFULLNAME=Commit Author
# DEBEMAIL=Commit Author email address
# DEBMSG=Commit message
define prepare_git_source
$(BUILD_DIR)/packages/sources/$1/$2: $(BUILD_DIR)/repos/repos.done
$(BUILD_DIR)/packages/source_$1.done: $(BUILD_DIR)/packages/sources/$1/$2
$(BUILD_DIR)/packages/sources/$1/$2: VERSIONFILE:=$(BUILD_DIR)/packages/sources/$1/version
$(BUILD_DIR)/packages/sources/$1/$2:
	mkdir -p $(BUILD_DIR)/packages/sources/$1
	cd $3 && git archive --format tar --worktree-attributes $4 > $(BUILD_DIR)/packages/sources/$1/$1.tar
	echo VERSION=$(PACKAGE_VERSION) > $$(VERSIONFILE)
	echo -n RELEASE=`git -C $3 rev-list --no-merges $4 --count` >> $$(VERSIONFILE)
	echo -n ".1" >> $$(VERSIONFILE)
	echo ".git`git -C $3 rev-parse --short $4`" >> $$(VERSIONFILE)
	echo DEBFULLNAME=`git -C $3 log -1 --pretty=format:%an` >> $$(VERSIONFILE)
	echo DEBEMAIL=`git -C $3 log -1 --pretty=format:%ae` >> $$(VERSIONFILE)
	echo DEBMSG=`git -C $3 log -1 --pretty=%s` >> $$(VERSIONFILE)
	cd $(BUILD_DIR)/packages/sources/$1 && tar -rf $1.tar version
	cd $(BUILD_DIR)/packages/sources/$1 && gzip -9 $1.tar && mv $1.tar.gz $2
endef

$(BUILD_DIR)/packages/source_%.done:
	$(ACTION.TOUCH)

#NAILGUN_PKGS
$(eval $(call prepare_git_source,fuel-nailgun,fuel-nailgun-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-nailgun,HEAD,$(NAILGUN_GERRIT_COMMIT)))
#FUEL_OSTF_PKGS
$(eval $(call prepare_git_source,fuel-ostf,fuel-ostf-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-ostf,HEAD,$(OSTF_GERRIT_COMMIT)))
#ASTUTE_PKGS
$(eval $(call prepare_git_source,astute,astute-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/astute,HEAD,$(ASTUTE_GERRIT_COMMIT)))
#FUELLIB_PKGS
$(eval $(call prepare_git_source,fuel-library$(PRODUCT_VERSION),fuel-library$(PRODUCT_VERSION)-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-library$(PRODUCT_VERSION),HEAD,$(FUELLIB_GERRIT_COMMIT)))
#FUEL_PYTHON_PKGS
$(eval $(call prepare_git_source,python-fuelclient,python-fuelclient-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/python-fuelclient,HEAD,$(PYTHON_FUELCLIENT_GERRIT_COMMIT)))
#FUEL_AGENT_PKGS
$(eval $(call prepare_git_source,fuel-agent,fuel-agent-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-agent,HEAD,$(FUEL_AGENT_GERRIT_COMMIT)))
#FUEL_NAILGUN_AGENT_PKGS
$(eval $(call prepare_git_source,fuel-nailgun-agent,fuel-nailgun-agent-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-nailgun-agent,HEAD,$(FUEL_NAILGUN_AGENT_GERRIT_COMMIT)))
#FUEL-IMAGE PKGS
$(eval $(call prepare_git_source,fuel-main,fuel-main-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-main,HEAD,$(FUELMAIN_GERRIT_COMMIT)))
#FUEL-CREATEMIRROR PKGS
$(eval $(call prepare_git_source,fuel-createmirror,fuel-createmirror-$(PACKAGE_VERSION).tar.gz,$(BUILD_DIR)/repos/fuel-createmirror,HEAD,$(CREATEMIRROR_GERRIT_COMMIT)))


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
