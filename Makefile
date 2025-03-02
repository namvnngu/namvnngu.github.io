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
	@if git status -s | grep -q .; then \
		echo "Commit changes in main branch before deploying."; \
		exit 1; \
	fi

	rm -rf $(DIST_DIR)
	mkdir -p $(DIST_DIR)
	cp -R $(SRC_DIR)/* $(DIST_DIR)

	git checkout gh-pages
	find . -type f -depth 1 -delete
	rm -rf writing/ projects/
	mv -v $(DIST_DIR)/* .
	rm -rf $(DIST_DIR)
	git add .
	git commit -m "Deploy to Github pages"
	git push

	git checkout main

.PHONY: clean
clean:
	rm -rf $(DIST_DIR)
