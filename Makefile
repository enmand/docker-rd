all: web imageprocessing_service

bin:
	mkdir -p bin

web: bin
	go build -o ./bin/web ./cmd/web

imageprocessing_service: bin
	go build -o ./bin/imageprocessing_service ./cmd/imageprocessing_service

clean:
	@rm -fR ./bin
