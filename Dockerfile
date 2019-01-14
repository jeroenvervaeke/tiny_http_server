# This dockerfile consists of 2 images
# - a build image based on rust:latest
# - a runtime image based on scratch
FROM rust:latest AS build-env

# We need musl-dev & musl-tools to perform static linking on our rust binaries
RUN apt-get update && apt-get install -y musl-dev musl-tools
RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /app

# Create a src directory with the smallest possible rust program in it
# Reason we do this is we can only restore dependencies using 'cargo build'
# and 'cargo build' requires a program to compile: our empty program
RUN mkdir src
RUN echo "fn main() {}" > src/main.rs

# Copy the cargo files (dependencies) and build the program (restore dependencies)
COPY Cargo.* ./
RUN cargo build --release --target x86_64-unknown-linux-musl

# Copy the rest of the source code and build it
# We touch the src file to make sure the code is rebuild
COPY src src
RUN touch src/main.rs
RUN cargo build --release --target x86_64-unknown-linux-musl

# Build the runtime image using the scratch base image
# and copy our statically build webserver to the root directory of the image
FROM scratch
COPY --from=build-env /app/target/x86_64-unknown-linux-musl/release/tiny_http_server /

# Expose port 8080 and make our web directory accesible from the outside
EXPOSE 8080
VOLUME /var/www/
WORKDIR /var/www/

# Start the http server
ENTRYPOINT ["/tiny_http_server"]
