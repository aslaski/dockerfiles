# syntax=docker/dockerfile:experimental

FROM rust:1.44 AS builder

COPY rust_http_server /rust_http_server
WORKDIR /rust_http_server
RUN rustup target add x86_64-unknown-linux-musl
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=rust_http_server/target \
    cargo clean && cargo build --release --target x86_64-unknown-linux-musl

FROM scratch
COPY --from=builder /rust_http_server/target/x86_64-unknown-linux-musl/release/rust_http_server /rust_http_server.bin

VOLUME /list.txt
EXPOSE 3000
CMD ["/rust_http_server.bin", "/list.txt"]
