FROM alpine

ENV DBPORT=5432
ENV DBHOST=172.17.0.2
ENV DBUSER=postgres
ENV DBPASS=TestSecret
ENV DBNAME=peopledatabase

COPY release/website_linux_amd64 /
COPY release/static /static

CMD ["/website_linux_amd64"]