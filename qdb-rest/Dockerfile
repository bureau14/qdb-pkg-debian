FROM bureau14/qdb-pkg-debian/qdb-api

RUN apt install -y iproute \
    jq \
    locales \
    nano \
    net-tools \
    openssl \
    wget \
    && apt clean

COPY qdb-rest*.deb .
RUN dpkg -i qdb-rest*.deb
RUN systemctl enable qdb_rest

RUN cat /etc/qdb/qdb_rest.conf \
    | jq ".allowed_origins = [\"http://0.0.0.0:3449\"]" \
    | jq ".cluster_uri = \"qdb://qdb-server:2836\"" \
    | jq ".host = \"0.0.0.0\"" \
    | jq ".port = 40000" \
    | jq ".assets = \"/var/lib/qdb/assets\"" \
    > /tmp/qdb_rest.conf.new && \
    mv /tmp/qdb_rest.conf.new /etc/qdb/qdb_rest.conf && \
    chown qdb:qdb /etc/qdb/qdb_rest.conf
