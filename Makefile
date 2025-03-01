# Directories
SRC_DIR  := src
DIST_DIR := dist

# Dev
DEV_PORT := 8080

.PHONY: dev
dev:
	@cd $(SRC_DIR) && \
		which python3 > /dev/null && \
		python3 -m http.server $(DEV_PORT) || \
		python -m SimpleHTTPServer $(DEV_PORT)

.PHONY: deploy
deploy:
	mkdir -p $(DIST_DIR)
	find . -not -name $(DIST_DIR) -depth 1 -delete

.PHONY: clean
clean:
	rm -rf $(DIST_DIR)
