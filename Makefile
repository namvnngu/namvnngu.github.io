# Directories
SRC_DIR  := src
DIST_DIR := dist

# Utilities
DEV_PORT := 8080
GIT_STATUS = $(shell git status -s)

.PHONY: dev
dev:
	@cd $(SRC_DIR) && \
		which python3 > /dev/null && \
		python3 -m http.server $(DEV_PORT) || \
		python -m SimpleHTTPServer $(DEV_PORT)

.PHONY: deploy
deploy: build
ifneq ($(GIT_STATUS),)
	@echo "Commit changes in main branch before deploying."
else
	@git checkout gh-pages

	@echo "Preparing files..."
	@find . -type f -depth 1 -delete
	@rm -rf writing/ projects/
	@mv -v $(DIST_DIR)/* .
	@rm -rf $(DIST_DIR)
	@echo "Prepared files!"

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
build: clean
	@echo "Building pages..."
	@mkdir -p $(DIST_DIR)
	@cp -R $(SRC_DIR)/* $(DIST_DIR)
	@echo "Built pages!"

.PHONY: clean
clean:
	@echo "Cleaning up..."
	@rm -rf $(DIST_DIR)
	@echo "Cleaned up!"
