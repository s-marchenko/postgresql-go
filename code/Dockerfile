FROM alpine

ENV DBPORT=5432
ENV DBHOST=172.17.0.2
ENV DBUSER=postgres
ENV DBPASS=TestSecret
ENV DBNAME=peopledatabase

COPY website /
COPY static /static

CMD ["/website"]