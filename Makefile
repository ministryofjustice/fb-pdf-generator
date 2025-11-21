UID ?= $(shell id -u)
COMPOSE = env UID=$(UID) docker-compose -f docker-compose.yml

.PHONY: docker-down
docker-down:
	$(COMPOSE) down

.PHONY: docker-build
docker-build:
	$(COMPOSE) build

.PHONY: shell
shell: docker-down docker-build
	$(COMPOSE) up -d
	$(COMPOSE) exec api bash

.PHONY: spec
spec: docker-down docker-build test lint

.PHONY: test
test: docker-down docker-build
	$(COMPOSE) run --rm api bundle exec rspec

.PHONY: lint
lint:
	$(COMPOSE) run --rm api bundle exec rubocop

.PHONY: fix
fix:
	$(COMPOSE) run --rm api bundle exec rubocop -a

.PHONY: serve
serve: docker-down docker-build
	$(COMPOSE) run --rm --service-ports api

.PHONY: setup
setup: docker-down docker-build
	$(COMPOSE) up -d
