FROM rust:1.46 AS builder

COPY rust_http_server /rust_http_server
WORKDIR /rust_http_server
RUN cargo clean && cargo build --release

FROM ubuntu
COPY --from=builder /rust_http_server/target/release/rust_http_server /rust_http_server.bin

VOLUME /list.txt
EXPOSE 3000
CMD ["/rust_http_server.bin", "/list.txt"]
