# === FILES/DIRECTORIES ===

SRC_DIR      := src
DIST_DIR     := dist
WRITING_DIR  := writing
PROJECTS_DIR := projects

SRC_FILES    := $(shell find $(SRC_DIR) -type f)
DIST_FILES   := $(SRC_FILES:$(SRC_DIR)/%=$(DIST_DIR)/%)
DEPLOY_FILES := $(SRC_FILES:$(SRC_DIR)/%=%)

# === UTILITIES ===

DEV_PORT := 8080

GIT_STATUS = $(shell git status -s)

# === TASKS ===

.PHONY: dev
dev:
	@cd $(SRC_DIR) && \
		which python3 > /dev/null && \
		python3 -m http.server $(DEV_PORT) || \
		python -m SimpleHTTPServer $(DEV_PORT)

.PHONY: deploy __internal_deploy
deploy: __internal_deploy
ifneq ($(GIT_STATUS),)
__internal_deploy:
	@echo "Commit changes in main branch before deploying."
else
__internal_deploy: build
	@git checkout gh-pages
	cp -R $(DIST_DIR)/* .
ifeq ($(GIT_STATUS),)
	@echo "Nothing to deploy to GitHub page."
else
	@git add $(DEPLOY_FILES)
	@git commit -m "Deploy to GitHub page"
	@git push
	@echo "Check out deployment at https://github.com/namvnngu/namvnngu.github.io/deployments"
endif
	@git checkout main
endif

.PHONY: build
build: prepare $(DIST_FILES)
.PHONY: prepare
prepare:
	@mkdir -p $(DIST_DIR)/$(WRITING_DIR) $(DIST_DIR)/$(PROJECTS_DIR)
$(DIST_DIR)/%: $(SRC_DIR)/%
	cp $< $@

.PHONY: clean
clean:
	rm -rf $(DIST_DIR)
