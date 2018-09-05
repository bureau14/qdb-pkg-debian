FROM bureau14/qdb-pkg-debian/qdb-api

COPY qdb-api-rest*.deb .
RUN dpkg -i qdb-api-rest*.deb
RUN systemctl enable qdb_api_rest
