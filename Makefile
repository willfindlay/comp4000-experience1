DOCKER_FLAGS =

CLIENT_IMAGE = wpfindlay/comp4000-ex1:client-latest
SERVER_IMAGE = wpfindlay/comp4000-ex1:server-latest

MD_FILE = experience1.md
WIKI_FILE = wiki/experience1.wiki

.PHONY: default
default: run

.PHONY: build
build:
	docker build $(DOCKER_FLAGS) -t $(CLIENT_IMAGE) -f Dockerfile.client .
	docker build $(DOCKER_FLAGS) -t $(SERVER_IMAGE) -f Dockerfile.server .

.PHONY: push
push: build
	docker push $(CLIENT_IMAGE)
	docker push $(SERVER_IMAGE)

.PHONY: deploy
deploy:
	kubectl apply -f deployment.yml

.PHONY: delete
delete:
	kubectl delete -f deployment.yml

.PHONY: wiki
wiki: $(WIKI_FILE)

$(WIKI_FILE): $(MD_FILE)
	pandoc -f markdown -t mediawiki "$(MD_FILE)" > "$(WIKI_FILE)"
