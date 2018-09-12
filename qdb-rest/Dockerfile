FROM bureau14/qdb-pkg-debian/qdb-api

COPY qdb-rest*.deb .
RUN dpkg -i qdb-rest*.deb
RUN systemctl enable qdb_rest
