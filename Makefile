clean-db:
	docker rm -f go-postgres
	docker run --name go-postgres -e POSTGRES_PASSWORD=TestSecret -e POSTGRES_DB=peopledatabase -p 5432:5432 -d postgres:12-alpine

migrate:
	docker run -v /Users/sergii.marchenko/go/src/github.com/s-marchenko/postgresql-go/code/migrations:/migrations --network host migrate/migrate -path=/migrations/ -database postgres://postgres:TestSecret@172.17.0.2:5432/peopledatabase?sslmode=disable up 1

clean_migrate: clean-db
	sleep 2
	docker run -v /Users/sergii.marchenko/go/src/github.com/s-marchenko/postgresql-go/code/migrations:/migrations --network host migrate/migrate -path=/migrations/ -database postgres://postgres:TestSecret@172.17.0.2:5432/peopledatabase?sslmode=disable up 1

build_mac:
	cd code && \
	go build -o website .

build_linux:
	cd code && \
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o website .

build_docker: build_linux
	cd code && \
	docker build -t website -f Dockerfile .

docker_run: build_docker
	docker run -p 8080:8080 website