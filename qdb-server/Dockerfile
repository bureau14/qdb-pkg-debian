FROM ubuntu:20.04

# Fixing debconf warning about TERM
ENV        DEBIAN_FRONTEND teletype

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils iproute2 jq less locales net-tools dnsutils telnet wget \
    && apt-get clean

RUN locale-gen en_US.UTF-8

COPY qdb-server*.deb .
RUN dpkg -i qdb-server*.deb

# Add the wrapper script
ADD        qdbd-docker-wrapper.sh /opt/qdb/scripts/

# Hack for docker wrapper
RUN        chmod 777 /etc/qdb/qdbd.conf
RUN        chmod +x /etc/qdb/qdbd.conf


# Always launch qdb process
ENTRYPOINT ["/opt/qdb/scripts/qdbd-docker-wrapper.sh"]
