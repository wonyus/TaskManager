build:
	docker-compose -f ./docker-compose.yml build --no-cache
deploy:
	docker-compose -f .\docker-compose.yml up -d
