# === FILES/DIRECTORIES ===

SRC_PATH       := src
DIST_PATH      := dist
DRAFTS_PATH    := drafts
GENERATED_PATH := generated

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
	@./scripts/deploy.sh

.PHONY: build
build: $(DIST_FILES)
$(DIST_PATH)/$(BLOCKS_DIR)/%: $(SRC_PATH)/$(BLOCKS_DIR)/%
	@echo "\n==> Update $< block in pages"
	@mkdir -p $$(dirname $@)
	cp $< $@
	@./scripts/block.sh $<
$(DIST_PATH)/%: $(SRC_PATH)/%
	@echo "\n==> Build $<"
	@mkdir -p $$(dirname $@)
	cp $< $@

.PHONY: writing
writing:
	@echo "Generating $(GENERATED_PATH)/writing.html..."
	@mkdir -p $(GENERATED_PATH)
	@pandoc $(DRAFTS_PATH)/writing.md \
		--standalone \
		--wrap=preserve \
		--highlight-style=kate \
		--output=$(GENERATED_PATH)/writing.html
	@echo "Generated $(GENERATED_PATH)/writing.html!"

.PHONY: clean
clean:
	rm -rf $(DIST_PATH) $(GENERATED_PATH)
