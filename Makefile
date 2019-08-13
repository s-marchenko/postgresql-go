clean-db:
	docker rm -f go-postgres
	docker run --name go-postgres -e POSTGRES_PASSWORD=TestSecret -e POSTGRES_DB=peopledatabase -p 5432:5432 -d postgres:12-alpine
	sleep 2

migrate:
	docker run -v /Users/sergii.marchenko/go/src/github.com/s-marchenko/postgresql-go/code/migrations:/migrations --network host migrate/migrate -path=/migrations/ -database postgres://postgres:TestSecret@172.17.0.2:5432/peopledatabase?sslmode=disable up 1

clean_migrate: clean-db migrate

build_mac:
	cd code && \
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o release/website_darwin_amd64 . && \
	cp -R static release/static

build_linux:
	cd code && \
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o release/website_linux_amd64 . && \
	cp -R static release/static

build_docker: build_linux
	cd code && \
	docker build -t website -f Dockerfile .

docker_run: build_docker
	docker run -p 8080:8080 website

docker_rm:
	docker rm $(docker ps -a | grep "website" | awk '{ print $1 }')
	docker rm $(docker ps -a | grep "migrate/migrate" | awk '{ print $1 }')
	docker rmi $(docker images | grep "website" | awk '{ print $3 }')

