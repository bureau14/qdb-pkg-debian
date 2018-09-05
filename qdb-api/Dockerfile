FROM solita/ubuntu-systemd

RUN apt-get update \
    && apt-get install -y locales \
    && apt-get clean

RUN locale-gen en_US.UTF-8

COPY qdb-api*.deb .
RUN dpkg -i qdb-api*.deb
