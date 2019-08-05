#### How to run docker image with PostreSQL

docker run --name go-postgres -e POSTGRES_PASSWORD=TestSecret -e POSTGRES_DB=peopledatabase -p 5432:5432 -d postgres:12-alpine

#### Database migration 

$ go get -v github.com/rubenv/sql-migrate/...

CREATE DATABASE peopleDatabase;

CREATE TABLE peopleinfo (
birthday text,
names text,
occupation text
);

#### PgAdmin

    docker run -p 555:80 \
        -e "PGADMIN_DEFAULT_EMAIL=user@domain.com" \
        -e "PGADMIN_DEFAULT_PASSWORD=SuperSecret" \
        -d dpage/pgadmin4
        
    
export DBPORT=5432
export DBHOST=localhost
export DBUSER=postgres
export DBPASS=TestSecret
export DBNAME=peopledatabase
    
docker run -v /Users/sergii.marchenko/go/src/github.com/s-marchenko/postgresql-go/migrations:/migrations --network host migrate/migrate -path=/migrations/ -database postgres://postgres:TestSecret@172.17.0.2:5432/peopledatabase?sslmode=disable up 1

postgres://username:password@localhost/dbname