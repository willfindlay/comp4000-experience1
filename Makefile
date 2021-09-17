.PHONY: default
default: run

.PHONY: run
run:
	cargo run

.PHONY: debug
debug:
	cargo build

.PHONY: release
release:
	cargo build --release

.PHONY: docker
docker:
	docker build $(DOCKER_ARGS) -t ex1 .
	docker run -p 8000:8000 --rm ex1

.PHONY: clean
clean:
	cargo clean
