.DEFAULT_GOAL := all

all: swagger build-swagger

swagger:
	bin/swagger

build-swagger:
	rm -rf vsv-ruby-api
	java -jar bin/swagger-codegen.jar generate -i swagger/v1/swagger.json -l ruby -c swagger-config.json -o vsv-ruby-api
