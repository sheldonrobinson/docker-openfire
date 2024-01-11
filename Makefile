all: build

build:
	@docker build --tag=sjrobinsonconsulting/openfire .

release: build
	@docker build --tag=sjrobinsonconsulting/openfire:$(shell cat VERSION) .
