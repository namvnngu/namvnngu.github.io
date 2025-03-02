# === FILES/DIRECTORIES ===

SRC_DIR      := src
DIST_DIR     := dist
WRITING_DIR  := writing
PROJECTS_DIR := projects

SRC_FILES      := $(shell find $(SRC_DIR) -type f)
DIST_FILES     := $(SRC_FILES:$(SRC_DIR)/%=$(DIST_DIR)/%)
DEPLOY_FILES   := $(SRC_FILES:$(SRC_DIR)/%=%)
GITIGNORE_FILE := .gitignore

# === UTILITIES ===

DEV_PORT := 8080

# === TASKS ===

.PHONY: dev
dev:
	@cd $(SRC_DIR) && \
		which python3 > /dev/null && \
		python3 -m http.server $(DEV_PORT) || \
		python -m SimpleHTTPServer $(DEV_PORT)

.PHONY: deploy
deploy: build
	@if [[ -n "$$(git status -s)" ]]; then \
		echo "Commit changes in main branch before deploying."; \
	else \
		git checkout gh-pages; \
		cp -R $(DIST_DIR)/* .; \
		rm -rf $(DIST_DIR); \
		if [[ -z "$$(git status -s)" ]]; then \
			echo "Nothing to deploy to GitHub page."; \
		else \
 			git add .; \
 			git commit -m "Deploy to GitHub page"; \
 			git push; \
 			echo "Check out deployment at https://github.com/namvnngu/namvnngu.github.io/deployments"; \
		fi; \
		git checkout main; \
	fi

.PHONY: build
build: __prebuild $(DIST_FILES)
.PHONY: __prebuild
__prebuild:
	@mkdir -p $(DIST_DIR)/$(WRITING_DIR) $(DIST_DIR)/$(PROJECTS_DIR)
$(DIST_DIR)/%: $(SRC_DIR)/%
	@cp $< $@

.PHONY: clean
clean:
	rm -rf $(DIST_DIR)
