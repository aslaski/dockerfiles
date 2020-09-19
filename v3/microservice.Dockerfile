# syntax=docker/dockerfile:experimental

FROM rust:1.46 AS builder

RUN rustup target add x86_64-unknown-linux-musl

COPY rust_http_server /rust_http_server
WORKDIR /rust_http_server
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/rust_http_server/target \
    cargo build --release --target x86_64-unknown-linux-musl \
    && mv /rust_http_server/target/x86_64-unknown-linux-musl/release/rust_http_server /rust_http_server.bin

FROM scratch
COPY --from=builder /rust_http_server.bin /rust_http_server.bin

VOLUME /list.txt
EXPOSE 3000
CMD ["/rust_http_server.bin", "/list.txt"]
