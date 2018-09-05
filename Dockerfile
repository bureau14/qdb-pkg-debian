##
# Dockerfile that functions as the base in which we can build our .deb
# packages, and as such contains the necessary tooling to do this.

FROM ubuntu:latest

RUN apt update \
    && apt upgrade -y \
    && apt install -y binutils \
                      gettext \
                      openssl \
    && apt clean
