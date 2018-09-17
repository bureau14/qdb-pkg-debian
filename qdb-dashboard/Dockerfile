FROM bureau14/qdb-pkg-debian/qdb-rest

COPY qdb-dashboard*.deb .
RUN dpkg -i qdb-dashboard*.deb

RUN cat /etc/qdb/qdb_rest.conf \
    | jq ".assets = \"/var/lib/qdb/assets\"" \
    > /tmp/qdb_rest.conf.new && \
    mv /tmp/qdb_rest.conf.new /etc/qdb/qdb_rest.conf && \
    chown qdb:qdb /etc/qdb/qdb_rest.conf
