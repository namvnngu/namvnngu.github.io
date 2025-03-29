# === FILES/DIRECTORIES ===

SRC_PATH    := src
TMP_PATH    := tmp
DRAFTS_PATH := drafts

BLOCKS_DIR   := blocks
IMAGES_DIR   := images
STYLES_DIR   := styles
WRITING_DIR  := writing
PROJECTS_DIR := projects

DRAFT ?= writing
BLOCK ?=

# === UTILITIES ===

DEV_PORT := 8080

# === TASKS ===

.PHONY: dev
dev:
	@cd $(SRC_PATH) && npx serve && echo "Command not found: npx"

.PHONY: deploy
deploy: tmp
	@./scripts/deploy.sh

.PHONY: tmp
tmp: blocks
	@echo "\n==> Copy files in $(SRC_PATH) to $(TMP_PATH)"
	@rsync -avh $(SRC_PATH)/* $(TMP_PATH) --delete --exclude $(BLOCKS_DIR)

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
