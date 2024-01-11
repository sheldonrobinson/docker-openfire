all: build

build:
	@docker build --tag=sheldonrobinson/openfire .

release: build
	@docker build --tag=sheldonrobinson/openfire:$(shell cat VERSION) .
	@docker push sheldonrobinson/openfire:latest
	@docker push sheldonrobinson/openfire:$(shell cat VERSION)
