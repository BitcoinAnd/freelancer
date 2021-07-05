.PHONY: start
start:
	npm run
	npm start
.PHONY: clean-install
clean-install:
	npm clean-install
.PHONY: automate
automate:
	./.github/workflows/automate.sh
.PHONY: build-scss
build:
	npm run
	npm run build
	npm run build:pug
	npm run build:scripts
	npm run build:scss
	npm run clean
	npm run start:debug
.PHONY: install
install:
	npm install

.PHONY: docker-build
docker-build:
	docker build . -t node/bitcoinand.net
.PHONY: docker-run
docker-run:
	docker run -p 3000:3000 -d node/bitcoinand.net
