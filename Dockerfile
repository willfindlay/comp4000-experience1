FROM rust:alpine as builder

RUN apk update
RUN apk add --no-cache musl-dev
WORKDIR /app

# Cache build dependencies
RUN echo "fn main() {}" > dummy.rs
COPY Cargo.toml .
RUN sed -i 's#src/main.rs#dummy.rs#' Cargo.toml
RUN mkdir src && touch src/lib.rs
RUN cargo build --release
RUN sed -i 's#dummy.rs#src/main.rs#' Cargo.toml

COPY . .
RUN cargo build --release

FROM alpine
COPY --from=builder /app/target/release/hello4000 /app/hello4000

ENTRYPOINT ["/app/hello4000"]
