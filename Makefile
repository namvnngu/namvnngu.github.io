# === FILES/DIRECTORIES ===

SRC_PATH     := src
DIST_PATH    := dist

BLOCKS_DIR   := blocks
IMAGES_DIR   := images
WRITING_DIR  := writing
PROJECTS_DIR := projects

SRC_FILES    := $(shell find $(SRC_PATH) -type file)
DIST_FILES   := $(SRC_FILES:$(SRC_PATH)/%=$(DIST_PATH)/%)
DEPLOY_FILES := $(SRC_FILES:$(SRC_PATH)/%=%)

# === UTILITIES ===

DEV_PORT := 8080

# === TASKS ===

.PHONY: dev
dev:
	@cd $(SRC_PATH) && npx serve && echo "Command not found: npx"

.PHONY: deploy
deploy: build
	@if [[ -n "$$(git status -s)" ]]; then \
    echo "Commit changes in main branch before deploying."; \
  else \
    echo "Switching to branch 'gh-pages'..."; \
    git checkout -q gh-pages; \
    echo "Switched to branch 'gh-pages'!"; \
    echo "Preparing files..."; \
    rsync $(DIST_PATH)/ ./ --exclude $(BLOCKS_DIR); \
    rm -rf $(DIST_PATH); \
    echo "Prepared files!"; \
    if [[ -z "$$(git status -s)" ]]; then \
      echo "Nothing to deploy to GitHub page"; \
    else \
      echo "Committing changes..."; \
      git add .; \
      git commit -q -m "Deploy to GitHub page"; \
      echo "Committed changes!"; \
      echo "Triggering deployment..."; \
      git push -q; \
      echo "Triggered deployment!"; \
      echo "Check out deployment at https://github.com/namvnngu/namvnngu.github.io/deployments"; \
    fi; \
    echo "Switching to branch 'main'..."; \
    git checkout -q main; \
    echo "Switched to branch 'main'!"; \
  fi

.PHONY: build
build: __prebuild $(DIST_FILES)
.PHONY: __prebuild
__prebuild:
	@mkdir -p $(DIST_PATH)/$(BLOCKS_DIR) \
            $(DIST_PATH)/$(IMAGES_DIR) \
            $(DIST_PATH)/$(WRITING_DIR) \
            $(DIST_PATH)/$(PROJECTS_DIR)
$(DIST_PATH)/$(BLOCKS_DIR)/%: $(SRC_PATH)/$(BLOCKS_DIR)/%
	cp $< $@
$(DIST_PATH)/%: $(SRC_PATH)/%
	cp $< $@

.PHONY: clean
clean:
	rm -rf $(DIST_PATH)
