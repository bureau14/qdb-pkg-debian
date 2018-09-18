FROM bureau14/qdb-pkg-debian/qdb-api

RUN apt install -y curl

COPY qdb-utils*.deb .
RUN dpkg -i qdb-utils*.deb
