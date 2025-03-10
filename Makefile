# === FILES/DIRECTORIES ===

SRC_DIR      := src
DIST_DIR     := dist
IMAGES_DIR   := images
WRITING_DIR  := writing
PROJECTS_DIR := projects
BLOCKS_DIR   := blocks

SRC_FILES      := $(shell find $(SRC_DIR) \
													-path $(SRC_DIR)/$(BLOCKS_DIR) -prune \
													-o -type file -print)
DIST_FILES     := $(SRC_FILES:$(SRC_DIR)/%=$(DIST_DIR)/%)
DEPLOY_FILES   := $(SRC_FILES:$(SRC_DIR)/%=%)

# === UTILITIES ===

DEV_PORT := 8080

# === TASKS ===

.PHONY: dev
dev:
	@cd $(SRC_DIR) && npx serve && echo "Command not found: npx"

.PHONY: deploy
deploy: build
	@if [[ -n "$$(git status -s)" ]]; then \
		echo "Commit changes in main branch before deploying."; \
	else \
		echo "Switching to branch 'gh-pages'..."; \
		git checkout -q gh-pages; \
		echo "Switched to branch 'gh-pages'!"; \
		echo "Preparing files..."; \
		cp -R $(DIST_DIR)/* .; \
		rm -rf $(DIST_DIR); \
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
	@mkdir -p $(DIST_DIR)/$(IMAGES_DIR) \
						$(DIST_DIR)/$(WRITING_DIR) \
						$(DIST_DIR)/$(PROJECTS_DIR)
$(DIST_DIR)/%: $(SRC_DIR)/%
	cp $< $@

.PHONY: clean
clean:
	rm -rf $(DIST_DIR)
