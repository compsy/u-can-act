.DEFAULT_GOAL := all

all: swagger build-swagger

swagger:
	bin/swagger

build-swagger:
	rm -rf vsv-ruby-api
	docker run --rm -u $$(id -u):$$(id -g) -v $(PWD):/local swaggerapi/swagger-codegen-cli:2.4.43 generate -i /local/swagger/v1/swagger.json -l ruby -c /local/swagger-config.json -o /local/vsv-ruby-api
