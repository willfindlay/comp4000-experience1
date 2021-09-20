.PHONY: default
default: run

.PHONY: docker
docker:
	docker build $(DOCKER_ARGS) -t 4000server -f Dockerfile.server .
	docker build $(DOCKER_ARGS) -t 4000client -f Dockerfile.client .

.PHONY: run
run: docker
	docker run -p 8000:8000 --rm 4000server

.PHONY: clean
clean:
	cargo clean
