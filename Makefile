DOCKER_ARGS =

.PHONY: default
default: run

.PHONY: docker
docker:
	@eval $$(minikube docker-env -p 4000) && \
	docker build $(DOCKER_ARGS) -t comp4000/ex1-server -f Dockerfile.server . && \
	docker build $(DOCKER_ARGS) -t comp4000/ex1-client -f Dockerfile.client .

.PHONY: deploy
deploy:
	kubectl apply -f deployment.yml

.PHONY: delete
delete:
	kubectl delete -f deployment.yml
