FROM rust:latest AS build-env
RUN apt-get update && apt-get install -y musl-dev musl-tools
RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /app
RUN mkdir src
RUN echo "fn main() {}" > src/main.rs

# First copy the Cargo files
COPY Cargo.* ./
RUN cargo build --release --target x86_64-unknown-linux-musl

# Copy the rest of the source code
COPY src src
RUN touch src/main.rs
RUN cargo build --release --target x86_64-unknown-linux-musl

# Build the runtime image
FROM scratch
COPY --from=build-env /app/target/x86_64-unknown-linux-musl/release/tiny_http_server /

EXPOSE 8080
VOLUME /var/www/
WORKDIR /var/www/

ENTRYPOINT ["/tiny_http_server"]
