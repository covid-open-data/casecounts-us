###############################################################################
# run-workflow
###############################################################################
.PHONY: run-workflow
run-workflow:
	make run-buildapp
	make run-git-push


###############################################################################
# run-buildapp
###############################################################################
.PHONY: run-buildapp
run-buildapp:
	cd .github/actions/run-buildapp; make dc-up; cd -


.PHONY: run-buildapp-build
run-buildapp-build:
	cd .github/actions/run-buildapp; make dc-up-build; cd -


.PHONY: run-buildapp-build-no-cache
run-buildapp-build-no-cache:
	cd .github/actions/run-buildapp; make dc-build-no-cache; cd -


###############################################################################
# git-push
###############################################################################
.PHONY: run-git-push
run-git-push:
	cd .github/actions/git-push; make dc-up; cd -


.PHONY: run-git-push-build
run-git-push-build:
	cd .github/actions/git-push; make dc-up-build; cd -


.PHONY: run-git-push-build-no-cache
run-git-push-build-no-cache:
	cd .github/actions/git-push; make dc-build-no-cache; cd -

