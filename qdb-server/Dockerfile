FROM solita/ubuntu-systemd

RUN apt-get update \
        && apt-get install -y iproute \
                              jq \
                              locales \
                              net-tools \
                              wget \
    && apt-get clean

RUN locale-gen en_US.UTF-8

COPY qdb-server*.deb .
RUN apt-get install -y ./qdb-server*.deb

COPY fix-config.sh /

# Hack for /fix-config.sh
RUN chmod 777 /etc/qdb/qdbd.conf
RUN chmod 777 /fix-config.sh


RUN cat /usr/lib/systemd/system/qdbd.service \
    | sed '/\[Service\]/a ExecStartPre=/fix-config.sh' \
    | grep -v 'User=' \
    | grep -v 'Group=' \
    > /usr/lib/systemd/system/qdbd.service.new \
    && mv /usr/lib/systemd/system/qdbd.service.new /usr/lib/systemd/system/qdbd.service


RUN systemctl enable qdbd
