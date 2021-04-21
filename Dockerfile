FROM ysbaddaden/crystal-alpine:latest as builder

RUN apk update
RUN apk add openssl-dev yaml-dev nodejs

WORKDIR /src

COPY shard.* /src/
RUN shards

COPY . /src
RUN rm -rf node_modules
RUN npm install

RUN crystal build src/t.proton.name.cr

FROM alpine:latest

RUN apk add --update gc openssl yaml pcre libevent libgcc

RUN mkdir /app
WORKDIR /app
COPY config /app/config
COPY public /app/public
COPY --from=builder /src/node_modules /app/node_modules
COPY --from=builder /src/t.proton.name /app/

CMD ["/app/t.proton.name"]
