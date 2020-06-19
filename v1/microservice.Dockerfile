FROM rust:1.44

COPY rust_http_server /rust_http_server
WORKDIR /rust_http_server
RUN cargo build --release
WORKDIR /
RUN mv /rust_http_server/target/release/rust_http_server /rust_http_server.bin
RUN rm -rf /rust_http_server
RUN groupadd -r app && useradd -r -g app app
RUN chown app /rust_http_server.bin

USER app
VOLUME /list.txt
EXPOSE 3000
CMD ["/rust_http_server.bin", "/list.txt"]
