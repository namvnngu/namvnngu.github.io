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
	@./scripts/deploy.sh

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
	@./scripts/block.sh $<
$(DIST_PATH)/%: $(SRC_PATH)/%
	cp $< $@

.PHONY: clean
clean:
	rm -rf $(DIST_PATH)
