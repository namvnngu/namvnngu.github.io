# === FILES/DIRECTORIES ===

SRC_PATH    := src
TMP_PATH    := tmp
DRAFTS_PATH := drafts

BLOCKS_DIR   := blocks
IMAGES_DIR   := images
STYLES_DIR   := styles
WRITING_DIR  := writing
PROJECTS_DIR := projects

SRC_FILES    := $(shell find $(SRC_PATH) -type file)
TMP_FILES    := $(SRC_FILES:$(SRC_PATH)/%=$(TMP_PATH)/%)

DRAFT ?= writing
BLOCK ?=

# === UTILITIES ===

DEV_PORT := 8080

# === TASKS ===

.PHONY: dev
dev:
	@cd $(SRC_PATH) && npx serve && echo "Command not found: npx"

.PHONY: deploy
deploy: cptmp
	@./scripts/deploy.sh

.PHONY: cptmp
cptmp: blocks $(TMP_FILES)
$(TMP_PATH)/%: $(SRC_PATH)/%
	@echo "\n==> Copy $< to $@"
	@mkdir -p $$(dirname $@)
	cp $< $@

.PHONY: blocks
blocks:
	@find $(SRC_PATH)/$(BLOCKS_DIR) -type file \
		-exec "echo" ";" \
		-exec "echo" "==> Update {} block in all pages" ";" \
		-exec "./scripts/block.sh" "{}" ";"

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
	rm -rf $(TMP_PATH)
