###############################################################################
# run-workflow
###############################################################################
.PHONY: run-workflow
run-workflow:
	make run-buildapp && make run-git-push


###############################################################################
# run-buildapp
###############################################################################
.PHONY: run-buildapp
run-buildapp:
	make -C .github/actions/run-buildapp dc-up


.PHONY: run-buildapp-build
run-buildapp-build:
	make -C .github/actions/run-buildapp dc-up-build


.PHONY: run-buildapp-build-no-cache
run-buildapp-build-no-cache:
	make -C .github/actions/run-buildapp dc-build-no-cache


###############################################################################
# git-push
###############################################################################
.PHONY: run-git-push
run-git-push:
	make -C .github/actions/git-push dc-up


.PHONY: run-git-push-build
run-git-push-build:
	make -C .github/actions/git-push dc-up-build


.PHONY: run-git-push-build-no-cache
run-git-push-build-no-cache:
	make -C .github/actions/git-push dc-build-no-cache

