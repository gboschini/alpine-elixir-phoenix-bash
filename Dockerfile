FROM elixir:1.7-alpine
LABEL maintainer="https://github.com/gboschini"

#
# Install system dependencies
#
RUN apk update && \
    apk --no-cache --update add \
    git make g++ wget curl inotify-tools
#
# Install bash and rtools
#
RUN apk add --no-cache \
    bash gawk sed grep coreutils

#
# Install npm
#
RUN apk add nodejs nodejs-npm && \
        npm install npm -g --no-progress && \
        update-ca-certificates --fresh && \
        rm -rf /var/cache/apk/*

# Creates app folder and user
RUN mkdir /app \
    && chmod -R 777 /app

WORKDIR /app

# Install Elixir's rebar, hex, and phoenix
RUN mix local.rebar --force \
    && mix local.hex --force \
    && mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force

