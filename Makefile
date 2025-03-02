# === FILES/DIRECTORIES ===

SRC_DIR      := src
DIST_DIR     := dist
WRITING_DIR  := writing
PROJECTS_DIR := projects

SRC_FILES  := $(shell find $(SRC_DIR) -type f)
DIST_FILES := $(SRC_FILES:$(SRC_DIR)/%=$(DIST_DIR)/%)

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

.PHONY: deploy
deploy: $(DIST_FILES)
ifneq ($(GIT_STATUS),)
	@echo "Commit changes in main branch before deploying."
else
	@git checkout gh-pages

	@echo "==> Preparing files..."
	find . -type f -depth 1 -delete
	rm -rf $(WRITING_DIR) $(PROJECTS_DIR)
	mv -v $(DIST_DIR)/* .
	rm -rf $(DIST_DIR)
	@echo "==> Prepared files!"

ifeq ($(GIT_STATUS),)
	@echo "Nothing to deploy to GitHub page."
else
	@git add .
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
