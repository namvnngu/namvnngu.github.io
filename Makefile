.PHONY: deploy
deploy:
	find . -not -name 'dist' -depth 1 -delete
