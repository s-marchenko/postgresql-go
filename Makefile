clean-db:
	docker rm -f go-postgres
	docker run -d --name go-postgres \
	-e POSTGRES_PASSWORD=TestSecret \
	-e POSTGRES_DB=peopledatabase \
	-p 5432:5432 \
	--add-host=host.docker.internal:host-gateway \
	postgres:12-alpine
	sleep 2

migrate:
	docker run -rm -v $(shell pwd)/code/migrations:/migrations \
	--network host migrate/migrate -path=/migrations/ \
	-database postgres://postgres:TestSecret@172.17.0.2:5432/peopledatabase?sslmode=disable up 1

clean_migrate: clean-db migrate

build_mac:
	cd code && \
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 packr build -o release/website_darwin_amd64 .

build_linux:
	cd code && \
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 packr build -o release/website_linux_amd64 .

build_docker: build_linux
	cd code && \
	docker build -t website -f Dockerfile .

docker_run: build_docker
	docker run -p 8080:8080 \
	--env DBPORT='5432' \
	--env DBHOST='host.docker.internal' \
	--env DBUSER=postgres \
	--env DBPASS=TestSecret \
	--env DBNAME=peopledatabase \
	website

docker_rm:
	docker rm $(docker ps -a | grep "website" | awk '{ print $1 }')
	docker rmi $(docker images | grep "website" | awk '{ print $3 }')
	## docker rm $(docker ps -a | grep "migrate/migrate" | awk '{ print $1 }')