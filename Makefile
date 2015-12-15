all: /bin/docker-rd_web bin/docker-rd_ecs_info

bin:
	mkdir -p bin

bin/docker-rd_web: bin
	go build -o ./bin/docker-rd_web ./cmd/web

bin/docker-rd_ecs_info: bin
	go build -o ./bin/docker-rd_ecs_info ./cmd/ecs_info_service

.PHONY: clean web ecs_info
clean:
	@rm -fR ./bin

web: bin/docker-rd_web
ecs_info: bin/docker-rd_ecs_info
