.PHONY: install
install:
	npm install
.PHONY: start
start:
	npm start
.PHONY: clean-install
clean-install:
	npm clean-install
.PHONY: automate
automate:
	./.github/workflows/automate.sh
