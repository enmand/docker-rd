CGO_ENABLED:=0
ifndef GOOS
	GOOS:=$(shell echo $(shell uname) | tr A-Z a-z:w)
endif
CROSSCOMPILE:=CGO_ENABLED=$(CGO_ENABLED) GOOS=$(GOOS)

WEB_SERVICE=docker-rd_web
ECS_INFO_SERVICE=docker-rd_ecs_info

TEMPDOCKERFILEWEB := $(shell mktemp $(WEB_SERVICE).XXXXX)
TEMPDOCKERFILEECSINFO := $(shell mktemp $(ECS_INFO_SERVICE).XXXXX)

all: web ecs_info

bin:
	mkdir -p bin

bin/docker-rd_web: godep bin
	$(CROSSCOMPILE) godep go build -o ./bin/$(WEB_SERVICE) ./cmd/web

bin/docker-rd_ecs_info: godep bin
	$(CROSSCOMPILE) godep go build -o ./bin/$(ECS_INFO_SERVICE) ./cmd/ecs_info_service

.PHONY: godep clean web ecs_info docker docker-compose
godep:
	go get github.com/tools/godep
clean:
	@rm -fR ./bin

web: bin/docker-rd_web
ecs_info: bin/docker-rd_ecs_info

docker: docker-web-image docker-ecs_info-image

docker-ecs_info-image:
	m4 -DSERVICE=$(ECS_INFO_SERVICE) Dockerfile.m4 > $(TEMPDOCKERFILEECSINFO)
	docker build -t enmand/$(ECS_INFO_SERVICE) -f $(TEMPDOCKERFILEECSINFO) .
	rm $(TEMPDOCKERFILEECSINFO)

docker-web-image:
	m4 -DSERVICE=$(WEB_SERVICE) Dockerfile.m4 > $(TEMPDOCKERFILEWEB)
	docker build -t enmand/$(WEB_SERVICE) -f $(TEMPDOCKERFILEWEB) .
	rm $(TEMPDOCKERFILEWEB)

docker-compose: docker
	docker-compose start && docker-compose up
