# === FILES/DIRECTORIES ===

SRC_PATH    := src
DIST_PATH   := dist
DRAFTS_PATH := drafts

BLOCKS_DIR   := blocks
IMAGES_DIR   := images
STYLES_DIR   := styles
WRITING_DIR  := writing
PROJECTS_DIR := projects

SRC_FILES    := $(shell find $(SRC_PATH) -type file)
DIST_FILES   := $(SRC_FILES:$(SRC_PATH)/%=$(DIST_PATH)/%)
DEPLOY_FILES := $(SRC_FILES:$(SRC_PATH)/%=%)

DRAFT ?= writing
BLOCK ?=

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

define copy
	echo "\n==> Copy $(1) to $(2)"
	mkdir -p $$(dirname $(2))
	cp $(1) $(2)
endef
$(DIST_PATH)/$(BLOCKS_DIR)/%: $(SRC_PATH)/$(BLOCKS_DIR)/%
	@$(call copy,$<,$@)
	@echo "\n==> Update $< block in pages"
	./scripts/block.sh $<
$(DIST_PATH)/%: $(SRC_PATH)/%
	@$(call copy,$<,$@)

.PHONY: block
block:
	@./scripts/block.sh $(BLOCK)

.PHONY: gen
gen:
	@echo "Generating $(DRAFTS_PATH)/$(DRAFT).html..."
	@pandoc $(DRAFTS_PATH)/$(DRAFT).md \
		--toc \
		--standalone \
		--wrap=preserve \
		--highlight-style=kate \
		--output=$(DRAFTS_PATH)/$(DRAFT).html
	@echo "Generated $(DRAFTS_PATH)/$(DRAFT).html!"

.PHONY: clean
clean:
	rm -rf $(DIST_PATH)
