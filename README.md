# Tiny http server
Tiny http docker server written in rust.

## Specs
| Description | Value      |
| ----------- | ---------- |
| Image size  |   12.1MB   |
| Mem usage   |   4.6MB    |

## How to use the image
`docker run -d -p 80:8080 -v $PWD:/var/www jeroenvervaeke/tiny_http_server:latest`

## How to build the image
`docker build -t tiny_http_server .`