DOCKER_ARGS =

VERSION = v1

SERVER_TAG = wpfindlay/comp4000-ex1:server-$(VERSION)
CLIENT_TAG = wpfindlay/comp4000-ex1:server-$(VERSION)

.PHONY: default
default: run

.PHONY: docker
docker:
	docker build $(DOCKER_ARGS) -t $(SERVER_TAG) -f Dockerfile.server .
	docker build $(DOCKER_ARGS) -t $(CLIENT_TAG) -f Dockerfile.client .
	#@eval $$(minikube docker-env -p 4000) && \

.PHONY: push
push: docker
	docker push $(SERVER_TAG)
	docker push $(CLIENT_TAG)

.PHONY: deploy
deploy:
	kubectl apply -f deployment.yml

.PHONY: delete
delete:
	kubectl delete -f deployment.yml
