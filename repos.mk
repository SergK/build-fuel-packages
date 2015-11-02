.PHONY: repos clean-repos

clean-repos:
	rm -rf $(BUILD_DIR)/repos

repos: $(BUILD_DIR)/repos/repos.done

fuel_components_repos:=
# Usage:
# (eval (call build_repo,repo_name,repo_uri,sha))
define build_repo
$(BUILD_DIR)/repos/$1/%: $(BUILD_DIR)/repos/$1.done
$(BUILD_DIR)/repos/repos.done: $(BUILD_DIR)/repos/$1.done
fuel_components_repos:=$(fuel_components_repos) $1

$(BUILD_DIR)/repos/$1.done:
	mkdir -p $(BUILD_DIR)/repos
	rm -rf $(BUILD_DIR)/repos/$1

# Do not prepare repo in case of no patches provided
# since we don't need build package for such cases
ifneq ($5,none)

	#Clone everything and checkout to branch (or hash)
	git clone $2 $(BUILD_DIR)/repos/$1 && (cd $(BUILD_DIR)/repos/$1 && git checkout -q $3)

	# Pull gerrit commits if given
	$(foreach var,$(filter-out none,$5),
		( cd $(BUILD_DIR)/repos/$1 && git fetch $4 $(var) && git cherry-pick FETCH_HEAD ) ;
	)
else
	echo "Nothing to do, since patchsets equal 'none'"
endif
	touch $$@
endef


$(eval $(call build_repo,astute,$(ASTUTE_REPO),$(ASTUTE_COMMIT),$(ASTUTE_GERRIT_URL),$(ASTUTE_GERRIT_COMMIT)))
$(eval $(call build_repo,fuel-agent,$(FUEL_AGENT_REPO),$(FUEL_AGENT_COMMIT),$(FUEL_AGENT_GERRIT_URL),$(FUEL_AGENT_GERRIT_COMMIT)))
$(eval $(call build_repo,fuel-createmirror,$(CREATEMIRROR_REPO),$(CREATEMIRROR_COMMIT),$(CREATEMIRROR_GERRIT_URL),$(CREATEMIRROR_GERRIT_COMMIT)))
$(eval $(call build_repo,fuel-library$(PRODUCT_VERSION),$(FUELLIB_REPO),$(FUELLIB_COMMIT),$(FUELLIB_GERRIT_URL),$(FUELLIB_GERRIT_COMMIT)))
$(eval $(call build_repo,fuel-main,$(FUEL_MAIN_REPO),$(FUEL_MAIN_COMMIT),$(FUEL_MAIN_GERRIT_URL),$(FUELMAIN_GERRIT_COMMIT)))
$(eval $(call build_repo,fuel-nailgun,$(NAILGUN_REPO),$(NAILGUN_COMMIT),$(NAILGUN_GERRIT_URL),$(NAILGUN_GERRIT_COMMIT)))
$(eval $(call build_repo,fuel-nailgun-agent,$(FUEL_NAILGUN_AGENT_REPO),$(FUEL_NAILGUN_AGENT_COMMIT),$(FUEL_NAILGUN_AGENT_GERRIT_URL),$(FUEL_NAILGUN_AGENT_GERRIT_COMMIT)))
$(eval $(call build_repo,fuel-ostf,$(OSTF_REPO),$(OSTF_COMMIT),$(OSTF_GERRIT_URL),$(OSTF_GERRIT_COMMIT)))
$(eval $(call build_repo,fuel-upgrade,$(FUELUPGRADE_REPO),$(FUELUPGRADE_COMMIT),$(FUELUPGRADE_GERRIT_URL),$(FUELUPGRADE_GERRIT_COMMIT)))
$(eval $(call build_repo,fuelmenu,$(FUELMENU_REPO),$(FUELMENU_COMMIT),$(FUELMENU_GERRIT_URL),$(FUELMENU_GERRIT_COMMIT)))
$(eval $(call build_repo,network-checker,$(NETWORKCHECKER_REPO),$(NETWORKCHECKER_COMMIT),$(NETWORKCHECKER_GERRIT_URL),$(NETWORKCHECKER_GERRIT_COMMIT)))
$(eval $(call build_repo,python-fuelclient,$(PYTHON_FUELCLIENT_REPO),$(PYTHON_FUELCLIENT_COMMIT),$(PYTHON_FUELCLIENT_GERRIT_URL),$(PYTHON_FUELCLIENT_GERRIT_COMMIT)))
$(eval $(call build_repo,shotgun,$(SHOTGUN_REPO),$(SHOTGUN_COMMIT),$(SHOTGUN_GERRIT_URL),$(SHOTGUN_GERRIT_COMMIT)))

$(BUILD_DIR)/repos/repos.done:
	@mkdir -p $(@D)
	touch $@
